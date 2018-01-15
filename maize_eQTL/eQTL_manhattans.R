# create manhattan plot for genes of interest for the black module
setwd("/home/caryn89/rotations/maize_eQTL")

library(ggplot2)

modGenes <- read.table("module_Genes.txt", sep="\t", header=T)

blackGenes <- modGenes[modGenes$moduleColors_361 == "black",]
blackGenes$ps <- blackGenes$position_left

#the zag2 peak, in the black module, begins at 137255997, and ends at 137258288

zag2 <- data.frame("chr"=3,"ps"=as.integer(137256737))
zag2_peaks <- list()

for (i in seq(1:nrow(blackGenes))) {
  gene <- as.character(blackGenes[i,]$gene)
  gene.row <- as.data.frame(blackGenes[i,])
  genePath <- paste("data/eQTL/", gene, sep="")
  assocPath <- paste(genePath, "/output/", sep="")
  assocFile <- paste(paste("ZeaGBSv27_", gene, sep=""), ".assoc.txt", sep="")
  
  assoc <- read.table(paste(assocPath, assocFile, sep=""), header=T)
  #print(gene)
  
  #count and save the number of times a peak hits near zag2, within 1Kb
  assoc3 <- assoc[assoc$chr == 3,]
  assoc3_peaks <- assoc3[assoc3$p_score < 0.01,] #low sig threshold. I want to find peaks
  gene.zag.hit <- assoc3_peaks[assoc3_peaks$ps >= 137250997 && assoc3_peaks$ps <= 137263288,] #look for things within 5kb of start and stop
  if (dim(gene.zag.hit)[1] > 0) {
    zag2_peaks[[gene]] <- gene.zag.hit
  }
  
  #png_name <- paste(gene, ".png", sep="")
  #ggplot(assoc, aes(x=ps, y=-log10(p_score), colour=chr)) + geom_point() + 
  #  facet_grid(.~chr) + geom_vline(data=gene.row, aes(xintercept = ps)) + 
  #  geom_vline(data=zag2, colour="blue",aes(xintercept = ps)) +
  #  geom_hline(yintercept=-log10(1e-05), colour="red") +
  #  theme(axis.text=element_text(size=12),
  #        axis.title=element_text(size=14,face="bold"),
  #        strip.text.x = element_text(size = 18, face="bold"), legend.position = "none") + 
  #  xlab("Position") + ylab("- log10 (p)") + ggtitle(gene)
  #ggsave(filename = paste("/home/caryn89/rotations/maize_eQTL/data/figures/assoc_", png_name, sep=""))
}

save(zag2_peaks, file="zag2_hits.RData")


