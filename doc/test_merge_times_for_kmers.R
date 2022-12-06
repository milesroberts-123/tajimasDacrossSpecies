rm(list = ls())

# Create list of parameter values to loop throug
W = c(1e7) # number of k-mers in merge
N = c(2, 3, 4, 5, 6, 7, 8, 9, 10) # number of datasets merged

params = expand.grid(W = W, N = N)

# time output
t = c()

# loop over parameters and save merge times
for(j in 1:nrow(params)){
  
  # number of k-mers to merge
  w = params[j,1]

  # numeber of datasets
  n = params[j,2]

  # generate random datasets
  d = list()
  for(i in 1:n){
    d[[i]] = data.frame(key = 1:w, xvalue = runif(w))
  }

  # save time to list
  t = c(t, 
    system.time(
      Reduce(function(dtf1, dtf2) merge(dtf1, dtf2, by = "key", all.x = TRUE), d)
    )[3]
  )

}

# add times to dataframe
params$times = t

# plot results
plot(params$W, params$times)

plot(params$N, params$times)

# predict how long it would take to merge N datasets of W kmers
mod = coefficients(lm(times ~ N, data = params))

sum(mod*c(1, 1000))/(60*60) # time in hours
sum(mod*c(1, 3000))/(60*60) # time in hours

