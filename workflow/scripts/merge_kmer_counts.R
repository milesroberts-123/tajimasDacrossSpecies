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

# normalize kmer counts in each sample to sum to 1
myNormalize = function(x){
	x/sum(x)
}

kmerCountsMergedNorm = apply(kmerCountsMerged[-1,], myNormalize, MARGIN = 2)

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
    indices[[k]] = c(i,j)
    k = k + 1
  }
}

# calculate dissimilarity
dissim = unlist(mclapply(indices, brayCurtisDissimilarity, data = kmerCountsMergedNorm))

write.table(mean(dissim), outputFile, row.names = F, col.names = F)
