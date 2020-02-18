#!/bin/bash
#SBATCH --job-name=concatenateBINBH
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=noah.reid@uconn.edu
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --array=[0-383]%50


# concatenate fastq files for BI and NBH populations prior to aligning. 
# these fastq files exist OUTSIDE the project directory
# this script should not be executed again. 
# a following script will align, again writing OUTSIDE the project directory
# bam files will be symlinked to /results/alignments

INDIR=../../../data/Reidetal2016_raw
OUTDIR=../../../data/Reidetal2016_merged
mkdir -p OUTDIR

# get sample IDs
SAMPLES=($(find $INDIR -name "*fastq.gz" | sed 's/.*\///' | sed 's/_[ACGT][ACGT].*//' | grep -v "_" | sort -V | uniq))

# get sample for this task
SAM=${SAMPLES[$SLURM_ARRAY_TASK_ID]}

# get array of fastq files for R1, R2
FQ1S=($(find $INDIR -name "${SAM}_*fastq.gz" | grep R1 | sort))
FQ2S=($(find $INDIR -name "${SAM}_*fastq.gz" | grep R2 | sort))

# concatenate R1
cat ${FQ1S[@]} >$OUTDIR/$SAM.merged_R1.fastq.gz
# concatenate R2
cat ${FQ2S[@]} >$OUTDIR/$SAM.merged_R2.fastq.gz

