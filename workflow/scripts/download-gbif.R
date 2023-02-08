# PARAMETERS
print("Parsing arguments...")
args = commandArgs(trailingOnly=TRUE)
package_list = c("rgbif", "rworldmap", "ggplot2", "stringr", "alphahull", "igraph", "raster", "rgeos", "maps", "sf") # list of needed packages
kept_columns = c(
	"species", 
	"decimalLongitude",
	"decimalLatitude",
	"countryCode",
	"individualCount",
         "gbifID",
	"family",
	"taxonRank",
	"coordinateUncertaintyInMeters",
	"year",
         "basisOfRecord",
	"institutionCode",
	"datasetName",
	"issues") # list of needed columns from gbif data
species = args[1] # species name
output_plot_name = paste(gsub(" ", "_", species), "_raw_gbif_data.png", sep = "") # name of output plot
output_occ_table_name = paste(gsub(" ", "_", species), "_raw_gbif_data.txt", sep = "") # name of output table
output_area_table_name = paste(gsub(" ", "_", species), "_areas.txt", sep = "") # name of output table

# Print parameters to console
print(species)
print(output_plot_name)
print(output_occ_table_name)
print(output_area_table_name)

# Input: character vector of package names to load
# Output: loaded packages
load_packages = function(packages){

	# Install packages if they are not yet installed
	print("Checking if needed packages are installed...")
	installed_packages <- packages %in% rownames(installed.packages())
	if (any(installed_packages == FALSE)) {
		print("Installing needed packages...")
		install.packages(packages[!installed_packages], repos = "http://cran.us.r-project.org")
	}

	# Packages loading
	print("Loading installed packages...")
	lapply(packages, library, character.only = TRUE)
}

# check if vector of issue codes matches codes in reference vector
# OUTPUT: TRUE/FALSE
check_for_issues = function(x, issues_to_check){
	any(x %in% issues_to_check)
}

# split issue codes by their comma separator
split_issue_codes = function(x){
	unlist(str_split(x, pattern = ","))
}

# INPUT: character vector of species name
# OUTPUT: dataframe of occurence data for species
search_gbif = function(species, kept_columns){

	#obtain data from GBIF via rgbif
	print("Searching GBIF for occurence data...")
	dat = occ_search(
		scientificName = species, 
		hasCoordinate = TRUE, 
		coordinateUncertaintyInMeters = "0,10000", 
		year = "1973,2023", 
		limit = 200, 
		fields = kept_columns,
		basisOfRecord = "HUMAN_OBSERVATION")

	# get just data from list
	print("Extracting occurence data from search results...")
	dat = dat$data

	# select just columns of interest
	# print("Subsetting only columns of interest for cleaning later...")
	# dat = dat[,kept_columns]
	issues_to_check = sort(gbif_issues()[c(-3,-10,-48),1])
	print("Filtering records with these issue codes:")
	print(issues_to_check)

	# check for specific issue codes and remove any records with at least one of said codes
	print("Checking issue codes...")
	data_issues = as.list(dat$issues)
	#print(head(data_issues))
	data_issues = lapply(data_issues, split_issue_codes)
	#print(head(data_issues))
	rows2keep = !(unlist(lapply(data_issues, check_for_issues, issues_to_check)))
	#print(rows2keep)
	dat = dat[rows2keep,]

	print("Example of what occurence matrix looks like:")
	print(head(dat))

	# return result
	print("Returning result...")
	return(dat)
}


# get continent from coordinates
# function from: https://github.com/vsbuffalo/paradox_variation/blob/master/R/range_funcs.r
coords2continent = function(lon, lat, countriesSP) {
  # https://stackoverflow.com/questions/21708488/get-country-and-continent-from-longitude-and-latitude-point-in-r
  points <- data.frame(lon=lon, lat=lat)
  # converting points to a SpatialPoints object
  # setting CRS directly to that from rworldmap
  pointsSP = sp:::SpatialPoints(points, proj4string=sp:::CRS(sp:::proj4string(countriesSP)))

  # use 'over' to get indices of the Polygons object containing each point
  indices = sp:::over(pointsSP, countriesSP)

  #indices$REGION   # returns the continent (7 continent model)
  indices$continent
}


# function from: https://babichmorrowc.github.io/post/2019-03-18-alpha-hull/
ashape2poly <- function(ashape){
  # Convert node numbers into characters
  ashape$edges[,1] <- as.character(ashape$edges[,1])
  ashape_graph <- graph_from_edgelist(ashape$edges[,1:2], directed = FALSE)
  if (!is.connected(ashape_graph)) {
    stop("Graph not connected")
  }
  if (any(degree(ashape_graph) != 2)) {
    stop("Graph not circular")
  }
  if (clusters(ashape_graph)$no > 1) {
    stop("Graph composed of more than one circle")
  }
  # Delete one edge to create a chain
  cut_graph <- ashape_graph - E(ashape_graph)[1]
  # Find chain end points
  ends = names(which(degree(cut_graph) == 1))
  path = get.shortest.paths(cut_graph, ends[1], ends[2])$vpath[[1]]
  # this is an index into the points
  pathX = as.numeric(V(ashape_graph)[path]$name)
  # join the ends
  pathX = c(pathX, pathX[1])
  return(pathX)
}


