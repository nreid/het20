#!/bin/bash 
#SBATCH --job-name=test_variants
#SBATCH --mail-user=noah.reid@uconn.edu
#SBATCH --mail-type=ALL
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 4
#SBATCH --mem=10G
#SBATCH --qos=general
#SBATCH --partition=general



FB=~/bin/freebayes/bin/freebayes
GENOME=../../genome/GCF_000826765.1_Fundulus_heteroclitus-3.0.2_genomic.fasta

OUTDIR=../../results/test_trim/vcfs
mkdir -p $OUTDIR

find ../../results/test_trim/trimmed_alignments/*fastq.gz.bam >$OUTDIR/trimmed.list

cat $OUTDIR/trimmed.list | \
sed 's/test_trim\/trimmed_alignments/alignments/' | \
sed 's/_1P.fastq.gz//' \
>$OUTDIR/raw.list


$FB -f $GENOME --bam-list $OUTDIR/trimmed.list -r NW_012224401.1 >$OUTDIR/trimmed.vcf

$FB -f $GENOME --bam-list $OUTDIR/raw.list -r NW_012224401.1 >$OUTDIR/raw.vcf