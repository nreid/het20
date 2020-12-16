#!/bin/bash
#SBATCH --job-name=bwa
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=noah.reid@uconn.edu
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=5G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --array=[0-383]%20


module load samtools/1.9
module load bwa/0.7.17

# reference genome
GENOME=../../genome/GCF_000826765.1_Fundulus_heteroclitus-3.0.2_genomic.fasta.bgz

# output directory
OUTDIR=../../../data/Reidetal2016_alignments
mkdir -p $OUTDIR

# fastq file bash array
FQS=($(find -L ../../../data/Reidetal2016_merged -name "*fastq.gz" | grep "_R1.fastq.gz" | sort))

# fastq R1 file
FQ1=${FQS[$SLURM_ARRAY_TASK_ID]}

# execute alignment script, supplying fastq R1, output directory, and reference genome
bash align_generic_Reidetal2016.sh $FQ1 $OUTDIR $GENOME