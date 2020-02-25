#!/bin/bash 
#SBATCH --job-name=popcov
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=noah.reid@uconn.edu
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=10G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --array=[1001-2000]%30


module load samtools/1.9
module load htslib/1.9
module load R/3.6.1 

# this script counts the number of individuals with coverage for each site for each population

# list of bam files
BAMS=../../results/coverage/bams.list
# reference genome
GEN=../../genome/GCF_000826765.1_Fundulus_heteroclitus-3.0.2_genomic.fasta

# scaffold to run on 
SCAF=$(sed -n ${SLURM_ARRAY_TASK_ID}p ${GEN}.fai | cut -f 1)

# scripts in the pipeline
SCRIPT1=03.1_mpile.sh 
SCRIPT2=03.2_popcount.R

# specify output files/directories
OUTDIR=../../results/coverage/scaffolds_pop
mkdir -p $OUTDIR
OUTFILE=${SCAF}.pop.site.txt.gz

# run 
bash $SCRIPT1 $SCAF $BAMS $GEN | Rscript $SCRIPT2 | cat | bgzip -c >$OUTDIR/$OUTFILE

