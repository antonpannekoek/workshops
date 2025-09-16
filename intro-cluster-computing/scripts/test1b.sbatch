#!/bin/bash

#SBATCH --job-name test1

# Use the short partition.
#SBATCH --partition short

# Explicitly request only one node
#SBATCH -N 1
# If you set the above, use --tasks-per-node to be explicit
# about the number of cores/threads you want
#SBATCH --tasks-per-node 1

# Separate stderr and stdout. %j is the job ID
#SBATCH -o slurm-%j.out
#SBATCH -e slurm-%j.err

# Limit the amount of memory
#SBATCH --mem 20MB

# Maximum allowed time (in case your program may get stuck)
#SBATCH --time 00:00:30

srun bash test1.sh
