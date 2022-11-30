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

#kmerFiles = args[1:(length(args)-1)]
#outputFile = args[length(args)]
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
#kmerCounts = mclapply(kmerFiles, read.table, header = F)
kmerCounts = fread(kmerFile, nThread = threadCount, header = T, data.table = F)

# merge key with kmer counts
#print("Merging input files in the order passed to script...")
#kmerCountsMerged = Reduce(function(dtf1, dtf2) merge(dtf1, dtf2, by = "V1", all.x = TRUE), kmerCounts)

# add sample names to header
#print("Adding names to merged matrix...")
#names(kmerCountsMerged) = c("kmer", kmerFiles[-1])
#names(kmerCountsMerged) = gsub("_pe_kmers.txt", "", names(kmerCountsMerged))
#names(kmerCountsMerged) = gsub("_se_kmers.txt", "", names(kmerCountsMerged))

# replace NA's with zeros
#print("Replacing NA's with zeros in merged matrix...")
#kmerCountsMerged[is.na(kmerCountsMerged)] = 0

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
# y = index for pair of individuals to compare
# idxs = list of pairs
# data = dataframe of normalized k-mer counts
brayCurtisDissimilarity=function(y, idxs, data){

  idx = idxs[[y]]
  rm(idxs)

  coly = data[,idx[1]]
  colz = data[,idx[2]]
  rm(data)

  result = 1 - (2*sum(pmin(coly,colz)))/sum(coly+colz)

  if(y %% 1000 == 0){
    print(paste(y, "pairwise dissimilarities calculated", sep = " "))
  }

  return(result)

}

# Get list of column pairs to loop over for calculating dissimilarity
print("Generating list of pairwise comparisons...")

indices = list()
k = 1
for(i in 1:(ncol(kmerCounts) - 1)){
  for(j in (i+1):ncol(kmerCounts)){
    indices[[k]] = colnames(kmerCounts)[c(i, j)]
    k = k + 1
  }
}

print("Some example indices:")
head(indices)

# calculate dissimilarity
print("Calculating dissimilarity for each pairwise comparison...")
dissim = unlist(mclapply(1:length(indices), brayCurtisDissimilarity, idxs = indices, data = kmerCounts, mc.cores = threadCount))

print("Some example dissimilarity values:")
head(dissim)

# Extract the pairs used for calculating dissimilarity
print("Adding names of genotypes compared to each pairwise comparison...")
pairs = unlist(lapply(indices, paste, collapse = "-"))

print("Some example pair ids:")
head(pairs)

# write output of dissimilarity calculations 
print("Writing dissimilarity calculations...")
write.table(data.frame(pairs = pairs, dissim = dissim), bcdOutputFile, row.names = F, quote = F)

# write normalized k-mer matrix
print("Writing normalized k-mer matrix...")
write.table(kmerCounts, normCountsOutputFile, row.names = F, quote = F)
