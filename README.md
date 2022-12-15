# Contents

[Summary](#summary)

[How to replicate my results](#How-to-replicate-my-results)

[Input files for workflow](#input-files-for-workflow)

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

* analyze read data from multiple species simultaneously (in progress)

* parallelize computations by splitting data by chromsome

* merge technical replicates after read trimming

* work with both paired-end and single-end data

* work either as a set of environment modules (specific to the MSU ICER HPCC), a set of conda environments, or as a Docker container

* retain invariant sites during SNP calling

* perform steps that are often omitted from online tutorials (such as building indices of reference genomes for BWA, GATK, and Picard)

* output metrics for called variants before filtering (useful for determining if filters were appropriate)

This workflow will **not** work if:

* Some replicates of a given sample are single-end, but others are paired-end. To resolve this, either throw out read two of the paired-end replicates (treating them as single end) or throw out the single-end reads (leaving only paired-end).

# How to replicate my results

The scripts in src/ should be run in their numbered order to replicate my results.

## prepare metadata for workflow

The `src/s00_organizeSRAdata.Rmd` script takes data in workflow/data/SRArunInfo and structures it into `data/samples.tsv` so that it can be churned through snakemake workflow.

## Run workflow with conda envs

An example script can be found in `src/s02_snakemake.bash`

## Run workflow with the MSU ICER HPCC modules

Find an example script in `src/s01_snakemake.bash`

**I highly recommend that you use conda environments instead!** This method for running the workflow is specific only to the ICER HPCC and will probably break if the modules on the HPCC are updated. I mainly keep this note in the readme for my own reference.

Nonetheless, if you want to do this you will need to add the following to `/workflow/scripts/`

* [degenotate](https://github.com/harvardinformatics/degenotate)

* [fastp](https://github.com/OpenGene/fastp)

To get degenotate, clone degenotate github repo into `workflow/scripts`:

```
cd workflow/scripts

git clone https://github.com/OpenGene/fastp.git
```

You can then update degenotate by doing into the degenotate folder and using the `git fetch` then `git pull` commands

```
git fetch

git pull
```

Go to the fastp github repo and download the latest linux binary, add this to the scripts folder and make it executable with `chmod +x fastp`

# Input files for workflow

This how I eventually want the input data for the workflow to be organized

```
workflow/data/
	annotations/ # gffs of genome sequences, naming convention: genus_species.gff3
	assemblies/ # fasta files of genome sequences, naming convention: genus_species.fa
	chromosomes/ # text files with chromosome names, used for parallelization of genotype calling, naming convention: genus_species_chroms.txt	
	SRArunInfo/ # comma-separated files of meta-data for SRA runs, organized into samples.tsv using code in src/ before workflow begins
	samples.tsv # tab-separated text file listing read metadata with these columns: run, replicate, layout, genome
```

See `workflow/dag.svg` for an example of my snakemake workflow executed on a handful of samples.

# Updating the repo

```
# From workflow/
# check if workflow builds successfully
snakemake -n

# build directed acyclic graph if you added or removed steps
snakemake --dag | dot -Tsvg > dag.svg

# update docker file if you changed the conda environments
snakemake --containerize > Dockerfile

# push changes to github
cd ..

git add --all

git ls-files # check that correct files are being pushed to repo

git commit -m "my update message"

git push -u origin main
```
 
# To do

* memory requirements of dissimilarity calculations should scale with the dataset input size

* fully separate multi-threaded and single-threaded steps

* extend workflow to work with multiple species

# Notes

## search methods for genotype data

My search for plant genotype data was restricted to only species with reference genomes on phytozome. I then would type each species name into the SRA search bar and restrict matches to the Organism field (example: Arabidopsis lyrata[Organism]) and then further filter for samples sourced from DNA. I would then download the Run info from the search and then look at the bioprojects with the highest number of SRA samples.

To get the CSV for Boechera stricta run numbers I searched "Boechera stricta Reference Population" on the SRA.

## installing updated snakemake

The snakemake installation on the MSU HPCC is v4, but I want v7 so that I can use the `--containerize` functions

```
# create environment
conda create --name snakemake

# install snakemake in environment
conda install -c bioconda snakemake

# install mamba too, a faster replacement for conda
conda install -n base -c conda-forge mamba
```
