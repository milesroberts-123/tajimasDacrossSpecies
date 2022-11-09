rm(list = ls())

# check if parallel package is installed
if (!require(parallel)) install.packages('parallel')
library(parallel)

# get file names passed to script as arguments
args = commandArgs(trailingOnly=TRUE)

ploidy = args[1] # ploidy
outputFile = args[2] # name of output file
indvs = args[grepl("012.indv", args)] # list of individuals in genotype matrices
mats = args[grepl(".012$", args)] # genotype matrices

#setwd("/mnt/ufs18/home-010/robe1195/Josephs_Lab_Projects/tajimasDacrossSpecies/workflow")
#mats = list.files(pattern = "*.012$")
#indvs = list.files(pattern = "*.012.indv")

# load genotype matrices and individual lists
print("Loading genotype matrices...")
mats = mclapply(mats, read.table, header = F)
indvs = mclapply(indvs, read.table, header = F)

# check that all lists of individuals are identical
print("binding lists of individuals...")
indvs = as.data.frame(do.call("cbind", indvs))

# function from https://stackoverflow.com/questions/18813526/check-whether-all-elements-of-a-list-are-in-equal-in-r
allSame <- function(x){
	length(unique(x)) == 1
}

print("Checking if all lists of individuals are identical...")
all(apply(indvs, allSame, MARGIN = 1))

# transpose
print("Transposing matrices...")
mats = mclapply(mats, t)

# remove top row from each matrix
print("Removing header from each matrix...")
remtop = function(x){
  x[-1,]
}

mats = mclapply(mats, remtop)

# bind all matrices into one matrix
print("Binding matrices together...")
bigmat = as.data.frame(do.call("rbind", mats))
rownames(bigmat) = NULL

print("A subset of the rbind matrix:")
bigmat[1:min(5, nrow(bigmat)), 1:min(5, ncol(bigmat))]

# add sample names
print("Adding column names...")
colnames(bigmat) = indvs$V1

# Get list of column pairs to loop over for calculating dissimilarity
print("Generating list of pairwise comparisons...")

indices = list()
k = 1
for(i in 1:(ncol(bigmat) - 1)){
  for(j in (i+1):ncol(bigmat)){
    indices[[k]] = colnames(bigmat)[c(i, j)]
    k = k + 1
  }
}

print("Some example indices:")
head(indices)

# function to calculate pi
heterozygosity = function(y, data, p){
  # subset pair of columns
  subset = data[,y]
  
  # number of non-missing genotype calls = number of individuals with non-missing genotypes * ploidy
  n = rowSums(!is.na(subset))*p
  
  # alternate allele frequency = number of alternate allele calls/number of non-missing genotype calls
  alt_frq = rowSums(subset, na.rm = T)/n
  
  # reference allele frequency = 1 - alternative allele frequency
  ref_frq = 1 - alt_frq
  
  # heterozygosity = frequency of heterozygotes * factor to correct for bias in estimator
  # frequency of heterozygoes = 1 - frequency of homozygotes
  # frequency of homozygotes = allele frequency^2
  het = (1 - (alt_frq^2 + ref_frq^2))*(n/(n - 1))
  
  # return average heterozygosity per site (i.e. pi)
  # sum of heterozygosities / number of non-missing sites
  sum(het, na.rm = T)/length(n[(n != 0)])
}

# calculate pairwise pi
print("Calculating pairwise pi...")
pis = unlist(mclapply(indices, heterozygosity, data = bigmat, p = 2))

print("Some example pairwise pi values:")
head(pis)

# check all pi values are valid
print("Are all pi values between zero and one?")
all(pis <= 1 & pis >= 0)

# Extract the pairs used for calculating pairwise pi
print("Adding names of genotypes compared to each pairwise comparison...")
mypairs = unlist(lapply(indices, paste, collapse = "-"))

print("Some example pair ids:")
head(mypairs)

# write output of pi calculations 
print("Writing pairwise pi calculations...")
write.table(data.frame(pairs = mypairs, pi = pis), outputFile, row.names = F, quote = F)
