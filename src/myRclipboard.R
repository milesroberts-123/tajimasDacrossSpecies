# To get run numbers for panicum halli
# Copy bioprojects from table S1 in this publication: https://doi.org/10.1038/s41467-018-07669-x
# to a list in doc/panicum_halli_search.txt
# then use regular expressions to make a query to be used with ENTREZ
# cat panicum_halli_search.txt | tr '\n' ' ' | sed 's/ / OR /g'
# esearch -db sra -query $QUERY | efetch --format runinfo > panicum_halli.csv