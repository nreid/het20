#!/bin/bash 
#SBATCH --job-name=gatk_dbimport
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 7
#SBATCH --mem=30G
#SBATCH --qos=general
#SBATCH --partition=general
#SBATCH --mail-user=
#SBATCH --mail-type=ALL
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err



hostname
date

# load required software
module load GATK/4.1.3.0

# input, output directories, files
INDIR=../../results/variants/GATK_gvcf

OUTDIR=../../results/variants/GATK_DB

GVCFS=$(ls ${INDIR}/*g.vcf | sed 's/^/-V /' | tr "\n" "\t")


#IMPORTANT: The -Xmx value the tool is run with should be less than the total amount of physical memory available by at least a few GB, as the native TileDB library requires additional memory on top of the Java memory. Failure to leave enough memory for the native code can result in confusing error messages!
gatk --java-options "-Xmx30g -Xms4g" GenomicsDBImport \
  $GVCFS \
  --genomicsdb-workspace-path $OUTDIR \
  --overwrite-existing-genomicsdb-workspace true \
  --batch-size 50 \
  -L NW_012224401.1

date