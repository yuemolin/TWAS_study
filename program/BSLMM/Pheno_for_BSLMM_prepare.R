#	This R script is for BSLMM pheno file preparing
#	By Molin_Yue Jul-10
#
#	Formate for BSLMM Phenotype is 
#
#	1.2  -0.3  -1.5
#	NA    1.5   0.3
#	2.7   1.1   NA
#	-0.2 -0.7   0.8
#	3.3   2.4   2.1
#	each row stands for each individuals 
#	each columns stands for each gene and no colnames and rownames
#

# load Rdata, this is samples information that to connect SNPs and gene_expression
# ID for gene_expression data is RJXXXXX(labid) and ID for SNPs(vcf) is JXXXXX(PIN)
load("/home/skardia_lab/clubhouse/research/projects/GENOA_AA_GE/preprocessing_zxu_March2017/Lulu_Mar2018/gene_expression/sample_info.RData")
# input gene_expression data
gene_ex <- read.table("/home/skardia_lab/clubhouse/research/projects/GENOA_AA_GE/preprocessing_zxu_March2017/Cleaned_data/mtx_Mar_combat_32955.txt",header = T)
# input samples list, this are the common samples between gene_expression and SNPs
samplesID <- read.table("/home/skardia_lab/clubhouse/research/projects/GENOA_AA_omics_mediation_analyses/Gene_expression/Data/analysis_samples989.txt",header = F)
# since the order of gene_expression samples are the same as it in samples infomation file 
# then use meta_new$PIN as the new colunme names 
colnames(gene_ex)<-meta_new$PIN
# match samples that we need and transform to the data formate we need 
result <- t(gene_ex[,match(samplesID[,1],colnames(gene_ex))])
# output the result
write.table(result, file = "/home/skardia_lab/clubhouse/research/projects/GENOA_AA_omics_mediation_analyses/Gene_expression/Data/Pheno_BSLMM.txt",row.names =F, col.names=F,quote=F)
write.table(result, file = "/home/skardia_lab/clubhouse/research/projects/GENOA_AA_omics_mediation_analyses/Gene_expression/Data/Pheno_BSLMM_header.txt",row.names =T, col.names=T,quote=F)
