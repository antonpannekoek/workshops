#!/bin/bash


#SBATCH --job-name mc-pi
#SBATCH --partition short
#SBATCH --nodes 1

# There is still only one task (program) running
#SBATCH --ntasks=1

# Number of "CPUs" (cores/threads) per task
# This is the paralell (multiprocessing/OpenMP number of processes)
#SBATCH --cpus-per-task 8

# Separate stderr and stdout. %j is the job ID
#SBATCH -o mc-pi-%j.out
#SBATCH -e mc-pi-%j.err

# Limit the amount of memory
#SBATCH --mem=500MB

# Maximum allowed time (in case your program may get stuck)
#SBATCH --time=00:05:00



function cleanup {
	exit
}

# Run cleanup on exit
# Needs to be set *before* starting our actual job
trap 'cleanup' EXIT


# The following would be essential for OpenMP parallel programs!
#export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

# Special SLURM variable
srun python3.11 mc-pi.py $SLURM_CPUS_PER_TASK --ntrials=1_000_000
