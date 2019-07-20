with open('./vcfsamples_1532.txt') as vcf:
	lines = vcf.readlines()
vcf_list = lines[0].split(" ")

with open('genesamples_J.txt') as gene:
	gene_list = []
	for line in gene.readlines():
		gene_list.append(line.strip())

with open('./lulusamples.txt') as lulu:
	lulu_list = []
	for line in lulu.readlines():
		lulu_list.append(line.strip())
molin_list = list(set(vcf_list).intersection(set(gene_list)))
print(len(molin_list))
print(len(lulu_list))
cha = set(lulu_list) - set(molin_list)
#J319464 J316642 J281509
print(cha)
print("J316642" in vcf_list)