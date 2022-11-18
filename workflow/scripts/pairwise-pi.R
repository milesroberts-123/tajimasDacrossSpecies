rm(list = ls())

# check if parallel package is installed
print("Loading packages...")
if (!require(parallel)) install.packages('parallel')
library(parallel)

if (!require(parallel)) install.packages('data.table')
library(data.table)

# get file names passed to script as arguments
print("Parsing arguments...")
args = commandArgs(trailingOnly=TRUE)

ploidy = as.numeric(args[1]) # ploidy
outputFile = args[2] # name of output file
threadCount = as.numeric(args[3]) # number of cores to use
indvs = args[grepl("012.indv", args)] # list of individuals in genotype matrices
mats = args[grepl(".012$", args)] # genotype matrices

# print arguments passed to script
print("Ploidy of organism:")
print(ploidy)

print("Output file name:")
print(outputFile)

print("Thread count:")
print(threadCount)

print("Individual ids:")
print(indvs)

print("Genotype matrices:")
print(mats)

#setwd("/mnt/ufs18/home-010/robe1195/Josephs_Lab_Projects/tajimasDacrossSpecies/workflow")
#mats = list.files(pattern = "*.012$")
#indvs = list.files(pattern = "*.012.indv")

# load genotype matrices and individual lists
print("Loading genotype matrices...")
#mats = mclapply(mats, read.table, header = F, mc.cores = threadCount)
#indvs = mclapply(indvs, read.table, header = F, mc.cores = threadCount)
mats = lapply(mats, fread, nThread = threadCount, header = F, data.table = F)
indvs = lapply(indvs, fread, nThread = threadCount, header = F, data.table = F)

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
mats = mclapply(mats, t, mc.cores = threadCount)

# remove top row from each matrix
print("Removing header from each matrix...")
remtop = function(x){
  x[-1,]
}

mats = mclapply(mats, remtop, mc.cores = threadCount)

# bind all matrices into one matrix
print("Binding matrices together...")
bigmat = as.data.frame(do.call("rbind", mats))
rownames(bigmat) = NULL

print("A subset of the matrix:")
bigmat[1:min(5, nrow(bigmat)), 1:min(5, ncol(bigmat))]

# add sample names
print("Adding column names...")
colnames(bigmat) = indvs$V1

print("A subset of the matrix:")
bigmat[1:min(5, nrow(bigmat)), 1:min(5, ncol(bigmat))]

# subsample dataframe to speed up calculations
print("Sampling dataframe...")
bigmat = bigmat[sample(1:nrow(bigmat), 100000, replace = F),]

print("A subset of the matrix:")
bigmat[1:min(5, nrow(bigmat)), 1:min(5, ncol(bigmat))]

# replace -1 with NA
print("Replacing -1 with NA...")
bigmat[bigmat == -1] = NA

print("A subset of the matrix:")
bigmat[1:min(5, nrow(bigmat)), 1:min(5, ncol(bigmat))]

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

print("Total number of pair-wise distances to calculate:")
length(indices)

# function to calculate pi
heterozygosity = function(y, idxs, data, p){
  
  # get pair of indices
  idx = idxs[[y]]

  # subset pair of columns
  subset = data[,idx]
  
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
  result = sum(het, na.rm = T)/length(n[(n != 0)])

  # output progress update
  if(y %% 1000 == 0){
    print(paste(y, "pairwise pi's calculated", sep = " "))
  }

  return(result)

}

# calculate pairwise pi
print("Calculating pairwise pi...")
pis = unlist(mclapply(1:length(indices), heterozygosity, idxs = indices, data = bigmat, p = ploidy, mc.cores = threadCount))

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
