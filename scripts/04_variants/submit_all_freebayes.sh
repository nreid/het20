#!/bin/bash

# submit all regions for variant calling by freebayes
# not an sbatch script

# load software
module load bedtools/2.29.0

# create windows
FAI=../../genome/GCF_011125445.2_MU-UCD_Fhet_4.1_genomic.fna.fai
OUT=../../genome/500kbwin.bed

bedtools makewindows -g $FAI -w 500000 -s 500000 >$OUT

# create bam list
INDIR=../../results/alignments
OUTDIR=../../results/variants/fb_scaffold
mkdir -p $OUTDIR

# bam list
BAMLIST=$OUTDIR/all_bams.list
# this bam list must already exist. 
	# recreating it in the array script causes collisions
# to create BAMLIST:
find $INDIR -name "*bam" | grep -v "disc" | grep -v "split" | sort >$BAMLIST

# submit freebayes scripts
sbatch freebayes.sh 0
sbatch freebayes.sh 1000
sbatch freebayes.sh 2000
sbatch --array=1-183 freebayes.sh 3000