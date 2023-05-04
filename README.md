# Author

Miles Roberts

# Contents

[Summary](#summary)

[How to replicate my results](#How-to-replicate-my-results)

[Notes](#notes)

[To do](#to-do)

# Summary

This workflow takes a list of SRA run numbers, separated before-hand as either paired-end or single-end, along with the assembly and annotation of their corresponding reference genomes. It then trims the reads with fastp and executes two different genotype calling pipelines:

1. Align reads to reference genome, then call SNPs and indels at four-fold degenerate sites

2. Count k-mers within reads, omiting k-mers that appear in the coding sequences of their respective species. Then, choose a random subset of k-mers to keep for further analysis. K-mer counts for each genotype are merged into a large matrix and then used to calculate two measures of dissimilarity:

* Jaccard dissimilarity: k-mers are marked as either present (1) or absent (0) based on their count within the whole genome sequencing reads for each genotype. Then you look at the intersection-union ratio for each pair of k-mer sets

* Bray-Curtis dissimilarity: counts are first normalized to sum to one (within each sample) to help control for coverage variation between samples, then you apply [the formula in this paper](https://doi.org/10.1186/s12859-015-0875-7)

In addition, this workflow is designed to:

* analyze read data from multiple species simultaneously, including species of varying ploidy

* split data by chromosome/scaffold to parallelize SNP calling

* merge technical replicates (usually technical replicates are defined as two SRA runs that share the same Biosample/Experiment ID)

* work with both paired-end and single-end data

* retain invariant sites during SNP calling

* perform steps that are often omitted from online tutorials (such as building indices of reference genomes for BWA, GATK, and Picard)

This workflow will **not** work if:

* Some replicates of a given sample are single-end, but others are paired-end. To resolve this, either throw out read two of the paired-end replicates (treating them as single end) or throw out the single-end reads (leaving only paired-end).

* If a single sample is associated with more than one genome

# How to replicate my results

Running the scripts in `src/` in their numbered order to will replicate my analysis

0. `src/s00_organizeSRAdata.Rmd` takes data in `workflow/data/SRArunInfo` and structures it into `config/samples.tsv` so that it can be churned through snakemake workflow

1. `s01_removeUnderscores.bash` removes underscores from chromosome names in the fasta files and gff files, which mess with snakemake wildcards

2. `s02_buildChromosomesFile.bash` builds `chromosomes.tsv` which snakemake uses to parallelize genotype calling across scaffolds/chromosomes

3. `s03_snakemake.bash` runs snakemake

4. `s04_correlateKmerAndSNPvariation.Rmd` Analyze the workflow outputs to generate final graphs for publication

## Input files for workflow

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

### samples.tsv

This file contains the following columns:

* run: the SRA run number for the fastq dataset

* replicate: the SRA biosample number, used to identify technical replicates

* layout: SE or PE for single-end or paired-end respectively

* genome: the prefix for the fasta file used as the reference for the sample (e.g. arabidopsis_thaliana)

* ploidy: the number of genome copies in each cell of the organism sampled (e.g. 2 for diploid)

* taxonKeys: GBIF keys to use for downloading occurence data

If you're looking at GBIF occurrence data, then you'll also want to have your GBIF email, username, and password stored as environment variables:

```
export GBIF_USER=<username>
export GBIF_EMAIL=<email>
export GBIF_PWD=<password>
```

The script `workflow/scripts/download_gbif.R` needs this information in order to download GBIF data.

### chromosomes.tsv

This file is used to parallelize the GATK genotype GVCFs step in the workflow (splitting the data by chromosome/scaffold) contains the following columns

* genome: the prefix of a fasta file

* chromosome: the name of the chromosome/scaffold in the associated fasta file

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

## search methods for genotype data

My search for plant genotype data was restricted to only species with reference genomes on phytozome. I then would type each species name into the SRA search bar and restrict matches to the Organism field (example: Arabidopsis lyrata[Organism]) and then further filter for samples sourced from DNA. I would then download the Run info from the search and then look at the bioprojects with the highest number of SRA samples.

To get the CSV for Boechera stricta run numbers I searched "Boechera stricta Reference Population" on the SRA.

## listing genomes in NCBI to investigate

I first looked for WGS data based on genomes I found in phytozome, then I moved to ensembl.

Then, on 2023-01-30, I downloaded a list of genomes that met these filters on NCBI genome: eukaryotic, plants, land plants, exclude partial. I then filtered this list to exclude genomes that I already looked at from phytozome and ensembl, genomes that didn't have download links or didn't include chromosome assemblies (i.e. only plastid genomes) or didn't include any coding sequences.

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

## Running workflow in batches

I've tried to run the workflow in batches (`snakemake --batch rule=1/n`) but this function seems most helpful when you have a central aggregation step in your workflow where the input includes all of the upstream files and the output goes on to all of the downstream files. Given the high level of branching in my workflow though, there's not really a good rule to apply batch processing to. I think I'll just abandon the idea for now.

## Adding scripts to estimate dS

I was thinking I could add scripts for estimating the mutation rate in each species as the synonymous substitution rate. I could then combine mutation rate with diversity data to estimate population size. However, given that I'm interested in how diversity correlates with population size, this feels like I'm dipping into circular logic. This is a good idea for a future workflow in an unrelated project though.

## including multiple types of sequencing data

I'm assuming that variation in diversity between species will be greater than variation between methods (i.e. WGS vs GBS vs RAD-seq etc.)

This is similar to an assumption that Buffalo 2022 **Elife** makes

In other words, I think it would be okay to include different types of sequencing into the same analysis. Variation between species will be confounded with variation between methods, but again we can assume that variation between species will be greater than variation between methods.

## choosing wild relatives to measure historical range size for domesticated species

For each domesticated species in our dataset, we looked at a wild relative to estimate range size. The relative species has to be in the same genus as the domesticated species. When there are multiple wild relatives to choose from, we looked at the one with the most recorded occurences on GBIF

Cases where I have both a domesticated species and it's wild relative in my dataset are interesting. I'll pair the wild relative's GBIF data with its nucleotide diversity data, and just choose a different wild relative to estimate range size in the domesticated species.

## Omitted transcripts

For some species, specific transcripts need to be ommitted because exons are on differing strands. I think this arises as an error during annotation. This used to make `degenotate` throw an error. However, I reached out to the authors of degenotate [here](https://github.com/harvardinformatics/degenotate/issues/30) and got them to turn this error into a warning where problematic transcripts are automatically dropped.

## plastid genomes

I don't want to incorporate chloroplast and mitochondria variants in my anlayses because they have interesting modes of inheritance that probably have a big effect on nucleotide diversity. However, chloroplast and mitochondria variants are so hard to call, I probably won't find many of them and thus they probably won't affect my results too much.

These are the species that have mitochondria and chloroplast calls thus far:

* Arabidopsis thaliana 

* Helianthus annuus

# To do

## Misc

- [x] Phase out support for not using conda environments

- [x] Remove commented out code

- [x] Give rules that decrease the total number of files and/or memory higher priority

- [x] Write rule to dynamically allocate memory based on input size, thread count, and attempt 

- [x] Remove environment modules

- [ ] Create a test dataset to store on github so people can verify my analyses without performing the whole workflow

- [ ] add validation schema for sample metadata and config file to Snakefile

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
