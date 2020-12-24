library(tidyverse)
library(data.table)

# read in data----------------------------------------------------------------------------------

# read metadata table
met <- read.csv("../../metadata/all_samples_V2.csv",stringsAsFactors=FALSE)
rownames(met) <- met[,1]

# read in multiqc table
mqc <- read.table("../../results/fastqc/multiqc_data/multiqc_fastqc.txt",header=TRUE,sep="\t")

# read in mapping summary
maprate <- read.table("../../results/align_stats/SN.txt",header=TRUE,sep="\t")
	maprate <- t(maprate)
	rownames(maprate) <- gsub("^...","",rownames(maprate)) %>% gsub("\\.","-",.)
	colnames(maprate) <- gsub(" ", "_",colnames(maprate)) %>% gsub(":","",.) %>% gsub("\\(|\\)","",.)

# 1kb window fragment counts
tab <- fread("../../results/coverage/fundulus_counts.txt.gz")
	colnames(tab) <- gsub(".*/","",colnames(tab)) %>% gsub(".bam","",.)
	colnames(tab)[grep("BU0",colnames(tab))] <- gsub("_.*","",colnames(tab)[grep("BU0",colnames(tab))])

# reorder metadata columns
met <- met[colnames(tab)[-c(1:6)],]

# read in SRR to sample mappings
sra2sample <- read.table("../../metadata/sra2sampleID.txt")
	rownames(sra2sample) <- sra2sample[,1]

# check counts--------------------------------------------------------------------
	# check that fastqc read counts equal raw read counts in SAM files
	# this is just to ensure that no silent errors occurred during mapping

# get mqc counts, sum R1,R2, switch to sample names
mqccounts <- mqc[,c(1,13)]
	mqccounts[,1] <- gsub("_R*.$","",mqccounts[,1])
	mqccounts <- group_by(mqccounts,Sample) %>% summarize(sum(Total.Sequences)) %>% data.frame()
	mqccounts[,1] <- sra2sample[mqccounts[,1],2]

# put samtools stats counts and mqc counts together
counts <- data.frame(mqccounts,maprate[mqccounts[,1],1])

# are they all equal?
all(counts[,2]==counts[,3])



# total counts by sample
cs <- colSums(tab[,-c(1:6)])

# total counts by window
rs <- rowSums(tab[,-c(1:6)])

# mean counts
cm <- cs / dim(tab)[1]

# samples with more than 500k fragments
subi <- cs > 500000

# rows with less than 100k fragments and more than 500 fragments
subw <- rs < 100000 & rs > 500

# tab <- tab[,c(1:6,which(subi))]
# met <- met[subi,]

# check out amhy in reference genome
# amhy is here: NC_046364.1:16280419-16283399
amhwin <- which(tab[,2] == "NC_046364.1" & tab[,4] >= 16280419 & tab[,3] <= 16283399)
amhs <- colMeans(tab[amhwin,-c(1:6)])/cs

# coverage by sex in bermudae
berM <- which(met$Species=="bermudae" & met$Sex=="M")+6
berF <- which(met$Species=="bermudae" & met$Sex=="F")+6

berMs <- rowSums(tab[,..berM])
berFs <- rowSums(tab[,..berF])

subB <- (berMs > 500 | berFs > 500) & (berMs < 8000 & berFs < 8000)

plot(berMs[subB] - berFs[subB],pch=20,cex=.2,col=factor(tab[[2]][subB]),xlim=c(280000,330000))

plot(berMs[subB],pch=20,cex=.2,col="black",xlim=c(280000,330000),ylim=c(0,5000))
points(berFs[subB],pch=20,cex=.2,col="blue",xlim=c(280000,330000))

covrat <- rowSums(tab[,..berM])/rowSums(tab[,..berF])
covrat <- log(covrat,2) - median(log(covrat,2),na.rm=TRUE)
plot(covrat[subB],pch=20,cex=.2,col=factor(tab[[2]][subB]),xlim=c(280000,330000),ylim=c(-2,2))



biM <- which(met$Pop_tag=="BI" & met$Sex=="M")+6
biF <- which(met$Pop_tag=="BI" & met$Sex=="F")+6

biMs <- rowSums(tab[,..biM])
biFs <- rowSums(tab[,..biF])

subBi <- (biMs > 200 | biFs > 200) & (biMs < 8000 & biFs < 8000)


plot(berMs[subBi],pch=20,cex=.2,col="black",xlim=c(280000,330000),ylim=c(0,5000))
points(berFs[subBi],pch=20,cex=.2,col="blue",xlim=c(280000,330000))


# GDF6 windows (NC_046368.1:20208785-20211606)
	# weird windows in the region: NC_046368.1:20130000-20280000
gdf6 <- which(tab[[3]] >= 20208000 & tab[[4]] <= 20212000 & tab[[2]] == "NC_046368.1")
gdf6pre <- which(tab[[3]] >= 20138000 & tab[[4]] <= 20200000 & tab[[2]] == "NC_046368.1")
gdf6region <- which(tab[[3]] >= 20130000 & tab[[4]] <= 20280000 & tab[[2]] == "NC_046368.1")

plot(tab[314524:314924,][[3]],berMs[314524:314924]/sum(cs[berM]))
points(tab[314524:314924,][[3]],berFs[314524:314924]/sum(cs[berF]),col="blue",pch=20)
points(tab[314524:314924,][[3]],biFs[314524:314924]/sum(cs[biF]),col="gray",pch=20)
points(tab[314524:314924,][[3]],biMs[314524:314924]/sum(cs[biM]),col="red",pch=20)

plot(colSums(tab[gdf6pre,-c(1:6)])/cs,col=factor(met$Species),pch=as.numeric(factor(met$Sex)))
plot(colSums(tab[gdf6pre,-c(1:6)])/cs,col=factor(met$Species),pch=as.numeric(factor(met$Sex)),xlim=c(650,850))
points(colSums(tab[gdf6pre,-c(1:6)])/cs,pch=20,cex=.3)



plot(tab[gdf6pre,][[3]],berMs[gdf6pre]/sum(cs[berM]))


group_by(data.frame(sex=met$Sex,popseg=met$Pop_seg,amhd),popseg,sex) %>% summarize(.,median(amhd))










ahrwin <- which(tab[,2] == "NW_012234474.1")


bi <- grep("BI",colnames(tab))
er <- grep("ER",colnames(tab))
kc <- grep("KC",colnames(tab))
jx <- grep("BU18FLJX",colnames(tab))
re <- grep("relictus", met$Species)+6
be <- grep("bermudae", met$Species)+6

(rowSums(tab[ahrwin,..er])/rowSums(tab[ahrwin,..kc])) %>% plot()
(rowSums(tab[ahrwin,..jx])/rowSums(tab[ahrwin,..kc])/10) %>% points(.,col="red")

rbe <- rowMeans(tab[,..be])
rre <- rowMeans(tab[,..re])
rjx <- rowMeans(tab[,..jx])

subw <- (rbe+rjx) > 1

winrat <- (30 + rowMeans(tab[,..be]))/(30+rowMeans(tab[,..jx])))

hist(log(winrat,2),breaks=100)

tab[subw,2][which(log(winrat[subw],2) < -0.5 | log(winrat[subw],2) > 0.5)] %>% table() %>% sort() %>% tail(.,n=20)

plot(log(winrat[tab[,2]=="NW_012224437.1" & subw],2),pch=20,cex=.2)

plot((rbe+rjx)[tab[,2]=="NW_012224437.1" & subw],pch=20,cex=.2)
