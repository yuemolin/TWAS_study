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
# mkdir "$Out_path/chr{1..22}"
{
	while read ID Chr
	do
		# GEMMA can not read .gz annotation file so that I decompression first
		gzip -d "$SNP_path/chr$Chr/$ID.annot.gz"
		SNPfile="$SNP_path/chr$Chr/$ID.bimbam.gz"
		Annofile="$SNP_path/chr$Chr/$ID.annot"
		let Pheno_col=$Pheno_col+1
		echo $Pheno_col
		cd $Out_path/chr$Chr
		qsub -cwd -b y -l vf=35G -N "$ID" "gemma -s 100000 -g $SNPfile -p $Phenofile -n $Pheno_col -a $Annofile -bslmm 1 -o $ID"
		# finally gzip all the .annot.gz file
		break
	done
} < $Gene_list

echo "FINISHED"
