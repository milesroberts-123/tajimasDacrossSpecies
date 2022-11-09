# check if parallel package is installed
if (!require(parallel)) install.packages('parallel')
library(parallel)

# get file names passed to script as arguments
args = commandArgs(trailingOnly=TRUE)

kmerFiles = args[1:(length(args)-1)]
outputFile = args[length(args)]

# read key and all kmer count files into memory
kmerCounts = mclapply(kmerFiles, read.table, header = F)

# merge key with kmer counts
kmerCountsMerged = Reduce(function(dtf1, dtf2) merge(dtf1, dtf2, by = "V1", all.x = TRUE), kmerCounts)

# add sample names to header
names(kmerCountsMerged)[1] = "kmer"
names(kmerCountsMerged) = gsub("_pe_kmers.txt", "", kmerFiles[-1])
names(kmerCountsMerged) = gsub("_se_kmers.txt", "", kmerFiles[-1])

# print out sample of matrix
print("Kmer matrix looks like this:")
kmerCountsMerged[1:5,1:5]

# normalize kmer counts in each sample to sum to 1
# convert inputs to numeric
myNormalize = function(x){
	x = as.numeric(x)
	x/sum(x)
}

kmerCountsMergedNorm = apply(kmerCountsMerged[-1,], myNormalize, MARGIN = 2)

# print out sample of matrix
print("Kmer matrix looks like this after normalization:")
kmerCountsMergedNorm[1:5,1:5]

# calculate dissimilarity between kmer profiles
# x = indices of two columns/samples to compare
# data = dataframe of normalized k-mer counts
brayCurtisDissimilarity=function(x, data){
  coly = data[,x[1]]
  colz = data[,x[2]]
  1 - (2*sum(pmin(coly,colz)))/sum(coly+colz)
}

# Get list of column pairs to loop over for calculating dissimilarity
indices = list()
k = 1
for(i in 1:(ncol(kmerCountsMergedNorm) - 1)){
  for(j in (i+1):ncol(kmerCountsMergedNorm)){
    indices[[k]] = names(kmerCountsMergedNorm)[c(i, j)]
    k = k + 1
  }
}

# calculate dissimilarity
dissim = unlist(mclapply(indices, brayCurtisDissimilarity, data = kmerCountsMergedNorm))

# Extract the pairs used for calculating dissimilarity
pairs = unlist(lapply(indices, paste, collapse = "-"))

# write output of dissimilarity calculations 
write.table(data.frame(pairs = pairs, dissim = dissim), outputFile, row.names = F, quote = F)

# write normalized k-mer matrix
write.table(kmerCountsMergedNorm, "mergedKmerMatrix.txt", row.names = F, quote = F)
