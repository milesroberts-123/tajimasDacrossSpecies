FROM condaforge/mambaforge:latest
LABEL io.github.snakemake.containerized="true"
LABEL io.github.snakemake.conda_env_hash="fccb0a6f646873d97b7fa14fc96aff855a35686cb0fdef368a9cc54242f841fd"

# Step 1: Retrieve conda environments

# Conda environment:
#   source: envs/R.yml
#   prefix: /conda-envs/a5149814b913910bb219abf08307ce3a
#   name: myR
#   
#   channels:
#    - conda-forge
#   
#   dependencies:
#    - r-base=4.1.0
#    - r-data.table=1.14.4
RUN mkdir -p /conda-envs/a5149814b913910bb219abf08307ce3a
COPY envs/R.yml /conda-envs/a5149814b913910bb219abf08307ce3a/environment.yaml

# Conda environment:
#   source: envs/bcftools.yml
#   prefix: /conda-envs/2d09e051ad5717416d6a6f93a0a68561
#   name: bcftools
#   
#   channels:
#    - bioconda
#   
#   dependencies:
#    - bcftools=1.11
RUN mkdir -p /conda-envs/2d09e051ad5717416d6a6f93a0a68561
COPY envs/bcftools.yml /conda-envs/2d09e051ad5717416d6a6f93a0a68561/environment.yaml

# Conda environment:
#   source: envs/bedtools.yml
#   prefix: /conda-envs/e30d60da92356f04d46dbb3ef686bf4e
#   name: bedtools
#   
#   channels:
#    - bioconda
#   
#   dependencies:
#    - bedtools=2.30.0
RUN mkdir -p /conda-envs/e30d60da92356f04d46dbb3ef686bf4e
COPY envs/bedtools.yml /conda-envs/e30d60da92356f04d46dbb3ef686bf4e/environment.yaml

# Conda environment:
#   source: envs/bwa_mem.yml
#   prefix: /conda-envs/5a3b33cc5cb0fbfef0d69acd0201f199
#   name: bwa_mem
#   
#   channels:
#    - bioconda
#   
#   dependencies:
#    - bwa=0.7.17
#    - samtools=1.11
RUN mkdir -p /conda-envs/5a3b33cc5cb0fbfef0d69acd0201f199
COPY envs/bwa_mem.yml /conda-envs/5a3b33cc5cb0fbfef0d69acd0201f199/environment.yaml

# Conda environment:
#   source: envs/download.yml
#   prefix: /conda-envs/7d853e9598db34e49e491c007ed4e7c1
#   name: download
#   
#   dependencies:
#     - sra-tools=2.10.7
RUN mkdir -p /conda-envs/7d853e9598db34e49e491c007ed4e7c1
COPY envs/download.yml /conda-envs/7d853e9598db34e49e491c007ed4e7c1/environment.yaml

# Conda environment:
#   source: envs/fastp.yml
#   prefix: /conda-envs/3812a266c7f55f824c5b15760815eef9
#   name: fastp
#   
#   dependencies:
#     - fastp=0.23.1
RUN mkdir -p /conda-envs/3812a266c7f55f824c5b15760815eef9
COPY envs/fastp.yml /conda-envs/3812a266c7f55f824c5b15760815eef9/environment.yaml

# Conda environment:
#   source: envs/gatk.yml
#   prefix: /conda-envs/c8a1a2f5c37ca99d9b66566f6908ce5a
#   name: gatk
#   
#   channels:
#    - bioconda
#   
#   dependencies:
#    - gatk4=4.1.4.1
RUN mkdir -p /conda-envs/c8a1a2f5c37ca99d9b66566f6908ce5a
COPY envs/gatk.yml /conda-envs/c8a1a2f5c37ca99d9b66566f6908ce5a/environment.yaml

# Conda environment:
#   source: envs/kmc.yml
#   prefix: /conda-envs/214bf496021f24af731c354984d93fe5
#   name: kmc
#   
#   channels:
#    - bioconda
#   
#   dependencies:
#    - kmc=3.2.1
RUN mkdir -p /conda-envs/214bf496021f24af731c354984d93fe5
COPY envs/kmc.yml /conda-envs/214bf496021f24af731c354984d93fe5/environment.yaml

# Conda environment:
#   source: envs/multiqc.yml
#   prefix: /conda-envs/c66123f273d11315398335f3b4f71d07
#   name: multiqc
#   
#   channels:
#    - bioconda
#   
#   dependencies:
#    - multiqc=1.6
RUN mkdir -p /conda-envs/c66123f273d11315398335f3b4f71d07
COPY envs/multiqc.yml /conda-envs/c66123f273d11315398335f3b4f71d07/environment.yaml

