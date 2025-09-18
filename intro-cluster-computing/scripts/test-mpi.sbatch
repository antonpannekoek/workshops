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


# mpirun inside an sbatch script
# gets its information, number of processes,
# from the --ntasks directive
# So we don't need to provide a `-n` (or `-np`) option to mpirun
mpirun python test-mpi.py

# If you wanted to use `srun` instead, you can use
# The OpenMPI documentation recommends using mpirun (within an sbatch script)
#srun --mpi=pmix_v4 python test-mpi.py
