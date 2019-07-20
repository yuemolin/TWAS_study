#Extract the cis-snps about an gene expression . Each gene has one file contains
#all the snps in gene expression plus-minus 1MB range

# there should be 3 var input
if [ $# -ne 3 ];then
        echo "Usage: $0 Gene_expression Vcf_files Output_location"
        exit 1
fi

# gene expression annotation file 
geneFile=$1
# vcf snps file (Notice that different chr input should change the code below!) 
vcfFile=$2
# the directory of the output file
out_path=$3
# transform vcf file to bcf file and filter MAF and R2 then output 
bcftools view -O b -v snps -i "MAF>0.01 & R2>0.8" $vcfFile -o "$out_path/temp.bcf.gz"
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
                echo "Number: $num"
                echo "chromosome: $chr"
                echo "_______________________________"
                #the next two lines are to extract the chromosome number
                #chrins deal with whole file name and split the latter part
                #chrnum delete the former part and get the CHR number 
                chrins=${vcfFile%.combined.poly.dose.vcf.gz}
                chrnum=${chrins#*chr}
                #extract only when the input chr = chr in genefile
                if [ $chr == $chrnum ];then
                        lft_range=`expr $start - 1000000`
                        rt_range=`expr $end + 1000000`

                        bcftools view -r "$chr:$lft_range-$rt_range" "$out_path/temp.bcf.gz" |
                        bcftools query -H -f '%ID, %CHROM, %POS, %REF, %ALT{}, [%DS, ]\n' |
                        gzip  > "$out_path/$geneID.gz"
                fi
        done
} < $geneFile

rm $out_path/temp.bcf.gz
rm $out_path/temp.bcf.gz.csi

echo "done"

