# A simple test of the cmaesOptim function
f <- function(x) {
  Sys.sleep(.1)
  return(crossprod(x-c(.3,.5))[1])
}

single.time <- system.time(test.optim <- cmaes(x0=c(.4,.6),optimFun=f,lowerB=c(0.35,0),upperB=c(1,1),params=cmaEsParams(xtol=1e-3,ftol=1e-3)))
print(single.time)

# now do parallel run

cl <- parallel::makeCluster(4)

parallel.time <- system.time(test.optim.parallel <- cmaes(x0=c(.4,.6),optimFun=f,lowerB=c(0.35,0),upperB=c(1,1),params=cmaEsParams(xtol=1e-3,ftol=1e-3),cl=cl))

print(parallel.time)

ipop.time <- system.time(test.optim <- cmaes(x0=c(.4,.6),optimFun=f,lowerB=c(0.35,0),upperB=c(1,1),params=cmaEsParams(cmaAlgorithm = cmaEsAlgo()$IPOP_CMAES,maxEval=1e3),cl=cl))
print(ipop.time)

parallel::stopCluster(cl)
