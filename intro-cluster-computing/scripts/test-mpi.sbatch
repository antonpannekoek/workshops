#!/bin/bash


#SBATCH --job-name mc-pi
#SBATCH --partition short
#SBATCH --nodes 1

# Our program uses two MPI "tasks" (cf ranks)
#SBATCH --ntasks=2

# Number of "CPUs" (cores/threads) per task
#SBATCH --cpus-per-task 1

# Separate stderr and stdout. %j is the job ID
#SBATCH -o mc-pi-%j.out
#SBATCH -e mc-pi-%j.err

# Limit the amount of memory
#SBATCH --mem=1500MB

# Maximum allowed time (in case your program may get stuck)
#SBATCH --time=00:05:00



function cleanup {
	deactivate
	module purge
	exit
}

# Run cleanup on exit
# Needs to be set *before* starting our actual job
trap 'cleanup' EXIT

# Set up our environment
module load gnu12
module load openmpi4

source $HOME/venv/bin/activate


#mpirun -np $SLURM_NTASKS python test-mpi.py
srun --mpi=pmix_v4 python test-mpi.py