# Conda environment:
#   source: envs/picard.yml
#   prefix: /conda-envs/107701487a60823e74ff554a7e31dc8d
#   name: picard
#   
#   channels:
#    - bioconda
#   
#   dependencies:
#    - picard-slim=2.22.1
RUN mkdir -p /conda-envs/107701487a60823e74ff554a7e31dc8d
COPY envs/picard.yml /conda-envs/107701487a60823e74ff554a7e31dc8d/environment.yaml

# Conda environment:
#   source: envs/python.yml
#   prefix: /conda-envs/1782faa8d4389cc8a49b680700f2377e
#   name: myPython
#   
#   channels:
#    - conda-forge
#   
#   dependencies:
#    - python=3.8.5
RUN mkdir -p /conda-envs/1782faa8d4389cc8a49b680700f2377e
COPY envs/python.yml /conda-envs/1782faa8d4389cc8a49b680700f2377e/environment.yaml

# Conda environment:
#   source: envs/samtools.yml
#   prefix: /conda-envs/935725baedb41d73d5ce355b88e3940f
#   name: samtools
#   
#   channels:
#    - bioconda
#   
#   dependencies:
#    - samtools=1.11
RUN mkdir -p /conda-envs/935725baedb41d73d5ce355b88e3940f
COPY envs/samtools.yml /conda-envs/935725baedb41d73d5ce355b88e3940f/environment.yaml

# Conda environment:
#   source: envs/vcftools.yml
#   prefix: /conda-envs/8e096254d5519b7d85cdc94c5f2988c6
#   name: vcftools
#   
#   channels:
#    - bioconda
#   
#   dependencies:
#    - perl-vcftools-vcf=0.1.15
RUN mkdir -p /conda-envs/8e096254d5519b7d85cdc94c5f2988c6
COPY envs/vcftools.yml /conda-envs/8e096254d5519b7d85cdc94c5f2988c6/environment.yaml

# Step 2: Generate conda environments

RUN mamba env create --prefix /conda-envs/a5149814b913910bb219abf08307ce3a --file /conda-envs/a5149814b913910bb219abf08307ce3a/environment.yaml && \
    mamba env create --prefix /conda-envs/2d09e051ad5717416d6a6f93a0a68561 --file /conda-envs/2d09e051ad5717416d6a6f93a0a68561/environment.yaml && \
    mamba env create --prefix /conda-envs/e30d60da92356f04d46dbb3ef686bf4e --file /conda-envs/e30d60da92356f04d46dbb3ef686bf4e/environment.yaml && \
    mamba env create --prefix /conda-envs/5a3b33cc5cb0fbfef0d69acd0201f199 --file /conda-envs/5a3b33cc5cb0fbfef0d69acd0201f199/environment.yaml && \
    mamba env create --prefix /conda-envs/7d853e9598db34e49e491c007ed4e7c1 --file /conda-envs/7d853e9598db34e49e491c007ed4e7c1/environment.yaml && \
    mamba env create --prefix /conda-envs/3812a266c7f55f824c5b15760815eef9 --file /conda-envs/3812a266c7f55f824c5b15760815eef9/environment.yaml && \
    mamba env create --prefix /conda-envs/c8a1a2f5c37ca99d9b66566f6908ce5a --file /conda-envs/c8a1a2f5c37ca99d9b66566f6908ce5a/environment.yaml && \
    mamba env create --prefix /conda-envs/214bf496021f24af731c354984d93fe5 --file /conda-envs/214bf496021f24af731c354984d93fe5/environment.yaml && \
    mamba env create --prefix /conda-envs/c66123f273d11315398335f3b4f71d07 --file /conda-envs/c66123f273d11315398335f3b4f71d07/environment.yaml && \
    mamba env create --prefix /conda-envs/107701487a60823e74ff554a7e31dc8d --file /conda-envs/107701487a60823e74ff554a7e31dc8d/environment.yaml && \
    mamba env create --prefix /conda-envs/1782faa8d4389cc8a49b680700f2377e --file /conda-envs/1782faa8d4389cc8a49b680700f2377e/environment.yaml && \
    mamba env create --prefix /conda-envs/935725baedb41d73d5ce355b88e3940f --file /conda-envs/935725baedb41d73d5ce355b88e3940f/environment.yaml && \
    mamba env create --prefix /conda-envs/8e096254d5519b7d85cdc94c5f2988c6 --file /conda-envs/8e096254d5519b7d85cdc94c5f2988c6/environment.yaml && \
    mamba clean --all -y
