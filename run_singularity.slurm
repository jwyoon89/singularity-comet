#!/bin/bash
#SBATCH --job-name="singularity"
#SBATCH --output="singularity_2018%j.%N.out"
#SBATCH --partition=compute
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=24
#SBATCH --export=ALL
#SBATCH -t 00:05:00

module load singularity mvapich2_ib/2.1

# Image imported from Docker, has Python, R, Julia
# IMAGE=/oasis/scratch/comet/zonca/temp_project/jupyter-datascience-comet.simg
# Image built in Singularity, has Python only
IMAGE=/oasis/scratch/comet/zonca/temp_project/ubuntu_anaconda_2018.simg

# Both images support MPI

#Generate a hostfile from the slurm node list
export PBS_NODEFILE=`generate_pbs_nodefile`

export SINGULARITY=$(which singularity)

echo $SINGULARITY

# Plain `mpirun` was causing errors related to PMI, needed to use a hostfile
mpirun_rsh -hostfile "$PBS_NODEFILE" -np 48 $SINGULARITY exec $IMAGE /usr/bin/hellow
