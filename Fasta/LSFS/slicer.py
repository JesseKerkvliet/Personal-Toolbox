#!/usr/bin/env python
# extract fasta sequence by their position
# Downloaded from http://www.bioinformatics-made-simple.com/2013/10/actually-i-have-hundreds-of-protein.html
import sys
import re

def main():
    
    fasta_file = sys.argv[1]
    bed_file = sys.argv[2]
    fasta_dict = get_fasta(fasta_file)
    get_bed(bed_file, fasta_dict)
def get_fasta(gf_fastafile):   
    fasta= open(gf_fastafile, 'U')
    fasta_dict= {}  
    for line in fasta:
        line= line.strip()
        if line == '':
            continue
        if line.startswith('>'):
            seqname= line.lstrip('>')
            seqname= re.sub('\..*', '', seqname)
            fasta_dict[seqname]= ''
        else:
            fasta_dict[seqname] += line
    fasta.close()
    return fasta_dict

def get_bed(gb_bedfile, gb_fastadict):
    bed= open(gb_bedfile, 'U')
    for line in bed:
        line= line.strip().split('\t')
        outname= line[0] + ':' + line[1] + '-' + line[2]
        print('>' + outname)
        startpos= int(line[1])
        endpos= int(line[2])
        print(gb_fastadict[line[0]][startpos:endpos])
    bed.close()
    sys.exit()
main()
