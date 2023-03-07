rm(list = ls())

# check if parallel package is installed
print("Loading packages...")
if (!require(parallel)) install.packages('data.table')
library(data.table)

# get file names passed to script as arguments
print("Parsing arguments...")
args = commandArgs(trailingOnly=TRUE)

ploidy = as.numeric(args[1]) # ploidy
outputFile = args[2] # name of output file
threadCount = as.numeric(args[3]) # number of cores to use
#indvs = args[grepl("012.indv", args)] # list of individuals in genotype matrices
mats = args[grepl(".table$", args)] # genotype matrices

# print arguments passed to script
print("Ploidy of organism:")
print(ploidy)

print("Output file name:")
print(outputFile)

print("Thread count:")
print(threadCount)

#print("Individual ids:")
#print(indvs)

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
#indvs = lapply(indvs, fread, nThread = threadCount, header = F, data.table = F)

# check that all lists of individuals are identical
#print("binding lists of individuals...")
#indvs = as.data.frame(do.call("cbind", indvs))

# function from https://stackoverflow.com/questions/18813526/check-whether-all-elements-of-a-list-are-in-equal-in-r
#allSame <- function(x){
#	length(unique(x)) == 1
#}

#print("Checking if all lists of individuals are identical...")
#all(apply(indvs, allSame, MARGIN = 1))

# transpose
#print("Transposing matrices...")
#mats = lapply(mats, t)

# remove top row from each matrix
#print("Removing header from each matrix...")
#remtop = function(x){
#  x[-1,]
#}

#mats = lapply(mats, remtop)

# bind all matrices into one matrix
print("Binding matrices together...")
bigmat = as.data.frame(do.call("rbind", mats))
rownames(bigmat) = NULL

print("A subset of the matrix:")
bigmat[1:min(5, nrow(bigmat)), 1:min(5, ncol(bigmat))]

# remove mats object, no longer needed
print("Removing intermediate object...")
rm(mats)

# add sample names
#print("Adding column names...")
#colnames(bigmat) = indvs$V1

#print("A subset of the matrix:")
#bigmat[1:min(5, nrow(bigmat)), 1:min(5, ncol(bigmat))]

# remove indvs, no longer needed
#print("Removing intermediate object...")
#rm(indvs)

# subsample dataframe to speed up calculations
# print("Sampling dataframe...")
# bigmat = bigmat[sample(1:nrow(bigmat), 100000, replace = F),]

# print("A subset of the matrix:")
# bigmat[1:min(5, nrow(bigmat)), 1:min(5, ncol(bigmat))]

# replace -1 with NA
#print("Replacing -1 with NA...")
#bigmat[bigmat == -1] = NA

#print("A subset of the matrix:")
#bigmat[1:min(5, nrow(bigmat)), 1:min(5, ncol(bigmat))]

# calculate genome-wide pi
print("Calculating frequency of reference alleles...")
bigmat$RF = 1 - bigmat$AF

print("Calculating heterozygosity at each site...")
bigmat$HET = (1 - (bigmat$RF^2 + bigmat$AF^2))*(bigmat$AN/(bigmat$AN-1))

print("Summing heterozygosities across sites...")
write.table(sum(bigmat$HET), outputFile, row.names = F, quote = F)

print("DONE :)")

# function to calculate pi
#heterozygosity = function(data, p){
#  
#  # number of sites in calculation (both invariant and variant)
#  S = nrow(data)
#
#  # number of non-missing chromosomes per site = ploidy * number of non-missing genotypes
#  n = p*rowSums(!is.na(data))
#  
#  # alternate allele frequency = number of alternate allele calls/number of non-missing chromosomes
#  alt_frq = rowSums(data, na.rm = T)/n
#
#  # reference allele frequency = 1 - alternative allele frequency
#  ref_frq = 1 - alt_frq
#  
#  # heterozygosity = frequency of heterozygotes * factor to correct for bias in estimator
#  # frequency of heterozygoes = 1 - frequency of homozygotes
#  # frequency of homozygotes = allele frequency^2
#  het = (1 - (alt_frq^2 + ref_frq^2))*(n/(n - 1))
#  
#  # return average heterozygosity per site (i.e. pi)
#  # sum of heterozygosities / number of segregating sites
#  H = sum(het)
#  result = c(c(mean(n), H, S, H/S))
#  names(result) = c("avgN", "H", "S", "heterozygosity")
#  return(result)
#}

# calculate pairwise pi
#print("Calculating average heterozygosity across the genome...")
#write.table(heterozygosity(bigmat, ploidy), outputFile, row.names = F, quote = F)

