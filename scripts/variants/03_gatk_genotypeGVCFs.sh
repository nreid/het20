#!/bin/bash 
#SBATCH --job-name=gatk_gen
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 7
#SBATCH --mem=15G
#SBATCH --qos=general
#SBATCH --partition=general
#SBATCH --mail-user=
#SBATCH --mail-type=ALL
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

hostname
date

# load required software
module load GATK/4.0

# set a variable for the reference genome location
GEN=/UCHC/PublicShare/Variant_Detection_Tutorials/Variant-Detection-Introduction-GATK_all/resources_all/Homo_sapiens_assembly38.fasta

DBDIR=../../results/variants/GATK_DB

VCF=

gatk GenotypeGVCFs \
    -R $GEN \
    -V gendb://$DBDIR \
    -O ../../results/variants/GATK_scaffold/NW_012224401.1


date

