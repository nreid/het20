#!/bin/bash
#SBATCH --job-name=bwa
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=noah.reid@uconn.edu
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --array=[0-885]%30

echo "host name : " `hostname`
echo This is array task number $SLURM_ARRAY_TASK_ID
date

# load software----------------------------------------------
module load samtools/1.10
module load bwa/0.7.17
module load samblaster/0.1.24

# set input/output files, directories------------------------

# input fastq file directory
INDIR=../../data

# output directory
OUTDIR=../../results/alignments
mkdir -p $OUTDIR

# reference genome
GENOME=../../genome/mummichog

# fastq file bash array
FQS=($(find -L ${INDIR} -name "*1.fastq.gz"))

# fastq files
FQ1=${FQS[$SLURM_ARRAY_TASK_ID]}

# get corresponding sample ID
SRA2SAMPLE=../../metadata/sra2sampleID.txt
SRA=$(basename $FQ1 | sed 's/_R*[12].fastq.gz//')
SAM=$(grep $SRA $SRA2SAMPLE | cut -f 2)
echo $SAM

# execute alignment script, supplying fastq R1, output directory, and reference genome
bash align_generic.sh $FQ1 $OUTDIR $GENOME $SAM