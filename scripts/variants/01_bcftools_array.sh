#!/bin/bash 
#SBATCH --job-name=bcftools
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=noah.reid@uconn.edu
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=15G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --array=[1-1000]%30

hostname
date

# command line option $1 is added to SLURM_ARRAY_TASK_ID
# this is because only 1000 tasks are allowed, and higher numbers are disallowed. 

# load software
module load bcftools/1.9
module load htslib/1.9

# input/output directories, supplemental files

INDIR=../../results/alignments

OUTDIR=../../results/variants/scaffold
mkdir -p $OUTDIR

# bam list
BAMLIST=$OUTDIR/all_bams.list
find $INDIR -name "*bam" | grep -v "disc" | grep -v "split" | sort >$BAMLIST

# ref genome
REFERENCE=../../genome/GCF_000826765.1_Fundulus_heteroclitus-3.0.2_genomic.fasta

# which scaffold to run on:
ARINC=$1
SN=$(($SLURM_ARRAY_TASK_ID + $ARINC))
SCAF=$(sed -n ${SN}p ${REFERENCE}.fai | cut -f 1)

bcftools mpileup \
	-f $REFERENCE \
	-b $BAMLIST \
	-q 20 -Q 30 \
	--max-depth 100 \
	-r $SCAF \
	-a "DP,AD" | \
bcftools call -m -v -Oz -o $OUTDIR/${SCAF}.vcf.gz


