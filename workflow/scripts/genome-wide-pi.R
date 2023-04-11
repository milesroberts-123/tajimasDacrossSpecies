rm(list = ls())

# check if parallel package is installed
print("Loading packages...")
if (!require(parallel)) install.packages('data.table')
library(data.table)

# Functions
# harmonic series
harmonicSeries = function(n){
  sum(1/(1:(n-1)))
}

# watterson's THETAW for one site with sample size n
THETAWWForOneS = function(n){
  a = harmonicSeries(n)
  1/a
}

# tajima's D variance, simplified for when S = 1
# will be used to calculate tajima's D for individual sites
tajimasDeltaVarForOneS  = function(n){
  a = harmonicSeries(n)
  ( (n+1)/(3*(n-1)) - (1/a) ) / a
}


# get file names passed to script as arguments
print("Parsing arguments...")
args = commandArgs(trailingOnly=TRUE)

#ploidy = as.numeric(args[1]) # ploidy
outputFile = args[1] # name of output file
threadCount = as.numeric(args[2]) # number of cores to use
#indvs = args[grepl("012.indv", args)] # list of individuals in genotype matrices
mats = args[grepl(".table$", args)] # genotype matrices

# print arguments passed to script
#print("Ploidy of organism:")
#print(ploidy)

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
mats = lapply(mats, fread, nThread = threadCount, header = T, data.table = F, fill = T)
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

# Look at loaded input for sanity check
print("Subset of one matrix:")
head(mats[[1]])

# bind all matrices into one matrix
print("Binding matrices together...")
bigmat = as.data.frame(do.call("rbind", mats))
rownames(bigmat) = NULL

print("A subset of the matrix:")
bigmat[1:min(5, nrow(bigmat)),]

# remove mats object, no longer needed
print("Removing intermediate object...")
rm(mats)

# filter out sites with really high depth
print("Summary of depth across all sites:")
summary(bigmat$DP)

print("Calculate average depth...")
vardp = mean(bigmat$DP[!is.na(bigmat$AC)], na.rm = T)
invardp = mean(bigmat$DP[is.na(bigmat$AC)], na.rm = T)

print("Average depth at variant sites:")
print(vardp)

print("Average depth at invariant sites:")
print(invardp)

print("Number of sites before filtering by depth:")
nrow(bigmat)

bigmat = rbind(
	bigmat[(!is.na(bigmat$AC) & bigmat$DP <= 3*vardp & bigmat$DP >= 5),], # variant sites 
	bigmat[(is.na(bigmat$AC) & bigmat$DP <= 3*invardp & bigmat$DP >= 5),] # invariant sites
)

print("Number of sites after filtering by depth:")
nrow(bigmat)

# replace NA with 0 for invariant sites
print("Replacing NA with 0...")
bigmat$AC[is.na(bigmat$AC)] = 0

print("A subset of the matrix:")
bigmat[1:min(5, nrow(bigmat)),]

print("Replacing NA with placeholder...")
bigmat$AN[is.na(bigmat$AN)] = -1 # this prevents NAs (0/0) from popping up in heterozygosity calculation

print("A subset of the matrix:")
bigmat[1:min(5, nrow(bigmat)),]

# calculate genome-wide pi
print("Calculating frequency of reference alleles...")
bigmat$alt_freq = bigmat$AC/bigmat$AN
bigmat$ref_freq = 1 - bigmat$alt_freq

print("Calculating heterozygosity at each site...")
bigmat$HET = (1 - (bigmat$ref_freq^2 + bigmat$alt_freq^2))*(bigmat$AN/(bigmat$AN-1))

print("A subset of the matrix:")
bigmat[1:min(5, nrow(bigmat)),]

# calculate genome wide watterson's THETAW
print("Calculating Watterson's theta for each site...")

bigmat$THETAW = NA
bigmat$THETAW[bigmat$AC > 0] = unlist(lapply(bigmat$AN[bigmat$AC > 0], FUN = THETAWWForOneS)) # variant sites
bigmat$THETAW[bigmat$AC == 0] = 0 # invariant sites

print("A subset of the matrix:")
bigmat[1:min(5, nrow(bigmat)),]

# calculate standard deviation in Tajima's D at each site
bigmat$TAJIMAVAR = NA
bigmat$TAJIMAVAR[bigmat$AC > 0] = unlist(lapply(bigmat$AN[bigmat$AC > 0], FUN = tajimasDeltaVarForOneS))

print("A subset of the matrix:")
bigmat[1:min(5, nrow(bigmat)),]

# calculate tajima's D for each site
print("Calculating Tajima's D for each site...")
bigmat$TAJIMASD = (bigmat$HET - bigmat$THETAW)/sqrt(bigmat$TAJIMAVAR)

print("A subset of the matrix:")
bigmat[1:min(5, nrow(bigmat)),]

# compile results into a table
print("Summing variation across sites...")
result = data.frame(h = sum(bigmat$HET), w = sum(bigmat$THETAW), ntotal = nrow(bigmat), nvariant = nrow(bigmat[(bigmat$AC > 0),]), ninvariant = nrow(bigmat[(bigmat$AC == 0),]), pi = mean(bigmat$HET, na.rm = T), thetaw = mean(bigmat$THETAW, na.rm = T), d = mean(bigmat$TAJIMASD, na.rm = T))

print("Writing results to table...")
write.table(result, outputFile, row.names = F, quote = F)

print("DONE :)")
