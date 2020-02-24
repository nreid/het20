#!/bin/bash 
#SBATCH --job-name=test_filter_isec
#SBATCH --mail-user=noah.reid@uconn.edu
#SBATCH --mail-type=ALL
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 1
#SBATCH --mem=10G
#SBATCH --qos=general
#SBATCH --partition=general

module load bcftools/1.9
module load htslib/1.9

VAP=~/bin/vcflib/bin/vcfallelicprimitives

INDIR=../../results/variants

zcat $INDIR/freebayes_test.vcf.gz | \
$VAP | \
bcftools view -e "QUAL<30" | \
bgzip >$INDIR/freebayes_test_AP_q30.vcf.gz

tabix -p vcf $INDIR/freebayes_test_AP_q30.vcf.gz

zcat $INDIR/bcftools_test.vcf.gz | \
$VAP | \
bcftools view -e "QUAL<30" | \
bgzip >$INDIR/bcftools_test_AP_q30.vcf.gz

tabix -p vcf $INDIR/bcftools_test_AP_q30.vcf.gz

bcftools isec $INDIR/freebayes_test_AP_q30.vcf.gz.gz $INDIR/bcftools_test_AP_q30.vcf.gz -p $INDIR/isec_dir