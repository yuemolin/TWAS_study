#!/bin/bash

geneID=$1

cat $geneID | while read ID chr
do
	echo "$ID $chr" >> "./geneID_chr$chr"
done
