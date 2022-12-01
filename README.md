# Contents

[Summary](#summary)

[Input files for workflow](#input-files-for-workflow)

# Summary

This workflow takes a list of SRA run numbers, separated before-hand as either paired-end or single-end, along with the assembly and annotation of their corresponding reference genomes. It then trims the reads with fastp and executes two different genotype calling pipelines:

1. Align reads to reference genome, then call SNPs and indels at four-fold degenerate sites

2. Count k-mers within reads, then choose a random subset of k-mers to keep for further analysis. K-mer counts are merged into a large matrix and the counts are normalized to sum to one (within each sample) to control for coverage variation between samples.

Using genotype information from these two different techniques, genetic diversity is then calculated using either nucleotide diversity (SNPs) or bray-curtis dissimilarity (k-mers).

This workflow is designed to:

* parallelize computations by splitting data by chromsome

* analyze read data from multiple species simultaneously

* work with both paired-end and single-end data

* work either as a set of environment modules (specific to the MSU ICER HPCC), a set of conda environments, or as a Docker container

* retain invariant sites during SNP calling

# Input files for workflow
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

To get the CSV for Boechera stricta run numbers I searched "Boechera stricta Reference Population" on the SRA.
