#!/bin/bash 
#SBATCH --job-name=gatk_HC
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 1
#SBATCH --mem=20G
#SBATCH --qos=general
#SBATCH --partition=xeon
#SBATCH --mail-user=
#SBATCH --mail-type=ALL
#SBATCH --array=[409,410,411,413,414,415,416,417,418,419,420,422,423,424,425,429,432,433,434,436,439,442,443,446,447,449,450,452,455,458,460,461,614,617,627,628,629,630,632,634,639,640,644,651,700,704,705,721,729,730,735,748,756,760,766,771,776,784,806,829,834]%30



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

OUTFILE=$(basename -s .bam $BAM).g.vcf

gatk HaplotypeCaller \
     -R $GENOME \
     -I $BAM \
     -ERC GVCF \
     --heterozygosity 0.01 \
     --indel-heterozygosity 0.001 \
     -L NW_012224401.1 \
     --output $OUTDIR/$OUTFILE

date 

