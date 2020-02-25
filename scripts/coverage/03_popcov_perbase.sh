#!/bin/bash 
#SBATCH --job-name=amh_depth
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

module load samtools/1.9
module load htslib/1.9

BAMS=../../results/coverage/bams.list

