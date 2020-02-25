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
module load R/3.6.1 

# list of bam files
BAMS=../../results/coverage/bams.list
# reference genome
GEN=../../genome/GCF_000826765.1_Fundulus_heteroclitus-3.0.2_genomic.fasta


SCRIPT1=03.1_mpile.sh 
SCRIPT2=03.2_popcount.R

OUTDIR=../../results/coverage/scaffolds_pop
mkdir -p $OUTDIR
OUTFILE=$1.pop.site.txt.gz

bash $SCRIPT1 $1 $BAMS $GEN | Rscript $SCRIPT2 | cat | bgzip -c >$OUTDIR/$OUTFILE