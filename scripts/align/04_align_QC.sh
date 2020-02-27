#!/bin/bash
#SBATCH --job-name=align_qc
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=noah.reid@uconn.edu
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=5G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --array=[0-885]%30


module load samtools/1.9
module load bwa/0.7.17

# input, output directories
INDIR=../../results/alignments

OUTDIR=../../results/align_qc
mkdir -p $OUTDIR

# get bash array of main bam files
BAMS=($(ls $INDIR | grep -v "split" | grep -v "disc" | grep -v "bai$"))

# get single bam file
ONEBAM=${BAMS[$SLURM_ARRAY_TASK_ID]}

# run samtools stats
samtools stats $INDIR/$ONEBAM >$OUTDIR/${ONEBAM}.stats