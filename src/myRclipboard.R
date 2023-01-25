# To get run numbers for panicum halli
# Copy bioprojects from table S1 in this publication: https://doi.org/10.1038/s41467-018-07669-x
# to a list in doc/panicum_halli_search.txt
# then use regular expressions to make a query to be used with ENTREZ
# cat panicum_halli_search.txt | tr '\n' ' ' | sed 's/ / OR /g'
# esearch -db sra -query $QUERY | efetch --format runinfo > panicum_halli.csv

# Arabidopsis lyrata bioprojects
PRJNA357693
PRJEB30473

#
SraRunInfo_arabidopsis_lyrata_PRJEB23202.csv.gz
SraRunInfo_arabidopsis_lyrata_PRJEB30473.csv.gz
SraRunInfo_arabidopsis_lyrata_PRJNA284572.csv.gz

#
#obtain data from GBIF via rgbif
dat <- occ_search(scientificName = "Panthera leo", limit = 5000, hasCoordinate = T)

dat <- dat$data

# names(dat) #a lot of columns

#select columns of interest
dat <- dat %>%
  dplyr::select(species, decimalLongitude, decimalLatitude, countryCode, individualCount,
         gbifID, family, taxonRank, coordinateUncertaintyInMeters, year,
         basisOfRecord, institutionCode, datasetName)
         
#plot data to get an overview
wm <- borders("world", colour="gray50", fill="gray50")
ggplot()+ coord_fixed()+ wm +
  geom_point(data = dat, aes(x = decimalLongitude, y = decimalLatitude),
             colour = "darkred", size = 0.5)+
  theme_bw()

# https://github.com/vsbuffalo/paradox_variation/blob/master/R/range_funcs.r
# get continent from coordinates  
countriesSP <- rworldmap:::getMap(resolution='low')
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

#
y = spTransform(x, CRS("+proj=longlat +datum=WGS84"))

# draw convex hulls
# "proj.4" notation of CRS
projection(cn) <- "+proj=longlat +datum=WGS84"
# the CRS we want
laea <- CRS("+proj=laea  +lat_0=0 +lon_0=-80")
clb <- spTransform(cn, laea)
pts <- spTransform(sp, laea)
plot(clb, axes=TRUE)
points(pts, col='red', cex=.5)
# get the (Lambert AEA) coordinates from the SpatialPointsDataFrame
xy <- coordinates(pts)
# draw convex hulls on projected points
hull <- list()
for (s in 1:length(sp)) {
    p <- unique(xy[pts$SPECIES == sp[s], ,drop=FALSE])
    # need at least three points for hull
    if (nrow(p) > 3) {
        h <- convHull(p, lonlat=FALSE)
        pol <- polygons(h)
        hull[[s]] <- pol
    }
}
# combine hulls
# which elements are NULL
i <- which(!sapply(hull, is.null))
h <- hull[i]
# combine them
hh <- do.call(bind, h)
plot(hh)
# calculate area of hulls
ahull <- sapply(hull, function(i) ifelse(is.null(i), 0, area(i)))
plot(rev(sort(ahull))/1000, ylab='Area of convex hull')





# https://babichmorrowc.github.io/post/2019-03-18-alpha-hull/
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
