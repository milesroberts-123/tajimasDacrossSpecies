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
dissimOutput = args[2]
normCountsOutputFile = args[3]
threadCount = as.numeric(args[4])
countThresh = as.numeric(args[5])

print("Input file:")
print(kmerFile)

print("Output files:")
print(dissimOutput)
print(normCountsOutputFile)

print("Thread count:")
print(threadCount)

print("K-mer count threshold:")
print(countThresh)

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

# convert matrix to numeric to prevent integer overflow
#print("Converting values to numeric...")
#kmerCounts = as.data.frame(sapply(kmerCounts, function(x) as.numeric(x)))

#print("Kmer matrix looks like this:")
#kmerCounts[1:min(5, nrow(kmerCounts)),1:min(5, ncol(kmerCounts))]

# mark k-mers as present or absent based on their count for each genotype
print("Replace k-mers as present or absent based on count threshold...")
markPresAbs = function(x, data, countThresh){
	y = data[,x]
	y[y < countThresh] = 0
  y[y >= countThresh] = 1
	return(y)
}

kmerCounts = lapply(1:ncol(kmerCounts), FUN = markPresAbs, data = kmerCounts, countThresh = countThresh)

# cbind normalized counts into one frame
print("Column-binding presence/absence values...")
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
jaccardDissimilarity=function(y, idxs, data, outputFileName){

  idx = idxs[[y]]
  rm(idxs)

  kmerCols = data[,idx]
  rm(data)

  # determine, for each k-mer whether its 
  # outside union (0)
  # inside union (1 or 2)
  # inside intersection (2)
  kmerCols = rowSums(kmerCols)

  # remove k-mers outside union
  kmerCols = kmerCols[(kmerCols != 0)]

  # remaining k-mers are in union
  kmerUnion = length(kmerCols)

  # k-mers marked by 2 are in intersection
  kmerInter = length(kmerCols[(kmerCols == 2)])
  rm(kmerCols)
  
  # dissimilarity = 1 - similarity
  result = 1 - (kmerInter/kmerUnion)

  # write output to separate files, one file per core
  #subFile = y %% coreCount

  line = paste(paste(idx, collapse = "-"), result, kmerInter, kmerUnion, sep = " ")
  #write(line, file = paste(subFile, "_", outputFileName, sep = ""), append = TRUE)
  write(line, file = outputFileName, append = TRUE)

  #if(y %% 1000 == 0){
  #  print(paste(y, "pairwise dissimilarities calculated", sep = " "))
  #}

  return(NULL)

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

print("Number of pairwise comparisons:")
length(indices)

# calculate dissimilarity
print("Calculating dissimilarity for each pairwise comparison...")
#mclapply(1:length(indices), jaccardDissimilarity, idxs = indices, data = kmerCounts, outputFileName = dissimOutput, coreCount = threadCount, mc.cores = threadCount, mc.silent = TRUE)
lapply(1:length(indices), jaccardDissimilarity, idxs = indices, data = kmerCounts, outputFileName = dissimOutput)

# write normalized k-mer matrix
print("Writing normalized k-mer matrix...")
write.table(kmerCounts, normCountsOutputFile, row.names = F, quote = F)
