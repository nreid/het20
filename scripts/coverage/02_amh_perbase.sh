#!/bin/bash 
#SBATCH --job-name=amh_depth
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


module load samtools/1.9
module load htslib/1.9

# output file/directory
OUTDIR=../../results/coverage
mkdir -p $OUTDIR

LIST=$OUTDIR/bams.list
find ../../results/alignments/ -name "*bam" | grep -v "disc" | grep -v "split" | sort >$LIST

# get depth for amh region

samtools depth -q 30 -Q 30 -f $LIST -r NW_012234285.1:160000-164000
