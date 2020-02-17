#!/bin/bash 
#SBATCH --job-name=trim_test
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=noah.reid@uconn.edu
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --mem=10G
#SBATCH --partition=general
#SBATCH --qos=general
#SBATCH --array=[0-6]%7


module load samtools/1.9
module load bwa/0.7.17
module load Trimmomatic/0.36

# in this script, trim and align a subset of sequences
# in the next script, call variants on trimmed, untrimmed sequences, compare. 

# define array of sample IDs
SAMPLES=($(echo RLM_14517 RLM_14540 RLM_14565 RLM_14573 RLM_14948 BU18FLJX053 BU18FLJX044))

# trimmomatic
	# define input, output files and directories
	FASTQDIR=../../data/MatsonMaydenSeqs/2001UNHS-0541

	TRIMDIR=../../results/test_trim/trimmed_fastqs
	mkdir -p $TRIMDIR

	# adapter sequences
	ADAPT=../../metadata/wgs_adapters.fa

	#input, output fastqs
	SAM=${SAMPLES[$SLURM_ARRAY_TASK_ID]}
	INFILE1=$FASTQDIR/$SAM/${SAM}_R1.fastq.gz
	INFILE2=$FASTQDIR/$SAM/${SAM}_R2.fastq.gz
	OUTFILE=${SAM}.fastq.gz


	# run trimmomatic
	java -jar $Trimmomatic PE \
	-threads 12 \
	$INFILE1 $INFILE2 \
	-baseout $TRIMDIR/$OUTFILE \
	ILLUMINACLIP:$ADAPT:2:30:10 \
	LEADING:3 \
	TRAILING:3 \
	SLIDINGWINDOW:4:20 \
	MINLEN:45


# bwa alignment
	# align script
	ALN=../align/align_generic.sh
	# reference genome
	GENOME=../../genome/GCF_000826765.1_Fundulus_heteroclitus-3.0.2_genomic.fasta.bgz
	
	# output directory
	OUTDIR=../../results/test_trim/trimmed_alignments
	mkdir -p $OUTDIR
	
	# fastq R1 file
	FQ1=$TRIMDIR/${SAM}_1P.fastq.gz
	
	# execute alignment script, supplying fastq R1, output directory, and reference genome
	bash $ALN $FQ1 $OUTDIR $GENOME	


