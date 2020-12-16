#!/bin/bash 
#SBATCH --job-name=aggregate_align_qc
#SBATCH --mail-user=noah.reid@uconn.edu
#SBATCH --mail-type=ALL
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 1
#SBATCH --mem=10G
#SBATCH --qos=general
#SBATCH --partition=general


# input, output directories

INDIR=../../results/align_qc

# put the basic stats all in one file. 

FILES=($(find $INDIR -name "*bam.stats" | sort))

grep "^SN" ${FILES[0]} | cut -f 2 > $INDIR/SN.txt
for file in ${FILES[@]}
do paste $INDIR/SN.txt <(grep ^SN $file | cut -f 3) > $INDIR/SN2.txt && \
	mv $INDIR/SN2.txt $INDIR/SN.txt
done
