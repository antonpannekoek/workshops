#!/bin/bash

#SBATCH --job-name=test2b

# Use the short partition.
#SBATCH --partition=short

# Explicitly request only one node
#SBATCH --nodes 1
# We only want to run one tasks, i.e., program
#SBATCH --tasks 1

# Separate stderr and stdout. %j is the job ID
#SBATCH -o slurm-%j.out
#SBATCH -e slurm-%j.err

# Limit the amount of memory
#SBATCH --mem=20MB

# Maximum allowed time (in case your program may get stuck)
#SBATCH --time=00:00:30


# Make a temporary output directory on /hddstore
outdir=/hddstore/${USER}

mkdir -p $outdir

srun bash test2.sh

# Ensure a local output directory to copy to
mkdir -p $HOME/output

# Copy files
srun cp ${outdir}/* ${HOME}/output/

# Clean up the output directory
rm -r ${outdir}
