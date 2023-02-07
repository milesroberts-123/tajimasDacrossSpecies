# A helpful vignette for learning how to clean gbif data
# https://cran.r-project.org/web/packages/CoordinateCleaner/vignettes/Cleaning_GBIF_data_with_CoordinateCleaner.html

package_list = c("CoordinateCleaner", "ggplot2", "rgbif", "countrycode")

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


# Flag records
# INPUT: raw occurence data
# OUTPUT: cleaned occurence data and flags
flag_records = function(data){

#convert country code from ISO2c to ISO3c
data$countryCode <-  countrycode(data$countryCode, origin =  'iso2c', destination = 'iso3c')

#flag problems
data <- data.frame(data)
flags <- clean_coordinates(x = data, 
                           lon = "decimalLongitude", 
                           lat = "decimalLatitude",
                           countries = "countryCode",
                           species = "species")

# output flags
return(flags)

}

# Remove problematic records
# INPUT: raw occurence data, flags
# OUTPUT: cleaned occurence data
remove_bad_records = function(data, flags){
	#Exclude problematic records
	data_clean <- data[flags$.summary,]
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

# Combine above functions into one workflow
main = function(package_list, input_file_name, output_plot_name, output_file_name){

	# load packages
	load_packages(package_list)

	# load occurence data from previous script in workflow
	data = load_occurence_data(input_file_name)

	# perform automatic tests for suspicious records
	flags = flag_records(data)

	# remove suspicious records
	data_clean = remove_bad_records(data, flags)
	
	# plot cleaned gbif data on world map for comparison purposes
	plot_gbif(data_clean, output_plot_name)
	
	# save cleaned data table for next step in workflow (alpha hull fitting)
	write.table(data_clean, output_file_name)
}
