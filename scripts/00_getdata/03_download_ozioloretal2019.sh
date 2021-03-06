#!/bin/bash
#SBATCH --job-name=getoziolor2016
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 30
#SBATCH --mem=25G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mail-user=first.last@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

hostname
date

# load software
module load sratoolkit/2.10.8
module load parallel/20180122

# input/output files, directories

OUTDIR=../../data/ozioloretal2019
mkdir -p $OUTDIR

METATABLE=../../metadata/Ozioloretal2019_wgs_SRA_accessions.txt

# accession numbers from table, fasterq-dump in parallel
cut -d "," -f 1 $METATABLE | tail -n +2 | \
parallel -k -j 5 fasterq-dump {} -O $OUTDIR -e 6 -t $OUTDIR

# gzip files
ls $OUTDIR/*fastq | parallel -j 30 gzip