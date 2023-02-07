# PARAMETERS
print("Parsing arguments...")
args = commandArgs(trailingOnly=TRUE)

# list of needed packages
package_list = c()

# list of needed columns from gbif data
kept_columns = c("species", "decimalLongitude", "decimalLatitude", "countryCode", "individualCount",
         "gbifID", "family", "taxonRank", "coordinateUncertaintyInMeters", "year",
         "basisOfRecord", "institutionCode", "datasetName")
# species
species = args[1]

# name of output file
today = Sys.Date()
output_plot_name = paste(species, "_raw_gbif_data_", today, ".png", sep = "")
output_table_name = paste(species, "_raw_gbif_data_", today, ".txt", sep = "")


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


# INPUT: character vector of species name
# OUTPUT: dataframe of occurence data for species
search_gbif = function(species, kept_columns){

	#obtain data from GBIF via rgbif
	print("Searching GBIF for occurence data")
	dat = occ_search(scientificName = species, hasCoordinate = T)

	# get just data from list
	print("Extracting occurence data from search results...")
	dat = dat$data

	# select just columns of interest
	print("Subsetting only columns of interest for cleaning later...")
	dat = dat[,kept_columns]

	# return result
	print("Returning result...")
	return(dat)
}



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

# combine the above functions into one workflow
main = function(package_list, species, kept_columns, output_plot_name, output_table_name){
	
	# load packages
	load_packages(package_list)

	# search gbif for occurence data
	all_data = search_gbif(species, kept_columns)

	# plot gbif data
	plot_gbif(all_data, output_plot_name)

	# write gbif output
	write.table(all_data, output_table_name, row.names = F, quote = F)

}

# execute workflow
main(package_list, species, kept_columns, output_name)
