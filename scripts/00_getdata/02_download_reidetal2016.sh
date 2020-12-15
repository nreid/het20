#!/bin/bash
#SBATCH --job-name=getreid2016
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 30
#SBATCH --mem=5G
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

OUTDIR=data/reidetal2016
mkdir -p $OUTDIR

METATABLE=../../metadata/Reidetal2016_wgs_SRA_accessions.txt

# accession numbers from table
ACC=$(cut -d "," -f 1 $METATABLE | tail -n +2 | tr "\n" " ")

# download files
fastqer-dump --split-files $ACC

# gzip files

ls $OUTDIR/*fastq | parallel gzip