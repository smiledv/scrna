#!/bin/bash

#SBATCH --time=24:00:00        # Request xx hours of runtime
#SBATCH --account=st-gkoelwyn-1   # Specify your allocation code
#SBATCH --nodes=1              # Request 1 node
#SBATCH --ntasks=25             # Request x tasks (~x cpus assuming cpus-per-task=1)
#SBATCH --mem=170G               # Request x GB of memory
#SBATCH --job-name=alignment_CRR516135    # Specify the job name
#SBATCH --output=CRR516135_output.txt    # Specify the output file
#SBATCH --error=CRR516135_error.txt      # Specify the error file
#SBATCH --mail-user=milad.vahedi@hli.ubc.ca  # Email address for job notifications
#SBATCH --mail-type=ALL        # Receive email notifications for all job events


#############################################################################

SLURM_SUBMIT_DIR=/scratch/st-gkoelwyn-1/milad/alignment
DATA=/scratch/st-gkoelwyn-1/milad/alignment/sc_rna_seq/OE_blood
SIF=/scratch/st-gkoelwyn-1/milad/alignment/docker/scrna.sif

module load apptainer
apptainer run -B $DATA $SIF sh alignment.sh $DATA

