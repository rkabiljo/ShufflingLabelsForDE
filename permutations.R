library(DESeq2)
library("sva")
library("IHW")
args = commandArgs(trailingOnly=TRUE)
prefix=args[1]
#read phenotype data
phe <- read.table("../HERV_Matrices_RNASeq/test.samples.txt",row.names=1,header=T) 
phe$AgeCat <- cut(phe$Age, 5, labels = c('1','2','3','4','5'),include.lowest = TRUE, right = TRUE, dig.lab = 3,ordered_result = FALSE)
phe$PMDCat <- cut(phe$PMD, 5, labels = c('1','2','3','4','5'),include.lowest = TRUE, right = TRUE, dig.lab = 3,ordered_result = FALSE)
phe$Sex<- as.factor(phe$Sex)
library("magrittr")
phe$Status<- as.factor(phe$Status)
phe$Sex<- as.factor(phe$Sex)
phe$AgeCat<- as.factor(phe$AgeCat)
phe$PMDCat<- as.factor(phe$PMDCat)
phe$Status %<>% relevel("1")


#read genotype data
gene_cts <- read.table("../HERV_Matrices_RNASeq/merged_cellular.txt",row.names=1,header=T)

colnames(gene_cts) <- gsub("(.*)_(.*)_.*", "\\1_\\2", colnames(gene_cts))
gene_cts<-gene_cts[,!colnames(gene_cts) %in% 'A276_14']



phe_g<-phe
phe_g<-phe_g[colnames(gene_cts),]
dds_genes <- DESeqDataSetFromMatrix(countData = gene_cts, colData = phe_g , design = ~ Sex + AgeCat + PMDCat + Status)
dds_genes <- estimateSizeFactors(dds_genes)
idx <- rowSums( counts(dds_genes, normalized=T) >= 5 ) >= 10
dds_genes <- dds_genes[idx,]


dat  <- counts(dds_genes, normalized = TRUE)
idx  <- rowMeans(dat) > 1
dat  <- dat[idx, ]
mod  <- model.matrix(~ Sex + AgeCat + PMDCat + Status, colData(dds_genes))
mod0 <- model.matrix(~   1, colData(dds_genes))
nsv <- num.sv(dat,mod)
nsv
svseq <- svaseq(dat, mod, mod0, n.sv = nsv)
dds_genes$SV1 <- svseq$sv
design(dds_genes) <- ~ Sex + AgeCat + PMDCat + SV1 + Status

###dds_genes <- DESeq(dds_genes)
###resIHW <- results(dds_genes, filterFun=ihw)
#####Only 1 bin; IHW reduces to Benjamini Hochberg (uniform weights)

###resIHWOrdered <- resIHW[order(resIHW$pvalue),]
#sum(resIHW$padj < 0.1, na.rm=TRUE)
#[1] 256

###write.table(resIHWOrdered, "genesDEresOriginal.txt",sep="\t")

pheTest<-colData(dds_genes)
significant0_1<-c()
significant0_05<-c()
significant0_01<-c()

###significant0_1<-c(significant0_1,sum(resIHW$padj < 0.1, na.rm=TRUE))
###significant0_01<-c(significant0_01,sum(resIHW$padj < 0.01, na.rm=TRUE))
###significant0_05<-c(significant0_05,sum(resIHW$padj < 0.05, na.rm=TRUE))


for (x in c(1:100))
{
  
  pheTest <- transform(pheTest, Status = sample(Status) )
  dds_genes <- DESeqDataSetFromMatrix(countData = gene_cts, colData = pheTest , design = ~ Sex + AgeCat + PMDCat + SV1 + Status)
  dds_genes <- estimateSizeFactors(dds_genes)
  idx <- rowSums( counts(dds_genes, normalized=T) >= 5 ) >= 10
  dds_genes <- dds_genes[idx,]

  dds_genes <- DESeq(dds_genes)
  resIHW <- results(dds_genes, filterFun=ihw)
  significant0_1<-c(significant0_1,sum(resIHW$padj < 0.1, na.rm=TRUE))
  significant0_01<-c(significant0_01,sum(resIHW$padj < 0.01, na.rm=TRUE))
  significant0_05<-c(significant0_05,sum(resIHW$padj < 0.05, na.rm=TRUE))
  
}

sig<-rbind(significant0_1,significant0_01,significant0_05)
#write.table(sig, "significantPermutations.txt",sep="\t")
write.csv(sig, paste0("significantPermutations", prefix, format(Sys.time(), "%H.%M.%S"), ".csv"))
