PCs <- read.table("/home/skardia_lab/clubhouse/research/projects/GENOA_AA_GE/preprocessing_zxu_March2017/Lulu_Mar2018/Binary_files_for_measured_SNPs/Jack1599/AA_1599_PC20_from_pcair.csv",header = T,row.names=1,sep=',')
load("/home/skardia_lab/clubhouse/research/projects/GENOA_AA_GE/preprocessing_zxu_March2017/Lulu_Mar2018/gene_expression/sample_info.RData")
# input gene_expression data
load('/home/skardia_lab/clubhouse/research/projects/GENOA_AA_omics_mediation_analyses/Gene_expression/Data/gene_ex.Rdata')
# input samples list, this are the common samples between gene_expression and SNPs
samplesID <- read.table("/home/skardia_lab/clubhouse/research/projects/GENOA_AA_omics_mediation_analyses/Gene_expression/Data/analysis_samples989.txt",header = F)
geneID <- read.table("/home/skardia_lab/clubhouse/research/projects/GENOA_AA_omics_mediation_analyses/Gene_expression/Data/geneID.txt")
colnames(gene_ex)<-meta_new$PIN
pc_use <- PCs[match(samplesID[,1],rownames(PCs)),]
meta_use<-meta_new[match(samplesID[,1],meta_new$PIN),]
gene_use<-t(gene_ex[,match(samplesID[,1],colnames(gene_ex))])
regre_mat <- cbind(gene_use,meta_use$gender,meta_use$age,pc_use[,1:5])
names(regre_mat)[32956:32962]<-c("gender","age","pc1","pc2","pc3","pc4","pc5")
rs <- data.frame(samplesID$V1)
for (gene in geneID)
{
	mod = lm(get(gene)~ age +gender+pc1+pc2+pc3+pc4+pc5,data = regre_mat,na.action = na.exclude)
	rs[,gene] <-residuals(mod)
}
save(rs,file = "/home/skardia_lab/clubhouse/research/projects/GENOA_AA_omics_mediation_analyses/Gene_expression/Data/residuals.Rdata")