#!/bin/bash

# command in inputs are 1=scaffold 2=bam list 3=reference genome

BAM=$2
GEN=$3

samtools mpileup -r $1 --ff 3852 --rf 2 -q 30 -Q 20 -f $GEN -b $BAM 
