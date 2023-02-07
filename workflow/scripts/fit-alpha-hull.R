# A helpful vignette for learning how to clean gbif data
# https://cran.r-project.org/web/packages/CoordinateCleaner/vignettes/Cleaning_GBIF_data_with_CoordinateCleaner.html

# Parameters
package_list = c("CoordinateCleaner", "ggplot2", "rgbif", "countrycode") # list of needed packages
input_file_name = args[1] # name of cleaned occurence data table
output_file_name = args[2] # name of results table

# Load packages
# Input: character vector of package names to load
# Output: loaded packages
load_packages = function(packages){

        # Install packages if they are not yet installed
        print("Checking if pakcages are not yet installed...")
        installed_packages <- packages %in% rownames(installed.packages())
        if (any(installed_packages == FALSE)) {
                print("Installing needed packages...")
                install.packages(packages[!installed_packages])
        }

        # Packages loading
        print("Loading installed packages...")
        lapply(packages, library, character.only = TRUE)
}

# Load raw occurence data
# INPUT: file name of raw occurence data
# OUTPUT: dataframe of raw occurence data
load_occurence_data = function(file_name){
	read.table(file_name, header = T)
}

# Plot GBIF occurence data
# INPUT: GBIF occurence data
# OUTPUT: plot of species occurences on world map
plot_gbif = function(data, output_plot_name){
        # get map of world borders
        print("Getting map of world borders...")
        wm <- borders("world", colour="gray50", fill="gray50")

        # plot occurence data on world borders
        print("Plotting occurence data on world borders...")
        ggplot() +
                coord_fixed() +
                wm +
                geom_point(data, aes(x = decimalLongitude, y = decimalLatitude), colour = "darkred", size = 0.5) +
                theme_bw()

        # save plot
        print("Saving plot...")
        ggsave(output_plot_name)
}


# separate points by continent, so that I can draw alpha hull for each continent separately
countriesSP <- rworldmap:::getMap(resolution='low')

# get continent from coordinates  
# function from: https://github.com/vsbuffalo/paradox_variation/blob/master/R/range_funcs.r
coords2continent = function(lat, lon) {  
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


# Combine above functions into one workflow
main = function(package_list, input_file_name, output_file_name){

	# load packages
	load_packages(package_list)

	# load occurence data from previous script in workflow
	data = load_occurence_data(input_file_name)

	# continent from coordinates
  data$continent = coords2continent(data$decimalLatitude, data$decimalLongitude)

  # subset to just coordinates
  data = data[,c("decimalLatitude", "decimalLongitude", "continent")]

  # remove records lacking continent
  data = data[!is.na(data$continent),]
  
  # loop over each continent, drawing alpha hull for each and outputing area
  areas = NULL
  for(continent in unique(data$continent)){
    #subset data for one continent
    data_sub = data[(data$continent == continent),]
    
    # draw alpha hull around points
    alphashape = ashape(data_sub$decimalLongitude, data_sub$decimalLatitude, alpha = 200)
  
    # from alpha shape get indices of polygon edges
    pol = ashape2poly(alphashape)

    # swap latitude and longitude, convert to polygon
    mypol = Polygon(data_sub[pol,c(2,1)])
    spatpol = SpatialPolygons(list(Polygons(list(mypol), ID = 1)), proj4string = CRS("+proj=longlat +datum=WGS84"))

    # calculate area, convert to square kilometers (1000 meters x 1000 meters = 1 million square meters per square kilometer)
    area_frame = data.frame(species = species, continent = continent, area = area(spatpol)/1e6)
    areas = rbind(areas, area_frame)
  }
 
  # save results as a dataframe
  write.table(areas, output_file_name, row.names = F, quote = F)
}
