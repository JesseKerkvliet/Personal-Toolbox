#!/usr/bin/Rscript
### Functions ###

## Used to filter on abundance and homozygosity but now just removes the VCF header ##
readVCF <- function(filename){
  vcf_file <- read.table(filename)
  # Extracting tabular data
  snplines <- grep("DP=",vcf_file$V8)
  snps <- vcf_file[snplines,]
return(snps)
}

# Function creates a unique ID based on the transcript ID and the SNP position 
setIndex <- function(vcf){
  indexedCol <- as.character(paste(vcf$V1, vcf$V2, sep=":"))
  vcf$index <- indexedCol
return(vcf)
}


# Function uses the phenotype matrix to calculate the SNPS consistent with phenotype
getConsistent.multi <- function(vcf, phenotypelist){
  
  NA_indices_full <- list()
  incorr_indices <- list()
  
  for(row in 1:nrow(phenotype.ma)){
    # For every row (=phenotype) the loop takes the SNP data of all individuals with said phenotype
    traitvals <- phenotype.ma[row,]
    NA_indices <- list()
    
    nucleotides <- vcf[traitvals]
    
    # Apply checks which length of unique nucleotides in that row (=unique SNP ID) is greater than 1
    # Giving the indices of SNPS that are inconsistent between individuals within a phenotype
    incorr_indices[[row]] <- which(apply(nucleotides, MARGIN=1, FUN = function(x) length(unique(x)) == 1))
    
    # Apply checks which rows (=unique SNP ID) has 'NA' for every SNP
    # Giving all SNPS that are absent within that phenotype (and thus present in >= 1 other phenotype)
    NA_indices <- which(apply(nucleotides, MARGIN=1, FUN = function(x) length(x[is.na(x)]) == ncol(nucleotides)))
    NA_indices_full[[row]] <- NA_indices
    
  }
  # The sets of incorrect and absent indices is matched and the SNPS consistent within phenotypes is returned
  correct_consistent <- unique(which(unlist(NA_indices_full) %in% unlist(incorr_indices)))
  consistentSNPS <- vcf[correct_consistent,]
  return(consistentSNPS)
}

# Load all SNP files into environment

VCF12B <- readVCF("./testVCF/12filteredQDC_test.vcf")
VCF14Y <- readVCF("./testVCF/14filteredQDC_test.vcf")
VCF16B <- readVCF("./testVCF/16filteredQDC_test.vcf")
VCF18Y <- readVCF("./testVCF/18filteredQDC_test.vcf")


# Make indices of transcript ID and SNP position
VCF12B.i <- setIndex(VCF12B)
VCF14Y.i <- setIndex(VCF14Y)
VCF16B.i <- setIndex(VCF16B)
VCF18Y.i <- setIndex(VCF18Y)


## To illustrate how this script would work with three individuals per trait value, I duplicated VCF12 and VCF14 ##
brown_samples <- list(VCF12B.i, VCF16B.i,VCF12B.i)
yellow_samples <- list(VCF14Y.i, VCF18Y.i,VCF14Y.i)

# Merging all the brown samples
## Change the suffixes depending on the number of individuals for that phenotype ##
sample_suffixes.b <- c("B1","B2","B3")
brown_SNPS <- Reduce(function(x,y) na.omit(merge(x,y, all=TRUE, by="index", suffixes=sample_suffixes.b )), brown_samples)

# Merging all the yellow samples
## Again, change the suffix vector ##
sample_suffixes.y <- c("Y1","Y2","Y3")
yellow_SNPS <- Reduce(function(x,y) na.omit(merge(x,y, all=T, by="index", suffixes=sample_suffixes.y )), yellow_samples)

# Merging the merged dataframes
## Add phenotypes if necessary ##
all_phenotypes <- list(brown_SNPS, yellow_SNPS)
## Play around with the suffixes, until you get a correct suffix for every one of your individuals ##
final_suffixes <- c("B3","Y3")
merged_full <- Reduce(function(x,y) merge(x,y, all=T, by="index", suffixes=final_suffixes), all_phenotypes)

## Phenotype matrix contains a row for every phenotype and a column for every individual with that phenotype ##
## The V4 is the column which contains the SNP nucleotide, so you put V4[sample suffix] for every sample/phenotype ##
## Change nrow to the number of phenotypes you have
## Note: I'm not sure how this would work out in unbalanced samples
phenotype.ma <- matrix(c("V4B1","V4B2",'V4B3',"V4Y1",'V4Y2',"V4Y3"),nrow=2,byrow = T)

consistentSNPS <- getConsistent.multi(merged_full, phenotype.ma)
print(dim(consistentSNPS))
