#!/bin/bash
#SBATCH --job-name=symlink
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 30
#SBATCH --mem=25G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --mail-type=ALL
#SBATCH --mail-user=first.last@uconn.edu
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

hostname
date

#####################
# symlink data
#####################

# this script symlinks the raw data pools to the working directory
	# instead of copying the raw data, we create pointers to it. 

# input, output directories
INDIR="/labs/Reid/data/MatsonMaydenSeqs"

RAWDATADIR=../../data/MatsonMaydenSeqs
mkdir -p $RAWDATADIR

# using a for loop, create a symlink for each fastq.gz file
for f in $(find ${INDIR} -name "*fastq.gz" | sort); do
        # write filename and file base name to standard out
        echo $f
        echo $(basename ${f})

        # symlink file	
        ln -s ${f} $RAWDATADIR/$(basename ${f})
done

