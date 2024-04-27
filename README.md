## 1. Raw data processing
### 1.1. Make a dockerfile to run FASTQC
#### build the image using docker on your pc
```
DOCKERHUB_USERNAME=miladvahedi
IMAGE_VERSION=amd64
IMAGE_NAME=scrnaseq
PLAT=linux/amd64

docker build --platform=linux/amd64 -t miladvahedi/scrnaseq:amd64 .
```
#### run interactive docker image to test your image
```
docker run -it miladvahedi/scrnaseq:amd64
```
#### push docker image to docker hub
```
docker push miladvahedi/scrnaseq:amd64
```
#### go to Sockeye, push the docker image, and convert that to sif file
```
module load apptainer; \
apptainer pull scrna.sif docker://miladvahedi/scrnaseq:amd64
```

### 1.2. Run FASTQC job on sockeye with fastqc.sh file
```
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
```

### 1.3. The fastqc.sh file you need for your job
```
FASTQ_FILES=$(find $1 -name *.fastq)
echo $FASTQ_FILES
OUTPUT=fastqc_results
mkdir -p $OUTPUT
for file in $FASTQ_FILES
do
    echo $file
    fastqc -t 5 $file -o $OUTPUT
done
```
</br>
<b>
    
## 2: Mapping reads against reference

### 2.1. Download the reference from Cell Ranger website an unzip
```
wget "https://cf.10xgenomics.com/supp/cell-exp/refdata-gex-GRCm39-2024-A.tar.gz"
tar -xvzf cell-exp/refdata-gex-GRCm39-2024-A.tar.gz
```
### 2.2. Rename your samples based on Cell Ranger fastq input format
```
mv CRR516134_f1.fastq CRR516134_S1_L001_R1_001.fastq
mv CRR516134_r2.fastq CRR516134_S1_L001_R2_001.fastq
```
### 2.3. Run cellranger job using the aligment.sh file for each fastq pair files
```
#!/bin/bash

#SBATCH --time=24:00:00        # Request xx hours of runtime
#SBATCH --account=st-gkoelwyn-1   # Specify your allocation code
#SBATCH --nodes=1              # Request 1 node
#SBATCH --ntasks=25             # Request x tasks (~x cpus assuming cpus-per-task=1)
#SBATCH --mem=170G               # Request x GB of memory
#SBATCH --job-name=alignment_CRR516134    # Specify the job name
#SBATCH --output=CRR516134_output.txt    # Specify the output file
#SBATCH --error=CRR516134_error.txt      # Specify the error file
#SBATCH --mail-user=milad.vahedi@hli.ubc.ca  # Email address for job notifications
#SBATCH --mail-type=ALL        # Receive email notifications for all job events


#############################################################################

SLURM_SUBMIT_DIR=/scratch/st-gkoelwyn-1/milad/alignment
DATA=/scratch/st-gkoelwyn-1/milad/alignment/sc_rna_seq/OC_blood
SIF=/scratch/st-gkoelwyn-1/milad/alignment/docker/scrna.sif

module load apptainer
apptainer run -B $DATA $SIF sh alignment.sh $DATA
```

### 2.3. The alignment.sh file you need for your job
```
cellranger count \
--create-bam=true \
--sample=CRR516134 \
--id=CRR516134 \
--transcriptome=/scratch/st-gkoelwyn-1/milad/alignment/ref_seq/refdata-gex-GRCm39-2024-A \
--fastqs=/scratch/st-gkoelwyn-1/milad/alignment/sc_rna_seq/OC_blood \
--localcores=25 \
--localmem=170 \
--mempercore=150
```




