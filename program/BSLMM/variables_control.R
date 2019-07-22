PCs <- read.table("/home/skardia_lab/clubhouse/research/projects/GENOA_AA_GE/preprocessing_zxu_March2017/Lulu_Mar2018/Binary_files_for_measured_SNPs/Jack1599/AA_1599_PC20_from_pcair.csv",header = T,row.names=1,sep=',')
load("/home/skardia_lab/clubhouse/research/projects/GENOA_AA_GE/preprocessing_zxu_March2017/Lulu_Mar2018/gene_expression/sample_info.RData")
# input gene_expression data
load('/home/skardia_lab/clubhouse/research/projects/GENOA_AA_omics_mediation_analyses/Gene_expression/Data/gene_ex.Rdata')
# input samples list, this are the common samples between gene_expression and SNPs
samplesID <- read.table("/home/skardia_lab/clubhouse/research/projects/GENOA_AA_omics_mediation_analyses/Gene_expression/Data/analysis_samples973.txt",header = F)
# since the colnames of gene_ex are RJ code and for meta_new is J code.
# A transformation is needed, since the order of the RJ code are exactly the same with J code, then use the J code as the new col.names can do the transformation
colnames(gene_ex)<-meta_new$PIN
# pc_use is take the subset of PCs(1599), the subset is the samples list that we will us
pc_use <- PCs[match(samplesID[,1],rownames(PCs)),]
# similarly we need prepare gender and age information for our samples
meta_use<-meta_new[match(samplesID[,1],meta_new$PIN),]
# filter out the samples we need then do a transpose to fit the BSLMM input
gene_use<-t(gene_ex[,match(samplesID[,1],colnames(gene_ex))])
# combined those information we need
regre_mat <- cbind(gene_use,meta_use$gender,meta_use$age,pc_use[,1:5])
# rename those variables the num of gene are 32955 then plus gender and age and the top 5 PCs would be 32955+1+1+5=32962
names(regre_mat)[32956:32962]<-c("gender","age","pc1","pc2","pc3","pc4","pc5")
# create the result dataframe with the J code as the first colunmn
rs <- data.frame(samplesID$V1)
# for each geneID run a linear regression to get the residual to control for the age gender and PCs
for (gene in colnames(regre_mat[1:32955]))
{
	mod = lm(get(gene)~ age + gender + pc1 + pc2 + pc3 + pc4 + pc5, data = regre_mat)
	rs[,gene] <-residuals(mod)

}
row.names(rs) <- rs[,1]
rs<-rs[,-1]
write.table(rs,file = "/home/skardia_lab/clubhouse/research/projects/GENOA_AA_omics_mediation_analyses/Gene_expression/Data/BSLMM_Pheno_after_control.txt",sep=' ',row.names=F,col.names=F,quote=F)
save(rs,file = "/home/skardia_lab/clubhouse/research/projects/GENOA_AA_omics_mediation_analyses/Gene_expression/Data/residuals_after_var_control.Rdata")
