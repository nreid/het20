#!/bin/bash 
#SBATCH --job-name=featurecounts
#SBATCH --mail-user=noah.reid@uconn.edu
#SBATCH --mail-type=ALL
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 8
#SBATCH --mem=10G
#SBATCH --qos=general
#SBATCH --partition=general



module load subread/1.6.0

# output file/directory
OUTDIR=../../results/coverage
mkdir -p $OUT
OUTFILE=fundulus_counts.txt

# 1kb window "annotation" file
ANN=../../genome/1kbwin.saf

# create a bam list
LIST=$OUT/bams.list
find ../../results/alignments/ -name "*bam" | grep -v "disc" | grep -v "split" | sort >$LIST


featureCounts \
-F SAF \
-Q 30 \
--primary \
-O \
-p \
-B \
-T 8 \
-a $ANN -o $OUTDIR/$OUTFILE $(cat $LIST | tr "\n" " ")

