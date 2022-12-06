rm(list = ls())
kmerCountsMergedNorm = as.data.frame(replicate(n = 3, runif(100)))

# add column names
names(kmerCountsMergedNorm) = paste("v", 1:ncol(kmerCountsMergedNorm), sep = "")

# calculate dissimilarity between kmer profiles
# x = indices of two columns/samples to compare
# data = dataframe of normalized k-mer counts
brayCurtisDissimilarity=function(x, data){
  coly = data[,x[1]]
  colz = data[,x[2]]
  1 - (2*sum(pmin(coly,colz)))/sum(coly+colz)
}

# Get list of column pairs to loop over for calculating dissimilarity
# indices = list()
# k = 1
# for(i in 1:(ncol(kmerCountsMergedNorm) - 1)){
#   for(j in (i+1):ncol(kmerCountsMergedNorm)){
#     indices[[k]] = c(i,j)
#     k = k + 1
#   }
# }

indices = list()
k = 1
for(i in 1:(ncol(kmerCountsMergedNorm) - 1)){
  for(j in (i+1):ncol(kmerCountsMergedNorm)){
    indices[[k]] = c(names(kmerCountsMergedNorm)[i],names(kmerCountsMergedNorm)[j])
    k = k + 1
  }
}


# calculate dissimilarity
system.time(
  unlist(lapply(indices, brayCurtisDissimilarity, data = kmerCountsMergedNorm))
)


unlist(lapply(indices, paste, collapse = "-"))
