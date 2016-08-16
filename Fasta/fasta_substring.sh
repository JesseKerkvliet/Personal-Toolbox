#!/bin/bash
# Variables for contig, input start and length (end-start)
CONTIG=$1
INPUT=$2
END=$(($4-$3))
START=$3

# If the end position is less than the start position, swap them
if [ "${END}" -lt 0 ]
then
END=$(($3-$4))
START=$4
fi

# Look for the contig and it's sequence, print the header and substring the sequence
egrep "${CONTIG}" ${INPUT} -A1 | awk '{ if (substr($1,1,1) == ">") print $0; else print substr($1, '"${START}"', '"${END}"')}'   