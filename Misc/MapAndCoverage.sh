#!/bin/bash

# Additional information:
# =======================
#
# Remarks about the Skeleton Script Bash itself.
# Description how it works.
# Description which improvements can be done to improve the Skeleton Script Bash itself.
#

function MapReads {

bowtie2-build "$1" "$4"

bowtie2-align -x "$4" -1 "$2" -2 "$3" > "${4}.sam"

samtools view -Sb "${4}.sam" | samtools sort - "${4}"
}
#function CheckSoftware{
#	$(bowtie2-align --version)
#	if [ $? -ne 0 ]; then
#	echo "Installing bowtie2"
#	apt-get install bowtie2
#	fi
	
#	$(bedtools --version )
#	if [ $? -ne 0 ]; then
#		echo "Installing bedtools"
#		apt-get install bedtools
#	if
#	$(samtools --version)
#	if [ $? -ne 0 ]; then
#		echo "Installing samtools"
#		apt-get install samtools
#	fi
	
#}

function CalcCoverage {

	bedtools genomecov -ibam  "${1}.bam" -d -split > "${1}.cov"
	
}
# Show usage information:
if [ "$1" == "--h" ] || [ "$1" == "--help" ] || [ "$1" == "-h" ] || [ "$1" == "-help" ]
then
	echo "" 
	echo "MapAndCoverage aligns reads of one sample to its assembly"
	echo "After alignment, it calculates the read coverage per base using Bedtools"
	echo "Three pieces of software are needed to run:"
	echo "Samtools, Bowtie2 and bedtools. On a ubuntu system, these can be acquired with"
	echo "sudo apt-get install {software}"
	echo "Way of usage:" 
	echo "For alignment only:"
	echo "bash MapAndCoverage.sh -M [Assembly] [reads-1] [reads-2] [run name]"
	echo "The user has to type here how he has to work with the Bash script."
	echo "For Coverage calculation only:"
	echo "bash MapAndCoverage.sh -C [bam prefix]" 
	echo "For both alignment and calculation:"
	echo "bash MapAndCoverage.sh -M [Assembly] [reads-1] [reads-2] [run name]"
	
	exit  
fi
echo "First, we will install some software if it isn't present"
#sCheckSoftware 
# Real Bash script starts from here...
if [ "$1"  == "-M" ]; then
MapReads "${2}" "${3}" "${4}" "${5}"
exit
fi
if [ "$1" == "-C" ]; then
CalcCoverage "${2}"
exit
fi
if [ "$1" == "-B" ]; then
MapReads "${2}" "${3}" "${4}" "${5}"
CalcCoverage "${5}"
fi
#$1 Flag
#$2 -M/-B reference, -C name 
#$3 -M/-B side one of reads
#$4 -M/-B side two of reads
#$5 -M/-B name

