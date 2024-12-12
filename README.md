# Author

Miles Roberts, Michigan State University

# Citation

Preprint DOI: https://www.biorxiv.org/content/10.1101/2024.05.17.594778v3

# Contents

[Summary](#summary)

[How to replicate my results](#How-to-replicate-my-results)

[Inputs](#inputs)

[Outputs](#outputs)

[Notes](#notes)

[To do](#to-do)

# Summary

This workflow takes a list of SRA run numbers, separated before-hand as either paired-end or single-end, along with the assembly and annotation of their corresponding reference genomes. It then trims the reads with fastp and executes two different genotype calling pipelines:

1. Align reads to reference genome, then call SNPs and indels at four-fold degenerate sites

2. Count k-mers within reads, omitting k-mers that appear in the coding sequences of their respective species. Then, choose a random subset of k-mers to keep for further analysis. K-mer counts for each genotype are merged into a large matrix and then used to calculate two measures of dissimilarity:

* Jaccard dissimilarity: k-mers are marked as either present (1) or absent (0) based on their count within the whole genome sequencing reads for each genotype. Then you look at the intersection-union ratio for each pair of k-mer sets

* Bray-Curtis dissimilarity: counts are first normalized to sum to one (within each sample) to help control for coverage variation between samples, then you apply [the formula in this paper](https://doi.org/10.1186/s12859-015-0875-7)

At the same time, the workflow will download GBIF occurrence data and estimate range size.

In addition, this workflow is designed to:

* analyze read data from multiple species simultaneously, including species of varying ploidy

* split data by chromosome/scaffold to parallelize SNP calling

* merge technical replicates (usually technical replicates are defined as two SRA runs that share the same Biosample/Experiment ID)

* work with both paired-end and single-end data

* retain invariant sites during SNP calling

* perform steps that are often omitted from online tutorials (such as building indices of reference genomes for BWA, GATK, and Picard)

This workflow will **not** work if:

* Some replicates of a given sample are single-end, but others are paired-end. To resolve this, either throw out read two of the paired-end replicates (treating them as single end) or throw out the single-end reads (leaving only paired-end).

* If a single sample needs to be aligned to more than one genome.

# How to replicate my results

Running the scripts in `src/` in their numbered order to will replicate my analysis

0. `src/s00_organizeSRAdata.Rmd` takes data in `workflow/data/SRArunInfo` and structures it into `config/samples.tsv` so that it can be churned through snakemake workflow

1. `s01_removeUnderscores.bash` removes underscores from chromosome names in the fasta files and gff files, which mess with snakemake wildcards

2. `s02_buildChromosomesFile.bash` builds `chromosomes.tsv` which snakemake uses to parallelize genotype calling across scaffolds/chromosomes

3. `s03_snakemake.bash` runs snakemake

4. `s04_correlateKmerAndSNPvariation.Rmd` Analyze the workflow outputs to generate final graphs for publication

# Inputs

This how I eventually want the input data for the workflow to be organized

```
config/
	annotations/ # gffs of genome sequences, naming convention: genus_species.gff3
	assemblies/ # fasta files of genome sequences, naming convention: genus_species.fa
	samples.tsv # tab-separated text file listing read metadata with these columns: run, replicate, layout, genome
	chromosomes.tsv # tab-separated text file listing chromosome names for each genome: genus_species, chromsome_name
	config.yaml # defines key workflow parameters
	
workflow/data/
	SRArunInfo/ # comma-separated files of meta-data for SRA runs, organized into samples.tsv using code in src/ before workflow begins
```

See `workflow/dag.svg` for an example of my snakemake workflow executed on a handful of samples.

## samples.tsv

This file contains the following columns:

| run | replicate | layout | genome | ploidy | taxonKeys |
|-----|-----------|--------|--------|--------|-----------|
| the SRA run number for the fastq dataset| the SRA biosample number, used to identify technical replicates | SE or PE for single-end or paired-end respectively | the prefix for the fasta file used as the reference for the sample (e.g. arabidopsis_thaliana) | the number of genome copies in each cell of the organism sampled (e.g. 2 for diploid) | GBIF keys to use for downloading occurence data |

If you're looking at GBIF occurrence data, then you'll also want to have your GBIF email, username, and password stored as environment variables:

```
export GBIF_USER=<username>
export GBIF_EMAIL=<email>
export GBIF_PWD=<password>
```

The script `workflow/scripts/download_gbif.R` needs this information in order to download GBIF data.

## chromosomes.tsv

This file is used to parallelize the GATK genotype GVCFs step in the workflow (splitting the data by chromosome/scaffold) contains the following columns

| genome | chromosome |
|--------|------------|
| the prefix of a fasta file | the name of the chromosome/scaffold in the associated fasta file |

**You must remove any underscores from chromosome/scaffold names for snakemake wildcards to work (e.g. scaffold_25 -> scaffold25)!** This name change should be reflected in `chromosomes.tsv`, the gff files, and the fasta files.

## workflow parameters

To change the workflow parameters, alter the values in `config/config.yaml`

| Parameter | Description | Default |
|-----------|-------------|---------|
| kmerLength | Length of k-mers to count | 30 |
| countThresh | The minimum number of occurences any particular k-mer needs to avoid being filtered out | 5 |
| kmersKept | The number of k-mers exceeding the count threshold that are randomly sampled for diversity estimation | 10000000 |
| qualityScore | The minimum quality score of a base pair within a read to not get filtered out during read trimming or genotype calling | 20 |
| minReadLength | The minimum length of a read in basepairs to avoid getting filtered out. This should ideally have the same value as kmerLength because reads shorter than the k-mer length won't contribute to k-mer counts | 30 |
| het | The expected level of heterozygosity passed to GATK | 0.001 |
| occCountThreshold | The number of species occurences on a continent required to attempt drawing an alpha hull | 20 |
| alpha | Alpha value for drawing alpha hull around species occurences | 200 |

# Outputs

## pairwise-pi.txt

A file ending in `pairwise-pi.txt` will be generated for each specified genome with the following columns:

| h | w | ntotal | nvariant | ninvariant | pi | thetaw | d |
|---|---|--------|----------|------------|----|--------|---|
|summed heterozygosity across all sites | total Watersons's theta | number of sites with called genotypes | number of variant sites called | number of invariant sites called | nucleotide diversity per site | Watterson's theta per site | Tajima's D |

## bcd.txt

A file ending in `bcd.txt` will be generated for each genome and will contain Bray-Curtis dissimilarity calculations for every pair of individuals mapped to each genome.

## jac.txt

A file ending in `jac.txt` will be generated for each genome containing Jaccard dissimilarity calculations for every pair of individuals mapped to each genome.

# Notes

## Updating the repo

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

## Misc

- [x] Phase out support for not using conda environments

- [x] Remove commented out code

- [x] Give rules that decrease the total number of files and/or memory higher priority

- [x] Write rule to dynamically allocate memory based on input size, thread count, and attempt 

- [x] Remove environment modules

- [x] Make `samtools sort` multithreaded

## Genetic diversity estimation

- [x] Move input data to `config/`

- [x] calculate watterson's theta for each site and genome-wide

- [x] calculate Tajima's D for each site and genome wide

- [x] Use `GenomicsDBImport` instead of `CombineGVCFs`

- [x] Move genome assembly and annotations to `config/`

- [x] Define workflow parameters in a yaml file

- [x] Define tabix-indexed VCF files as inputs and outputs of rules

## Population size estimation

- [x] filter GBIF occurences by country, only include occurences within native ranges as described by [plants of the world online](https://powo.science.kew.org/)

- [x] add alpha and threshold number of occurences as paramters to `download_gbif.R`
