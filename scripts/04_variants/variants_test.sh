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

# a basic test for variant calling with new data

FB=~/bin/freebayes/bin/freebayes
GENOME=../../genome/GCF_000826765.1_Fundulus_heteroclitus-3.0.2_genomic.fasta

OUTDIR=../../results/variants
mkdir -p $OUTDIR

find ../../results/alignments/RLM_*bam | grep -v disc | grep -v split >$OUTDIR/bams.list
find ../../results/alignments/BU1*bam | grep -v disc | grep -v split >>$OUTDIR/bams.list


$FB -f $GENOME -T 0.01 -k --bam-list $OUTDIR/bams.list -r NW_012224401.1 | bgzip >$OUTDIR/mm.vcf.gz

