#!/bin/bash --login
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=7-00:00:00
#SBATCH --mem-per-cpu=1G
<<<<<<< HEAD:src/s00_snakemake.bash
=======
#SBATCH --mail-type=ALL
#SBATCH --mail-user=$USER@msu.edu
>>>>>>> a4cef41d38814c213708ce8aa7f0f42975ace7ea:workflow/s00_snakemake.bash
# output information about how this job is running using bash commands
echo "This job is running on $HOSTNAME on `date`"

# load snakemake
ml -* iccifort/2020.1.217 impi/2019.7.217 snakemake/5.26.1-Python-3.8.2

# submit snakemake to HPCC
# subtract one job and one core from max to account for this submission command
<<<<<<< HEAD:src/s00_snakemake.bash
snakemake --cluster "sbatch --time 04:00:00" --jobs 999 --cores 511 --use-envmodules
=======
snakemake --cluster "sbatch --time 4-00:00:00" --jobs 999 --cores 511 --use-envmodules
>>>>>>> a4cef41d38814c213708ce8aa7f0f42975ace7ea:workflow/s00_snakemake.bash
