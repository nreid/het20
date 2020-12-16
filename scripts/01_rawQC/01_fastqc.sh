#!/bin/bash
#SBATCH --job-name=fastqc
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=noah.reid@uconn.edu
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=2G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --array=[0-885]%20

hostname
date

echo "host name : " `hostname`
echo This is array task number $SLURM_ARRAY_TASK_ID

# load software
module load fastqc/0.11.7

#input/output directories, supplementary files

INDIR=../../data
OUTDIR=../../results/fastqc
mkdir -p $OUTDIR

FASTQS=($(find -L ${INDIR} -name "*1.fastq.gz"))

FQ1=${FASTQS[$SLURM_ARRAY_TASK_ID]}
FQ2=$(echo $FQ1 | sed 's/1.fastq.gz/2.fastq.gz/')
# run fastqc. "*fq" tells it to run on all fastq files in directory "../rawdata/"
fastqc -t 2 -o $OUTDIR $FQ1
fastqc -t 2 -o $OUTDIR $FQ2

date