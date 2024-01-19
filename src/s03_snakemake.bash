#!/bin/bash --login
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=7-00:00:00
#SBATCH --mem-per-cpu=16G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=robe1195@msu.edu
#SBATCH --partition=josephsnodes
#SBATCH --account=josephsnodes
# output information about how this job is running using bash commands
echo "This job is running on $HOSTNAME on `date`"

# load snakemake
echo Loading snakemake...
conda activate snakemake

# change directory of cache to scratch
echo Changing cache directory...
export XDG_CACHE_HOME="/mnt/scratch/robe1195/cache"
echo $XDG_CACHE_HOME

# go to workflow directory with Snakefile
echo Changing directory...
cd ../workflow

# unlock snakemake if previous instance of snakemake failed
echo Unlocking snakemake...
snakemake --unlock --cores 1

# submit snakemake to HPCC
# subtract one job and one core from max to account for this submission command
# rerun-incomplete in case previous snakemake instances failed and left incomplete files
# Max cpu count for my SLURM account is 1040, subtract 1 to account for scheduler
# Max job submit count is 1000, subtract 1 to account for scheduler
echo Running snakemake...
snakemake --cluster "sbatch --time={resources.time} --partition=josephsnodes --account=josephsnodes --cpus-per-task={threads} --mem-per-cpu={resources.mem_mb_per_cpu}" --jobs 3 --cores 3 --use-conda --rerun-incomplete --rerun-triggers mtime --retries 2 --keep-going --resources load=3 --scheduler greedy --cluster-cancel "scancel" --default-resources time=10080
#snakemake --cluster "sbatch --time 7-00:00:00 --partition=josephsnodes --account=josephsnodes --cpus-per-task={threads} --mem-per-cpu={resources.mem_mb_per_cpu}" --jobs 10 --cores 10 --use-conda --rerun-incomplete --rerun-triggers mtime --resources load=3 --scheduler greedy
