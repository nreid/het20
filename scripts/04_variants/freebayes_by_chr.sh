#!/bin/bash 
#SBATCH --job-name=freebayes
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=noah.reid@uconn.edu
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=30
#SBATCH --mem=120G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --array=1-24

hostname
date

# command line option $1 is added to SLURM_ARRAY_TASK_ID
# this is because only 1000 tasks are allowed, and higher numbers are disallowed. 

# this version of the script tests the --min-alternate-count parameter, lowering it to 1. 


module load htslib/1.9
module load freebayes/1.3.1
module load vcflib/1.0.0-rc1
module load parallel/20180122

# input/output directories, supplemental files

# ref genome
GENOME=../../genome/GCF_011125445.2_MU-UCD_Fhet_4.1_genomic.fna

INDIR=../../results/alignments

OUTDIR=../../results/variants/fb_scaffold
mkdir -p $OUTDIR

# bam list
BAMLIST=$OUTDIR/all_bams.list
# this bam list must already exist. 
	# recreating it in the array script causes collisions
# to create BAMLIST:
	# find $INDIR -name "*bam" | grep -v "disc" | grep -v "split" | sort >$BAMLIST
WINDOWS=../../genome/500kbwin.bed

# FAI index file
FAI=../../genome/GCF_011125445.2_MU-UCD_Fhet_4.1_genomic.fna.fai

# which window to run on:
# array increment (array index is 1-1000, to get window 1001 need to add 1k, etc)
ARINC=$1
# line number of window in bed file
SN=$(($SLURM_ARRAY_TASK_ID + $ARINC))
# window from bed file
REGION=$(sed -n ${SN}p $FAI | cut -f 1)
echo $REGION

# run freebayes-parallel--------------------------------------------------------

bash freebayes_parallel.sh \
	<(grep ${REGION} $WINDOWS | sed 's/\t/:/' | sed 's/\t/-/') 30 \
	-f ${GENOME} \
	--bam-list $BAMLIST \
	-T 0.01 \
	-k \
	--skip-coverage 8000 \
	--haplotype-length 0 \
	--use-best-n-alleles 10 \
	--min-alternate-count 1 \
	--min-mapping-quality 25 \
	--min-base-quality 20 \
	--min-supporting-mapping-qsum 60 \
	--min-supporting-allele-qsum 33 \
bgzip -c >$OUTDIR/${REGION}.vcf.gz

# index the vcf file
tabix -p vcf $OUTDIR/${REGION}.vcf.gz



