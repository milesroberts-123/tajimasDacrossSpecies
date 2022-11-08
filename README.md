# Starting files for workflow
```
workflow/data/
	annotations/ # gffs of genome sequences, genus_species.gff
	assemblies/ # fasta files of genome sequences, genus_species.fa
	chromosomes/ # text files with chromosome names, used for parallelization of genotype calling, genus_species_chroms.txt	
	samples_pe.tsv # paired-end samples
	samples_se.tsv # single-end samples
```

# Search method for genotype data (2022-10-05)

My search for plant genotype data was restricted to only species with reference genomes on phytozome. I then would type each species name into the SRA search bar and restrict matches to the Organism field (example: Arabidopsis lyrata[Organism]) and then further filter for samples sourced from DNA. I would then download the Run info from the search and then look at the bioprojects with the highest number of SRA samples.

