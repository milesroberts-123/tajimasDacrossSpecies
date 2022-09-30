#!/bin/bash --login
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=7-00:00:00
#SBATCH --mem-per-cpu=1G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=robe1195@msu.edu
#SBATCH --partition=josephsnodes
#SBATCH --account=josephsnodes
# output information about how this job is running using bash commands
echo "This job is running on $HOSTNAME on `date`"

# load snakemake
ml -* iccifort/2020.1.217 impi/2019.7.217 snakemake/5.26.1-Python-3.8.2

# go to workflow directory with Snakefile
cd ../workflow

# submit snakemake to HPCC
# subtract one job and one core from max to account for this submission command
# rerun-incomplete in case previous snakemake instances failed and left incomplete files
snakemake --cluster "sbatch --time 4-00:00:00 --partition=josephsnodes --account=josephsnodes" --jobs 999 --cores 511 --use-envmodules --rerun-incomplete
