#!/bin/bash
geneFile=$1
vcfFile=$2
out_path=$3
{
	read
	while read -r num geneID chr start end description
	do
		echo "Number: $num"
                echo "chromosome: $chr"
                echo "_______________________________"

                chrins=${vcfFile%.combined.poly.dose.vcf.gz}
                chrnum=${chrins#*chr}

		if [ $chr == $chrnum ];then
			lft_range=`expr $start - 1000000`
			rt_range=`expr $end + 1000000`
			#could finished by only one times bcftools but this is more time consuming when you put bcftools view into loops
			bcftools view -v snps -i "MAF>0.01 & R2>0.8" -r "$chr:$lft_range-$rt_range" $vcfFile |
                        bcftools query -H -f '%ID, %CHROM, %POS, %REF, %ALT{}, [%DS, ]\n' |
                        gzip  > "$out_path/$geneID.gz"
		fi
	done
} < $geneFile

