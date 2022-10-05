# Starting files for workflow
```
workflow/data/
	arabidopsis_thaliana.gff # ARAPORT11 genome annotation of Arabidopsis thaliana, acquired from phytozome
	arabidopsis_thaliana.fa # TAIR 10 assembly of Arabidopsis thaliana genome, acquired from phytozome
	chroms.txt # list of chromosome names for Arabidopsis thaliana genome assembly (TAIR 10)
	SraRunInfo_arabidopsis_thaliana.csv # SRA run info for 1135 arabidopsis genomes, downloaded from SRA on 2022-09-29
```

## Search method for genotype data (2022-10-05)

My search for plant genotype data was restricted to only species with reference genomes on phytozome. I then would type each species name into the SRA search bar and restrict matches to the Organism field (example: Arabidopsis lyrata[Organism]) and then further filter for samples sourced from DNA. I would then download the Run info from the search and then look at the bioprojects with the highest number of SRA samples.
