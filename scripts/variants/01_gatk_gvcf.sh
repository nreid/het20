#!/bin/bash 
#SBATCH --job-name=gatk_HC
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 5
#SBATCH --mem=15G
#SBATCH --qos=general
#SBATCH --partition=xeon
#SBATCH --mail-user=
#SBATCH --mail-type=ALL
#SBATCH --array=[0-885]%30



hostname
date

# make sure partition is specified as `xeon` to prevent slowdowns on amd processors. 

# load required software

module load GATK/4.1.3.0

# ref genome
GENOME=../../genome/GCF_000826765.1_Fundulus_heteroclitus-3.0.2_genomic.fasta

INDIR=../../results/alignments

OUTDIR=../../results/variants/GATK_gvcf
mkdir -p $OUTDIR

# bam list
BAMLIST=$OUTDIR/all_bams.list
# this bam list must already exist. 
     # recreating it in the array script causes collisions
# to create BAMLIST:
     # find $INDIR -name "*bam" | grep -v "disc" | grep -v "split" | sort >$BAMLIST

BN=$(($SLURM_ARRAY_TASK_ID + 1))
BAM=$(sed -n ${BN}p $BAMLIST)

gatk HaplotypeCaller \
     -R $GENOME \
     -I $BAM \
     -ERC GVCF \
     --heterozygosity 0.01 \
     --indel-heterozygosity 0.001 \
     --output $OUTDIR/

date 

