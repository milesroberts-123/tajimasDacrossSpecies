# check if parallel package is installed
if (!require(parallel)) install.packages('parallel')
library(parallel)

# get file names passed to script as arguments
args = commandArgs(trailingOnly=TRUE)

kmerFiles = args[1:(length(args)-1)]
outputFile = args[length(args)]

print("Input files to be merged:")
print(kmerFiles)

print("Output files:")
print(outputFile)

# read key and all kmer count files into memory
print("Reading files into memory...")
kmerCounts = mclapply(kmerFiles, read.table, header = F)

# merge key with kmer counts
print("Merging input files in the order passed to script...")
kmerCountsMerged = Reduce(function(dtf1, dtf2) merge(dtf1, dtf2, by = "V1", all.x = TRUE), kmerCounts)

# add sample names to header
print("Adding names to merged matrix...")
names(kmerCountsMerged) = c("kmer", kmerFiles[-1])
names(kmerCountsMerged) = gsub("_pe_kmers.txt", "", names(kmerCountsMerged))
names(kmerCountsMerged) = gsub("_se_kmers.txt", "", names(kmerCountsMerged))

# replace NA's with zeros
print("Replacing NA's with zeros in merged matrix...")
kmerCountsMerged[is.na(kmerCountsMerged)] = 0

# print out sample of matrix
print("Kmer matrix looks like this:")
kmerCountsMerged[1:min(5, nrow(kmerCountsMerged)),1:min(5, ncol(kmerCountsMerged))]

# normalize kmer counts in each sample to sum to 1
# convert inputs to numeric
print("Normalizing kmer counts to sum to 1 within each sample...")

myNormalize = function(x){
	x = as.numeric(x)
	x/sum(x)
}

kmerCountsMergedNorm = apply(kmerCountsMerged[,-1], myNormalize, MARGIN = 2)

# print out sample of matrix
print("Kmer matrix looks like this after normalization:")
kmerCountsMergedNorm[1:min(5,nrow(kmerCountsMergedNorm)),1:min(5,ncol(kmerCountsMergedNorm))]

# calculate dissimilarity between kmer profiles
# x = indices of two columns/samples to compare
# data = dataframe of normalized k-mer counts
brayCurtisDissimilarity=function(x, data){
  coly = data[,x[1]]
  colz = data[,x[2]]
  1 - (2*sum(pmin(coly,colz)))/sum(coly+colz)
}

# Get list of column pairs to loop over for calculating dissimilarity
print("Generating list of pairwise comparisons...")

indices = list()
k = 1
for(i in 1:(ncol(kmerCountsMergedNorm) - 1)){
  for(j in (i+1):ncol(kmerCountsMergedNorm)){
    indices[[k]] = colnames(kmerCountsMergedNorm)[c(i, j)]
    k = k + 1
  }
}

print("Some example indices:")
head(indices)

# calculate dissimilarity
print("Calculating dissimilarity for each pairwise comparison...")
dissim = unlist(mclapply(indices, brayCurtisDissimilarity, data = kmerCountsMergedNorm))

print("Some example dissimilarity values:")
head(dissim)

# Extract the pairs used for calculating dissimilarity
print("Adding names of genotypes compared to each pairwise comparison...")
pairs = unlist(lapply(indices, paste, collapse = "-"))

print("Some example pair ids:")
head(pairs)

# write output of dissimilarity calculations 
print("Writing dissimilarity calculations...")
write.table(data.frame(pairs = pairs, dissim = dissim), outputFile, row.names = F, quote = F)

# write normalized k-mer matrix
print("Writing normalized k-mer matrix...")
write.table(kmerCountsMergedNorm, "mergedKmerMatrix.txt", row.names = F, quote = F)
