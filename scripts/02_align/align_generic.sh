#!/bin/bash

# $1 fastq1
# $2 output directory
# $3 reference genome

# samtools must be loaded or in $PATH

# specify fq files
fq1=$1
fq2=$(echo $fq1 | sed 's/1.fastq.gz/2.fastq.gz/')

# sample ID and read group
sam=$(basename $1 | sed 's/_R*[12].fastq.gz//')
rg=$(echo \@RG\\tID:$sam\\tPL:Illumina\\tPU:x\\tLB:x\\tSM:$sam)

# output root, directory
outdir=$2
outroot=$sam

# reference genome
bwagenind=$3

# bwa command
cmdline=bwa\ mem\ $bwagenind\ -t\ 2\ -R\ $rg\ $fq1\ $fq2
echo $cmdline

# execute bwa command line, pipe to samblaster to mark duplicates and create files containing discordant and split alignments, then to samtools to sort output. 
$cmdline | \
samblaster -e -d $outdir/$outroot.disc.sam -s $outdir/$outroot.split.sam | \
samtools view -S -h -u - | \
samtools sort -T $outdir/$outroot - \
>$outdir/$outroot.bam

# index bam file
samtools index $outdir/$outroot.bam

# sort, compress, index disc
samtools view -S -h -u $outdir/$outroot.disc.sam | samtools sort -T $outdir/$outroot - >$outdir/$outroot.disc.bam
samtools index $outdir/$outroot.disc.bam
rm $outdir/$outroot.disc.sam

# sort, compress, index split
samtools view -S -h -u $outdir/$outroot.split.sam | samtools sort -T $outdir/$outroot - >$outdir/$outroot.split.bam
samtools index $outdir/$outroot.split.bam
rm $outdir/$outroot.split.sam

