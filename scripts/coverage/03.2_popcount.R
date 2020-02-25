library(dplyr)
library(stringr)


options(scipen=99)


# this script takes `samtools mpileup` output and 
# gives per-base coverage for each population, as 
# specified in the metadata table

# get metadata table
met <- read.csv("../../metadata/all_samples_V2.csv",stringsAsFactors=FALSE)
rownames(met) <- met[,1]

# get sample names from bam list. pileup is in the same order as bam list.
bams <- scan("../../results/coverage/bams.list",what="character") %>% 
	gsub(".*\\/","",.) %>% 
	gsub(".bam","",.) %>% 
	gsub("_[A-Z]+.*","",.)

# get population segment for each sample
pop <- met[bams,]$Pop_seg
popu <- unique(pop) %>% sort()

# a list of columns belonging to each population
slist <- lapply(sort(popu), FUN=function(x){which(pop==x)})

# read and process mpileup file
f <- file("stdin")
open(f)
ind <- 1

while(length(line <- readLines(f,n=1)) > 0) {

	# skip comment lines
	if(grepl("^#",line)){next()}
	line <- str_split(line,"\\t") %>% unlist()

	ind <- ind + 1

	# read count vector
		# first three fields are scaf, pos, alt base
		# three fields per sample afterward. 1st is depth. 
		# 886 samples, so to get the read count vector...
	rc <- line[-c(1,2,3)][seq(1,2658,3)] %>% as.numeric()
	
	# list of vectors of haploid genotypes per population
	rcp <- lapply(slist,FUN=function(x,v){x <- v[x]; sum(x > 0)},v=rc) %>% unlist()

	cat(paste(c(line[1:2],rcp),collapse="\t",sep=""),"\n",sep="")

	if((ind %% 100000) == 0){write(ind,stderr())}

}

