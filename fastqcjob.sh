#!/bin/bash

#SBATCH --time=24:00:00        # Request xx hours of runtime
#SBATCH --account=st-gkoelwyn-1   # Specify your allocation code
#SBATCH --nodes=1              # Request 1 node
#SBATCH --ntasks=12             # Request x tasks (~x cpus assuming cpus-per-task=1)
#SBATCH --mem=170G               # Request x GB of memory
#SBATCH --job-name=fastqc_scrnaseq    # Specify the job name
#SBATCH --output=fastqc_scrnaseq_output.txt    # Specify the output file
#SBATCH --error=fastqc_scrnaseq_error.txt      # Specify the error file
#SBATCH --mail-user=milad.vahedi@hli.ubc.ca  # Email address for job notifications
#SBATCH --mail-type=ALL        # Receive email notifications for all job events


#############################################################################

SLURM_SUBMIT_DIR=/scratch/st-gkoelwyn-1/milad/fastqc
DATA=/arc/project/st-gkoelwyn-1/jtuong/data/liu_et_al_2023/sc_rna_seq/OC_blood
SIF=/arc/project/st-gkoelwyn-1/milad/docker/scrnaseq.sif

cd $SLURM_SUBMIT_DIR
echo $SLURM_SUBMIT_DIR

module load apptainer
apptainer run -B $DATA $SIF sh fastqc.sh $DATA

DATA=/arc/project/st-gkoelwyn-1/jtuong/data/liu_et_al_2023/sc_rna_seq/YC_blood

apptainer run -B $DATA $SIF sh fastqc.sh $DATA

DATA=/arc/project/st-gkoelwyn-1/jtuong/data/liu_et_al_2023/sc_rna_seq/OE_blood

apptainer run -B $DATA $SIF sh fastqc.sh $DATA

DATA=/arc/project/st-gkoelwyn-1/jtuong/data/liu_et_al_2023/sc_rna_seq/OC_blood

apptainer run -B $DATA $SIF sh fastqc.sh $DATA

