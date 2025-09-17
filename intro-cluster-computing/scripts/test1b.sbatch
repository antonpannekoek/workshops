#!/bin/bash

#SBATCH --job-name test1

# Use the short partition.
#SBATCH --partition short

# Explicitly request only one node
#SBATCH --nodes 1
# We only want to run one tasks, i.e., program
#SBATCH --tasks 1

# Separate stderr and stdout. %j is the job ID
#SBATCH -o slurm-%j.out
#SBATCH -e slurm-%j.err

# Limit the amount of memory
#SBATCH --mem 20MB

# Maximum allowed time (in case your program may get stuck)
#SBATCH --time 00:00:30

srun bash test1.sh
