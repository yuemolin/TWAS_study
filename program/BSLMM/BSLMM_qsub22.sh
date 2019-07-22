#!/bin/bash
# running BSLMM for SNPs data and gene_expression data 
if [ $# -ne 4 ]; then
	echo "Usage: $0 Gene_list SNP_path Phenofile Out_path"
	exit 1
fi

Gene_list=$1
SNP_path=$2 
Phenofile=$3
Out_path=$4
Pheno_col=0
#mkdir $Out_path/chr{1..22}
#{
#	while read ID Chr
#	do
#		let Pheno_col=$Pheno_col+1
#		echo "$ID $Pheno_col" >> "$Out_path/chr$Chr/chr_list$Chr.txt"
#	done
#} < $Gene_list

#换行符号有问题还没解决

for ((i=1; i<=22; i++)); do
	qsub -cwd -b y -N "chr$i" "cat "$Out_path/chr$i/chr_list$i.txt" | while read ID num \
	do \
		# GEMMA can not read .gz annotation file so that I decompression first \
		gzip -d "$SNP_path/chr$i/$ID.annot.gz" \
		SNPfile="$SNP_path/chr$i/$ID.bimbam.gz" \
		Annofile="$SNP_path/chr$i/$ID.annot" \
		echo $num \
		cd $Out_path/chr$i \
		gemma -w 100000 -s 100000 -g $SNPfile -p $Phenofile -n $num -a $Annofile -bslmm 1 -o $ID \
	done \
	gzip "$SNP_path/chr$i/*.annot" "
done

echo "FINISHED"
