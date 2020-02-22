#!/bin/bash 
#SBATCH --job-name=test_variants
#SBATCH --mail-user=noah.reid@uconn.edu
#SBATCH --mail-type=ALL
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 4
#SBATCH --mem=20G
#SBATCH --qos=general
#SBATCH --partition=general

module load htslib/1.9

FB=~/bin/freebayes/bin/freebayes
GENOME=../../genome/GCF_000826765.1_Fundulus_heteroclitus-3.0.2_genomic.fasta

OUTDIR=../../results/variants
mkdir -p $OUTDIR

# bam list
BAMLIST=$OUTDIR/all_bams.list
find $INDIR -name "*bam" | grep -v "disc" | grep -v "split" | sort >$BAMLIST

# need to re-make populations file to reflect read group sample IDs

$FB \
-f $GENOME \
--bam-list $OUTDIR/bams.list \
-T 0.01 \
-k \
--skip-coverage 6000 \
--haplotype-length 0 \
--use-best-n-alleles 25 \
-r NW_012224401.1 | \
bgzip >$OUTDIR/mm4.vcf.gz

