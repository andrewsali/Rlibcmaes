# A simple test of the cmaesOptim function
f <- function(x) {
  Sys.sleep(.01)
  return(crossprod(x-c(.3,.5))[1])
}

single.time <- system.time(test.optim <- cmaes(x0=c(.4,.6),optimFun=f,lowerB=c(0.35,0),upperB=c(1,1)))
print(single.time)

# now do parallel run

cl <- parallel::makeCluster(4)

parallel.time <- system.time(test.optim.parallel <- cmaes(x0=c(.4,.6),optimFun=f,lowerB=c(0.35,0),upperB=c(1,1),cl=cl))

print(parallel.time)

parallel::stopCluster(cl)

single.time <- system.time(test.optim <- cmaes(x0=c(.4,.6),optimFun=f,lowerB=c(0.35,0),upperB=c(1,1),cmaAlgorithm = cmaEsAlgo()$IPOP_CMAES,maxEval=1e4))
print(single.time)