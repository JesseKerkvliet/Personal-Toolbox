<------------------------------------------------------------------------->
<--------------------------Fasta manipulation tools----------------------->
<------------------------------------------------------------------------->

1. fasta_fixer.sh

Function: Converts multiline fasta to singleline fasta
Example: 
	input:
		>Some_sequence
		AACGACTGATCGACTGATCGATGC
		ACTACACTACGTAGCTACGTAGCT
		ACACTAGCTAGCTAGCTAGCATCG
	output:
		>Some_sequence
		AACGACTGATCGACTGATCGATGCACTACACTACGTAGCTACGTAGCTACACTAGCTAG
Parameters:
	${1} input file
	${2} output file

Usage example:
	bash fasta_fixer.sh mline.fasta sline.fasta


2. fasta_substring.sh
Function: returns the substring of a sequence in a fasta file 
(singleline, see fasta_fixer.sh)

Example:
	input:
		>Some_sequence
		AAACCCAAATTTGGGTTTAAACCCGGGTTT
		>Other_sequence
		AAACCCACACACACACACACTTGGTGTGTG
	output:
		>Some_sequence
		AAATTTGGGTTT
Parameters:
	${1} input file
	${2} contig name
	${3} start position
	${4} end position

Usage example:
	bash fasta_substring.sh sline.fasta Some_sequence 3 15

3. LSFS

Function: Extract fasta sequences corresponding to tabular BLAST hits
Example:
	input:
	1. Sample.out
		Some_sequence Some_hit [Some_stats] 3	15
		Some_other_sequence Some_other_hit [Some_stats] 4 18
	2. Sample.fasta
		>Some_sequence
		AACAGACTAGCATCGATCGATCGATCG
		>Some_other_sequence
		TAGCTAGCTAGCTAGCTAGATCTATCGA
	Output:
		>Some_sequence
		CAGACTAGCATC
		>Some_other_sequence
		CTAGCTAGCTAGCTA
		
Parameters:
	${1}: SAMPLE 
		SAMPLE.out 
		SAMPLE.fasta
Usage example:
	bash FastaSlicer.sh Some_sample

		
