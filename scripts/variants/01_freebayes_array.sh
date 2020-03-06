#!/bin/bash 
#SBATCH --job-name=freebayes
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

module load htslib/1.9

# freebayes installed in my home directory
FB=~/bin/freebayes/bin/freebayes

# input/output directories, supplemental files

# ref genome
GENOME=../../genome/GCF_000826765.1_Fundulus_heteroclitus-3.0.2_genomic.fasta

INDIR=../../results/alignments

OUTDIR=../../results/variants/fb_scaffold
mkdir -p $OUTDIR

# bam list
BAMLIST=$OUTDIR/all_bams.list
# this bam list must already exist. 
	# recreating it in the array script causes collisions
# to create BAMLIST:
	# find $INDIR -name "*bam" | grep -v "disc" | grep -v "split" | sort >$BAMLIST


# which scaffold to run on:
# array increment (array index is 1-1000, to get scaffold 1001 need to add 1k, etc)
ARINC=$1
# line number of scaffold in fai file
SN=$(($SLURM_ARRAY_TASK_ID + $ARINC))
# scaffold name from fai file
SCAF=$(sed -n ${SN}p ${GENOME}.fai | cut -f 1)


# run freebayes
$FB \
-f $GENOME \
--bam-list $BAMLIST \
-T 0.01 \
-k \
--skip-coverage 8000 \
--haplotype-length 0 \
--use-best-n-alleles 25 \
-r $SCAF | \
bgzip >$OUTDIR/freebayes_test.vcf.gz


