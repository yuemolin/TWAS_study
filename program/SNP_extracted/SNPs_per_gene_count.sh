#!/bin/bash

Path=$1
for i in $(seq 1 22)
do
	cd "${Path}/chr${i}"
	gzip -d *.annot.gz
	ls *.annot > index.txt
	pwd >> ~/count.txt

	for line in $(cat index.txt)
	do
		wc -l "./$line" >> ~/count.txt
	done

	gzip *.annot
done
echo "Finished"
