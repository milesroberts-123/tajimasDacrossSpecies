rm(list = ls())

# check if parallel package is installed
print("Loading packages...")
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

# remove kmer column to save on memory
print("Removing k-mer column to save on memory...")
kmerCounts = kmerCounts[,-1]

print("Kmer matrix looks like this:")
kmerCounts[1:min(5, nrow(kmerCounts)),1:min(5, ncol(kmerCounts))]

# mark k-mers as present or absent based on their count for each genotype
print("Replace numbers < count threshold with 0...")
kmerCounts[(kmerCounts < countThresh)] = 0

print("Replace numbers >= count threshold with 1...")
kmerCounts[(kmerCounts >= countThresh)] = 1

print("Kmer matrix looks like this:")
kmerCounts[1:min(5, nrow(kmerCounts)),1:min(5, ncol(kmerCounts))]

# calculate dissimilarity between kmer profiles
# data = dataframe of normalized k-mer counts
jaccardDissimilarity=function(data){
  # determine, for each k-mer whether its 
  # outside union (0)
  # inside union (1 <= x < number of individuals)
  # inside intersection (x == number of individuals)
  kmerCounts = rowSums(data)

  nindv = ncol(data)

  # remove k-mers outside union
  kmerCounts = kmerCounts[(kmerCounts != 0)]

  # remaining k-mers are in union
  kmerUnion = length(kmerCounts)

  # k-mers with freq == number of individuals are in intersection
  kmerInter = length(kmerCounts[(kmerCounts == nindv)])

  # dissimilarity = 1 - similarity
  dissim = 1 - (kmerInter/kmerUnion)

  # return result
  result = c(kmerInter, kmerUnion, dissim)
  names(result) = c("intersection", "union", "dissimilarity")
  return(result)
}

# calculate dissimilarity
print("Calculating dissimilarity...")
write.table(jaccardDissimilarity(kmerCounts), dissimOutput, row.names = F, quote = F)

# output k-mer presence absence table
print("Writing table of k-mer presence/absence values...")
write.table(kmerCounts, normCountsOutputFile, row.names = F, quote = F)
