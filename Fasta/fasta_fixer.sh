#!/bin/bash
# Convert multi-line fasta to single-line fasta
# Arg 1: input
# Arg 2: output

awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < "${1}" > "${2}"