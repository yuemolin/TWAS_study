#!/bin/bash
#Molin Yue 07/04/2019


#Extract the cis-snps about an gene expression . Each gene has one file contains
#all the snps in gene expression plus-minus 1MB range

# there should be 4 var input see below
if [ $# -ne 4 ];then 
	echo "Usage: $0 Gene_expression Vcf_files Output_location Samples"
	exit 1
fi

# gene expression annotation file 
geneFile=$1 
# vcf snps file (Notice that different chr input should change the code below!) 
vcfFile=$2
# the directory of the output file
out_path=$3
# the constrian samples
samples=$4
# transform vcf file to bcf file and filter MAF and R2 then output
bcftools view -O b -S $samples -v snps -i "MAF>0.01 & R2>0.8" $vcfFile -o "$out_path/temp.bcf.gz"
# creat an index file for code below
bcftools index -c "$out_path/temp.bcf.gz"

{
	# first line is colunmn name skip it 
	read
	# space delimitor
	#IFS = ' '
	# read in those variable and for each row of geneFile(each gene) creat a file including ID Chr Pos Ref Alt and samples dosage out put an zip file
	while read -r num geneID chr start end description
	do
		echo "Number : $num"
		echo "chromosome: $chr"
		echo "_______________________________"

		lft_range=`expr $start - 1000000`
		if [ lft_range -lt 0 ];then
			lft_range=0
		fi
		rt_range=`expr $end + 1000000`
		chrins=${vcfFile%.combined.poly.dose.vcf.gz}
		chrnum=${chrins#*chr}
	
		if [ $chr == $chrnum ];then
			qsub -cwd -b y -j n -N "$geneID" \
			"bcftools view -r "$chr:$lft_range-$rt_range" "$out_path/temp.bcf.gz" | \
			tee >(bcftools query -f '%ID, %ALT{}, %REF, [%DS, ]\n' | \
		       	gzip  > "$out_path/$geneID.bimbam.gz") | bcftools query -f '%ID, %POS, %CHROM\n' | \
			gzip > "$out_path/$geneID.annot.gz"" 
		fi
	done
} < $geneFile

#rm $out_path/temp.bcf.gz
#rm $out_path/temp.bcf.gz.csi

echo "Finish!!!!!!!!!"
