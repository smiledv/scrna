FROM ubuntu:mantic-20240405

#add the version of software
ARG FASTQC_VER="0.11.8"

# install dependencies; cleanup apt garbage
RUN apt-get update && apt-get install -y\
 unzip \
 wget \
 make \
 perl \
 default-jre && \
 apt-get autoclean && rm -rf /var/lib/apt/lists/*

# install fastqc
RUN wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v${FASTQC_VER}.zip && \
    unzip fastqc_v${FASTQC_VER}.zip && \
    rm fastqc_v${FASTQC_VER}.zip && \
    chmod +x FastQC/fastqc && \
    mkdir /data
ENV PATH="${PATH}:/FastQC/"

#install cellranger
RUN wget -O cellranger-8.0.0.tar.gz "https://cf.10xgenomics.com/releases/cell-exp/cellranger-8.0.0.tar.gz?Expires=1713875243&Key-Pair-Id=APKAI7S6A5RYOXBWRPDA&Signature=AqqHvTjMfwit7fv6CdD-S-Mgx-hrWufkaovgH30zt-AnU22SMijNl7~3KeVL-D60K5LhE~Jd8g0lJpgVsobLTSZVfl04hmmOhYc-YZlqXTRXfETM-PbKcBlM-r68mRdM0zScDPs6Sq9mwkrS~RUMh-AyxsHtys6k95NjN1Idi7lYR7atw452zOMkVFuts5VRApgVN01PslieSfU5YOUmODky8rNKrj~jqq3DzpLw0UL8Y36SHwUsHfJjr-DihVwKE3drwW9QHnPq1KiA~94rPYiLxMVal7040b~~aI1bwqCa12FwYo3eofRVqQEl22RshIjskWS-f-hXv5JaxcY3Rw__" && \
    tar -zxvf cellranger-8.0.0.tar.gz && \
    rm cellranger-8.0.0.tar.gz && \
    cd cellranger-8.0.0
ENV PATH="${PATH}:/cellranger-8.0.0/"

# set working directory
WORKDIR /home
