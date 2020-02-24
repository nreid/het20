#!/bin/bash 
#SBATCH --job-name=bcftools
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 1
#SBATCH --mem=15G
#SBATCH --qos=general
#SBATCH --partition=general
#SBATCH --mail-user=
#SBATCH --mail-type=ALL
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err


hostname
date

# load software
module load bcftools/1.9
module load htslib/1.9

# input/output directories, supplemental files

INDIR=../../results/alignments

OUTDIR=../../results/variants
mkdir -p $OUTDIR

# bam list
BAMLIST=$OUTDIR/all_bams.list
find $INDIR -name "*bam" | grep -v "disc" | grep -v "split" | sort >$BAMLIST

# ref genome
REFERENCE=../../genome/GCF_000826765.1_Fundulus_heteroclitus-3.0.2_genomic.fasta

bcftools mpileup \
	-f $REFERENCE \
	-b $BAMLIST \
	-q 20 -Q 30 \
	--max-depth 100 \
	-r NW_012224401.1 \
	-a "DP,AD" | \
bcftools call -m -v -Oz -o $OUTDIR/bcftools_test.vcf.gz

tabix -p vcf $OUTDIR/bcftools_test.vcf.gz

