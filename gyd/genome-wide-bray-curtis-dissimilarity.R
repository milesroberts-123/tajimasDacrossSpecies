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

kmerFile = args[1]
bcdOutputFile = args[2]
normCountsOutputFile = args[3]
threadCount = as.numeric(args[4])

print("Input file:")
print(kmerFile)

print("Output files:")
print(bcdOutputFile)
print(normCountsOutputFile)

print("Thread count:")
print(threadCount)

# read key and all kmer count files into memory
print("Reading files into memory...")
kmerCounts = fread(kmerFile, nThread = threadCount, header = T, data.table = F)

# print out sample of matrix
print("Kmer matrix looks like this:")
kmerCounts[1:min(5, nrow(kmerCounts)),1:min(5, ncol(kmerCounts))]

# save header to add back later
myHeader = colnames(kmerCounts)[-1]

# remove kmer column to save on memory
print("Removing k-mer column to save on memory...")
kmerCounts = kmerCounts[,-1]

print("Kmer matrix looks like this:")
kmerCounts[1:min(5, nrow(kmerCounts)),1:min(5, ncol(kmerCounts))]

# normalize kmer counts in each sample to sum to 1
# convert inputs to numeric
print("Normalizing kmer counts to sum to 1 within each sample...")

myNormalize = function(x,data){
	y = data[,x]
	y = as.numeric(y)
	y/sum(y)
}

kmerCounts = mclapply(1:ncol(kmerCounts), myNormalize, data = kmerCounts, mc.cores = threadCount)

# cbind normalized counts into one frame
print("Column-binding normalized counts...")
kmerCounts = do.call("cbind", kmerCounts)

print("Kmer matrix looks like this:")
kmerCounts[1:min(5, nrow(kmerCounts)),1:min(5, ncol(kmerCounts))]

# add headers back to matrix
print("Adding headers back to column-bound counts...")
colnames(kmerCounts) = myHeader

print("Kmer matrix looks like this:")
kmerCounts[1:min(5,nrow(kmerCounts)),1:min(5,ncol(kmerCounts))]

# calculate dissimilarity between kmer profiles
brayCurtisDissimilarity = function(data){

  N = ncol(data)
  rowMinsSum = sum(apply(data, MARGIN = 1, FUN = min, na.rm = T))
  rowSumsSum = sum(rowSums(data))

  dissim = 1 - ((N*rowMinsSum)/rowSumsSum)

  result = c(N, rowMinsSum, rowSumsSum, dissim)
  names(result) = c("N", "rowMinsSum", "rowSumsSum", "dissimilarity")
  return(result)

}

# calculate dissimilarity
print("Calculating dissimilarity for each pairwise comparison...")
write.table(brayCurtisDissimilarity(kmerCounts), bcdOutputFile, row.names = F, quote = F)

# write normalized k-mer matrix
print("Writing normalized k-mer matrix...")
write.table(kmerCounts, normCountsOutputFile, row.names = F, quote = F)