# INPUT: GBIF occurence data
# OUTPUT: plot of species occurences on world map
plot_gbif = function(data, output_plot_name){
	# get map of world borders
	print("Getting map of world borders...")
	wm <- borders("world", colour="gray50", fill="gray50")

	# plot occurence data on world borders
	print("Plotting occurence data on world borders...")
	ggplot(data, aes(x = decimalLongitude, y = decimalLatitude)) +
		coord_fixed() +
		wm +
		geom_point(colour = "darkred", size = 0.5) +
		theme_bw()

	# save plot
	print("Saving plot...")
	ggsave(output_plot_name)
}


# Calculate the difference between a species range and bodies of water
# INPUT: spatial polygon of species range
# OUTPUT: spatial polygon of species range - overlap with land to leave just range overlapping with water
get_diff_bw_world_and_hull = function(spatpol){
	# function inspired by: https://stackoverflow.com/questions/49266736/clip-spatial-polygon-by-world-map-in-r
	sf_use_s2(FALSE)

        # world data
	print("loading world data...")
        data("wrld_simpl", package = 'maptools')

        # coerce sp object to sf
        print("converting sp objects to sf...")
	world <- st_as_sf(wrld_simpl)
        rectangle <- st_as_sf(spatpol)

        # difference between world polygons and the rectangle
        print("calculating difference...")
	difference <- st_difference(rectangle, st_union(world))

        # coerce back to sp
	print("convert sf back to sp...")
        difference <- as(difference, 'Spatial')

	return(difference)
        # plot the result
        # plot(difference)
}

# split up occurence data by continent, fit alpha hull and calculate area for each continent
area_by_continent = function(data, output_plot_name, output_area_table_name){

	# output vector for list of areas
        areas = NULL

        # loop over each continent, drawing alpha hull for each and outputing area
        for(continent in unique(data$continent)){
		#subset data for one continent
		print("Measuring range area for this continent:")
                print(continent)
                data_sub = data[(data$continent == continent),]

                # draw alpha hull around points
                print("Drawing alpha hull around points...")
                alphashape = ashape(data_sub$decimalLongitude, data_sub$decimalLatitude, alpha = 400)

                # from alpha shape get indices of polygon edges
                print("Extracting polygon edges...")
                pol = ashape2poly(alphashape)

                # convert to polygon
                print("Building spatial polygon...")
                mypol = Polygon(data_sub[pol,c(1,2)])
                spatpol = SpatialPolygons(list(Polygons(list(mypol), ID = 1)), proj4string = CRS("+proj=longlat +datum=WGS84"))

		# get difference between spatial polygon and world map
		print("Getting difference between spatial polygon and world map...")
		waterpol = get_diff_bw_world_and_hull(spatpol)

                # calculate area, convert to square kilometers (1000 meters x 1000 meters = 1 million square meters per square kilometer)
                print("Measuring polygon area...")
                area_frame = data.frame(species = species, continent = continent, area = area(spatpol)/1e6, water_area = area(waterpol)/1e6)
                areas = rbind(areas, area_frame)
        
		#print("Coordinates of hull:")
		#print(data_sub[pol[-1],])

		# plot hull on world map
		print("Getting map of world borders...")
		wm <- borders("world", colour="gray50", fill="gray50")

		#print("spatial polygon of world")
		#print(map(database = "world", plot = F))
		#worldpol = SpatialPolygons(list(Polygons(list(map(database = "world", plot = F)[c("x", "y")]), ID = 1)), proj4string = CRS("+proj=longlat +datum=WGS84"))
		#print(worldpol)

		print("Plotting occurence data on world borders...")
		ggplot(data_sub, aes(x = decimalLongitude, y = decimalLatitude)) +
			wm +
			geom_point(colour = "darkred", size = 0.5) +
			geom_polygon(data_sub[pol[-1],], mapping = aes(x = decimalLongitude, y = decimalLatitude), fill = "blue", alpha = 0.5) +
			coord_fixed() +
			theme_bw()

		print("Saving plot...")
		ggsave(paste(gsub(" ", "_", continent), "_", output_plot_name, sep = ""))
	}

        # save results as a dataframe
        write.table(areas, output_area_table_name, row.names = F, quote = F)
}

# combine the above functions into one workflow
main = function(package_list, species, kept_columns, output_plot_name, output_occ_table_name, output_area_table_name){
	
	# load packages
	load_packages(package_list)

	# search gbif for occurence data
	all_data = search_gbif(species, kept_columns)

	# plot gbif data
	plot_gbif(all_data, output_plot_name)
	
	# write gbif output
	write.table(all_data, output_occ_table_name, row.names = F, quote = F, sep = ";")

	# separate points by continent, so that I can draw alpha hull for each continent separately
	countriesSP <- rworldmap:::getMap(resolution='low')
	all_data$continent = as.character(coords2continent(all_data$decimalLongitude, all_data$decimalLatitude, countriesSP))
	# print(head(all_data$continent))

	# remove occurences that don't map to a continent
	all_data = all_data[!(is.na(all_data$continent)),]

	# subset to just needed columns
	print("Subsetting to just longlat and continent...")
        all_data = all_data[,c("decimalLongitude", "decimalLatitude", "continent")]
	
	# remove duplicates
	print("Removing duplicate data points...")
	all_data = unique(all_data)
	print("Points remaining after removing duplicates:")
	print(nrow(all_data))

	# measure range on each continent
	area_by_continent(all_data, output_plot_name, output_area_table_name)
}

# execute workflow
main(package_list, species, kept_columns, output_plot_name, output_occ_table_name, output_area_table_name)
