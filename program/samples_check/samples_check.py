'''this python script is for samples check. I found there are 1532 samples in genotype file (chr15.combined.poly.dose.vcf.gz)
and 1205 samples in gene_expression file(mtx_Mar_combat_32955.txt). For the next analysis, we should find the common samples 
from those two files, since we treat genotype as X and gene_expression as Y. 

July 9 by Molin Yue'''

# read in geno samples file
with open("/home/skardia_lab/clubhouse/research/projects/GENOA_AA_omics_mediation_analyses/Gene_expression/Data/samples_check/sampleID_J_vcf.txt","r") as vcf:
	vcfsamples = vcf.readlines()
# change it to a list that each item is a sampleID 
vcf_list = vcfsamples[0].split()
# read in gene expression samples file 
with open("/home/skardia_lab/clubhouse/research/projects/GENOA_AA_omics_mediation_analyses/Gene_expression/Data/samples_check/genesamples_J.txt","r") as gene_ex:
	gene_ex_list = []
# change it to a list in same format
	for ID in gene_ex:
		# delete the "\n"
		ID = ID.strip()
		gene_ex_list.append(ID)
gene_expre_sample_num = len(gene_ex_list)
genotype_sample_num = len(vcf_list)
print(genotype_sample_num)
print(gene_expre_sample_num)
#read in 1599 snps data sampples
with open("/home/skardia_lab/clubhouse/research/projects/GENOA_AA_omics_mediation_analyses/Gene_expression/Data/samples_check/pcsamples.txt") as pc:
    pc_samples =[]
    for ID in pc:
        ID = ID.strip()
        pc_samples.append(ID)
    del pc_samples[0]

print(len(pc_samples))
# intersection
common_samples = list(set(gene_ex_list).intersection(set(vcf_list)))
common_with_1599=list(set(common_samples).intersection(set(pc_samples)))
print(len(common_with_1599))

# write in file
analysis_samples = open("/home/skardia_lab/clubhouse/research/projects/GENOA_AA_omics_mediation_analyses/Gene_expression/Data/analysis_samples973.txt","w")

for i in common_with_1599:
	analysis_samples.write(i)
	analysis_samples.write('\n')
analysis_samples.close()




