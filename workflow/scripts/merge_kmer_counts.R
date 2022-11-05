# get file names passed to script as arguments
args = commandArgs(trailingOnly=TRUE)

# read key and all kmer count files into memory
kmerCounts = lapply(args, read.table, header = F)

# merge key with kmer counts
kmerCountsMerged = Reduce(function(dtf1, dtf2) merge(dtf1, dtf2, by = "V1", all.x = TRUE), kmerCounts)

# normalize kmer counts in each sample to sum to 1
myNormalize = function(x){
	x/sum(x)
}

kmerCountsMergedNorm = apply(kmerCountsMerged[-1,], myNormalize, MARGIN = 2)

# calculate dissimilarity between kmer profiles
brayCurtisDissimilarity=function(x,y){
	1 - (2*sum(pmin(x,y)))/sum(x+y)
}
