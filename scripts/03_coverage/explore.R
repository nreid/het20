library(tidyverse)
library(data.table)

met <- read.csv("../../metadata/all_samples_V2.csv",stringsAsFactors=FALSE)
rownames(met) <- met[,1]

# 1kb windows
tab <- fread("fundulus_counts.txt.gz")
colnames(tab) <- gsub(".*/","",colnames(tab)) %>% gsub(".bam","",.)
colnames(tab)[grep("BU0",colnames(tab))] <- gsub("_.*","",colnames(tab)[grep("BU0",colnames(tab))])

# per base for amh
dep <- fread("amh_depth.txt.gz")
colnames(dep) <- c("scaf","pos",colnames(tab)[-c(1:6)])

# metadata
met <- met[colnames(tab)[-c(1:6)],]

# total counts
cs <- colSums(tab[,-c(1:6)])

# mean counts
cm <- cs / dim(tab)[1]

# samples with more than 500k fragments
subi <- cs > 500000

# tab <- tab[,c(1:6,which(subi))]
# met <- met[subi,]

amhwin <- which(tab[,2] == "NW_012234285.1" & tab[,3] >= 161000 & tab[,3] <= 162000)

amhs <- colMeans(tab[amhwin,-c(1:6)])/cs
 
amhd <- (colMeans(dep[,-c(1:2)])/cs)

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