# Contents

[Summary](#summary)

[How to replicate my results](#How-to-replicate-my-results)

[Input files for workflow](#input-files-for-workflow)

[Dependencies](#dependencies)

[Updating the repo](#updating-the-repo)

[To do](#to-do)

[Notes](#notes)

# Summary

This workflow takes a list of SRA run numbers, separated before-hand as either paired-end or single-end, along with the assembly and annotation of their corresponding reference genomes. It then trims the reads with fastp and executes two different genotype calling pipelines:

1. Align reads to reference genome, then call SNPs and indels at four-fold degenerate sites

2. Count k-mers within reads, omiting k-mers that appear in the coding sequences of *Arabidopsis thaliana*. Then, choose a random subset of k-mers to keep for further analysis. K-mer counts for each genotype are merged into a large matrix and then used to calculate two measures of dissimilarity:

* Jaccard dissimilarity: k-mers are marked as either present (1) or absent (0) based on their count within the whole genome sequencing reads for each genotype. Then you look at the intersection-union ratio for each pair of k-mer sets

* Bray-Curtis dissimilarity: counts are first normalized to sum to one (within each sample) to help control for coverage variation between samples, then you apply [the formula in this paper](https://doi.org/10.1186/s12859-015-0875-7)

In addition, this workflow is designed to:

* parallelize computations by splitting data by chromsome

* analyze read data from multiple species simultaneously (in progress)

* work with both paired-end and single-end data

* work either as a set of environment modules (specific to the MSU ICER HPCC), a set of conda environments, or as a Docker container

* retain invariant sites during SNP calling

* perform steps that are often omitted from online tutorials (such as building indices of reference genomes for BWA, GATK, and Picard)

# How to replicate my results

The scripts in src/ should be run in their numbered order to replicate my results.

```
src/s00_organizeSRAdata.Rmd # take data in workflow/data/SRArunInfo and structure it so that it can be churned through snakemake workflow

src/s01_snakemake.bash # job submission script to run the snakemake workflow on a SLURM HPCC system
```

# Input files for workflow

This how I eventually want the input data for the workflow to be organized

```
workflow/data/
	annotations/ # gffs of genome sequences, naming convention: genus_species.gff3
	assemblies/ # fasta files of genome sequences, naming convention: genus_species.fa
	chromosomes/ # text files with chromosome names, used for parallelization of genotype calling, naming convention: genus_species_chroms.txt	
	SRArunInfo/ # comma-separated files of meta-data for SRA runs, organized into samples_pe.tsv and samples_se.tsv before workflow begins
	samples_pe.tsv # tab-separated text file listing paired-end samples
	samples_se.tsv # tab-separated text file listing single-end samples
	speciesList.csv # list of species included in my analysis
```

See `workflow/dag.svg` for an example of my snakemake workflow executed on four samples (2 paired end, 2 single end) from the same species (*Arabidopsis thaliana*)

# Dependencies

These are in `/workflow/scripts/` and include

* degenotate

* fastp

To get degenotate, clone degenotate github repo into `workflow/scripts`, you can then update degenotate by doing into the degenotate folder and  using the `git fetch` then `git pull` commands

Go to the fastp github repo and download the latest linux binary, add this to the scripts folder and make it executable with `chmod +x fastp`

# Updating the repo

```
# From workflow/
# check if workflow builds successfully
snakemake -n

# build directed acyclic graph if you added or removed steps
snakemake --dag | dot -Tsvg > dag.svg

# push changes to github
cd ..

git add --all

git ls-files # check that correct files are being pushed to repo

git commit -m "update"

git push -u origin main
```
 
# To do

* memory requirements of dissimilarity calculations should scale with the dataset input size

* extend workflow to work with multiple species

* fully separate multi-threaded and single-threaded steps

# Notes

## search methods for genotype data

My search for plant genotype data was restricted to only species with reference genomes on phytozome. I then would type each species name into the SRA search bar and restrict matches to the Organism field (example: Arabidopsis lyrata[Organism]) and then further filter for samples sourced from DNA. I would then download the Run info from the search and then look at the bioprojects with the highest number of SRA samples.

To get the CSV for Boechera stricta run numbers I searched "Boechera stricta Reference Population" on the SRA.
