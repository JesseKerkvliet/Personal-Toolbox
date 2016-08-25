#!/bin/bash

SAMPLE=$1


cat ${SAMPLE}.out | awk  '{ print($1"\t"$7"\t"$8)}' > tmp.bed

python slicer.py ${SAMPLE}.fasta tmp.bed > ${SAMPLE}_sliced.fasta

rm tmp.bed

echo "Done!"



