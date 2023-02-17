# Contents

[Summary](#summary)

[How to replicate my results](#How-to-replicate-my-results)

[Input files for workflow](#input-files-for-workflow)

[Updating the repo](#updating-the-repo)

[Notes](#notes)

[To do](#to-do)

# Summary

This workflow takes a list of SRA run numbers, separated before-hand as either paired-end or single-end, along with the assembly and annotation of their corresponding reference genomes. It then trims the reads with fastp and executes two different genotype calling pipelines:

1. Align reads to reference genome, then call SNPs and indels at four-fold degenerate sites

2. Count k-mers within reads, omiting k-mers that appear in the coding sequences of *Arabidopsis thaliana*. Then, choose a random subset of k-mers to keep for further analysis. K-mer counts for each genotype are merged into a large matrix and then used to calculate two measures of dissimilarity:

* Jaccard dissimilarity: k-mers are marked as either present (1) or absent (0) based on their count within the whole genome sequencing reads for each genotype. Then you look at the intersection-union ratio for each pair of k-mer sets

* Bray-Curtis dissimilarity: counts are first normalized to sum to one (within each sample) to help control for coverage variation between samples, then you apply [the formula in this paper](https://doi.org/10.1186/s12859-015-0875-7)

In addition, this workflow is designed to:

* analyze read data from multiple species simultaneously, including species of varying ploidy

* split data by chromosome to parallelize computations

* merge technical replicates

* work with both paired-end and single-end data

* work either as a set of environment modules (specific to the MSU ICER HPCC), a set of conda environments, or as a Docker container

* retain invariant sites during SNP calling

* perform steps that are often omitted from online tutorials (such as building indices of reference genomes for BWA, GATK, and Picard)

* output metrics for called variants before filtering (useful for determining if filters were appropriate)

* output simple statistics on the number of reads and bp applied to workflow

This workflow will **not** work if:

* Some replicates of a given sample are single-end, but others are paired-end. To resolve this, either throw out read two of the paired-end replicates (treating them as single end) or throw out the single-end reads (leaving only paired-end).

* If a single sample is associated with more than one genome

# How to replicate my results

Running the scripts in `src/` in their numbered order to will replicate my analysis

## replicate full snakemake workflow

Clone this repository and submit a SLURM job script to run the entire workflow. **Caution: this will submit about 400,000 jobs**

```
git clone https://github.com/milesroberts-123/tajimasDacrossSpecies.git
cd tajimasDacrossSpecies/src
sbatch s02_full_snakemake.sh
```

## replicate test snakemake workflow

Replicating the entire snakemake workflow will be impossible if you do not have access to a high performance computing cluster. Instead, you can verify the workflow using a much smaller test dataset. To do this, run:

```
git clone https://github.com/milesroberts-123/tajimasDacrossSpecies.git
cd tajimasDacrossSpecies/src
sbatch s03_test_snakemake.sh
``` 

## replicate preparation of metadata for workflow

0. `src/s00_organizeSRAdata.Rmd` takes data in workflow/data/SRArunInfo and structures it into `data/samples.tsv` so that it can be churned through snakemake workflow. This table can be found in `workflow/data/samples.tsv` already.

1. `src/s01_downloadGenomes.bash` contains `wget` commands to download genomes from NCBI and Ensembl

2. `src/s02_removeUnderscores.bash` takes renamed downloads from Phytozome, Ensembl, and NCBI and removes underscores from chromosome/scaffold names so that they can be accessed with snakemake wildcards

3. `src/s03_buildChromosomesFiles.bash` takes the annotations (with underscores removed from chromosome/scaffold names) and creates `chromosomes.tsv`, which is used later by snakemake to split genotyping by chromosome 

4. `src/s04_snakemake.bash` takes all of the input files and runs them through the snakemake workflow

## run workflow with the MSU ICER HPCC modules instead of conda environments

Find an example script in `src/s05_snakemake_modules.bash`

**I highly recommend that you use conda environments instead!** This method for running the workflow is specific only to the ICER HPCC and will probably break if the modules on the HPCC are updated. I mainly keep this note in the readme for my own reference.

Nonetheless, if you want to do this you will need to add the following to `/workflow/scripts/`

* [degenotate](https://github.com/harvardinformatics/degenotate)

* [fastp](https://github.com/OpenGene/fastp)

* [seqkit](https://github.com/shenwei356/seqkit)

To get degenotate, clone degenotate github repo into `workflow/scripts`:

```
cd workflow/scripts
git clone https://github.com/harvardinformatics/degenotate.git
```

You can then update degenotate by doing into the degenotate folder and using:

```
git fetch
git pull
```

Go to the fastp github repo and download the latest linux binary, add this to the scripts folder and make it executable with `chmod +x fastp`. Do the same for seqkit too!

# Input files for workflow

This how I eventually want the input data for the workflow to be organized

```
workflow/data/
	annotations/ # gffs of genome sequences, naming convention: genus_species.gff3
	assemblies/ # fasta files of genome sequences, naming convention: genus_species.fa
	SRArunInfo/ # comma-separated files of meta-data for SRA runs, organized into samples.tsv using code in src/ before workflow begins
	samples.tsv # tab-separated text file listing read metadata with these columns: run, replicate, layout, genome
	species.tsv # list of species to download GBIF occurence records for. Columns are: genus_spcies, and gbif taxon keys
	chromosomes.tsv # tab-separated text file listing chromosome names for each genome: genus_species, chromsome_name
```

See `workflow/dag.svg` for an example of my snakemake workflow executed on a handful of samples.

## samples.tsv

This file contains the following columns:

* run: the SRA run number for the fastq dataset

* replicate: the SRA biosample number, used to identify technical replicates

* layout: SE or PE for single-end or paired-end respectively

* genome: the prefix for the fasta file used as the reference for the sample (e.g. arabidopsis_thaliana)

* ploidy: the number of genome copies in each cell of the organism sampled (e.g. 2 for diploid)

## species.tsv

A file with a single column:

* species: the genus and species of the organism you're interested in written as `genus_species`. First letter of genus should be capitalized. See `workflow/data` for an example.

If you're looking at GBIF occurrence data, then you'll also want to have your GBIF email, username, and password stored as environment variables:

```
export GBIF_USER=<username>
export GBIF_EMAIL=<email>
export GBIF_PWD=<password>
```

The script `workflow/scripts/download_gbif.R` needs this information in order to download GBIF data.

## chromosomes.tsv

This file is used to parallelize the GATK genotype GVCFs step in the workflow (splitting the data by chromosome/scaffold) contains the following columns

* genome: the prefix of a fasta file

* chromosome: the name of the chromosome/scaffold in the associated fasta file

**You must remove any underscores from chromosome/scaffold names for snakemake wildcards to work (e.g. scaffold_25 -> scaffold25)!** This name change should be reflected in `chromosomes.tsv`, the gff files, and the fasta files.

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
 
# Notes

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

# To do

* extract 4-fold degenerate sites using `degenotate` instead of `bedtools`?

* add error checking to main snakefile
