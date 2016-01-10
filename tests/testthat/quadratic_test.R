# A simple test of the cmaesOptim function
f <- function(x) {
  Sys.sleep(.01)
  return(crossprod(x-c(.3,.5))[1])
}

single.time <- system.time(test.optim <- cmaes(c(.4,.6),.1,f,c(0.35,0),c(1,1)))
print(single.time)

# now do parallel run

cl <- parallel::makeCluster(4)

parallel.time <- system.time(test.optim.parallel <- cmaes(c(.4,.6),.1,f,c(0.35,0),c(1,1),cl=cl))

print(parallel.time)

parallel::stopCluster(cl)

