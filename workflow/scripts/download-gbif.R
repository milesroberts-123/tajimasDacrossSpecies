# PARAMETERS
print("Parsing arguments...")
args = commandArgs(trailingOnly=TRUE)
package_list = c("rgbif", "rworldmap", "ggplot2", "stringr") # list of needed packages
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
output_table_name = paste(gsub(" ", "_", species), "_raw_gbif_data.txt", sep = "") # name of output table

# Print parameters to console
print(species)
print(output_plot_name)
print(output_table_name)

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
		limit = 500, 
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

# combine the above functions into one workflow
main = function(package_list, species, kept_columns, output_plot_name, output_table_name){
	
	# load packages
	load_packages(package_list)

	# search gbif for occurence data
	all_data = search_gbif(species, kept_columns)

	# plot gbif data
	plot_gbif(all_data, output_plot_name)

	# write gbif output
	write.table(all_data, output_table_name, row.names = F, quote = F, sep = ";")

}

# execute workflow
main(package_list, species, kept_columns, output_plot_name, output_table_name)
