library(Rlibcmaes)
# A simple test of the cmaesOptim function
x_true <- c(.3,.5)
lB <- c(0.35,0)
uB <- c(1,1)

f <- function(x) {
  Sys.sleep(.1)
  return(crossprod(x-x_true)[1])
}

single.time <- system.time(test.optim <- cmaes(x0=c(.4,.6),optimFun=f,lower=lB,upper=uB,params=cmaEsParams(xtol=1e-3,ftol=1e-3)))
print(single.time)

# now do parallel run

cl <- parallel::makeCluster(4)
parallel::clusterExport(cl,c("x_true","lB","uB"))

parallel.time <- system.time(test.optim.parallel <- cmaes(x0=c(.4,.6),optimFun=f,lower=lB,upper=uB,params=cmaEsParams(xtol=1e-3,ftol=1e-3),cl=cl))

print(parallel.time)

ipop.time <- system.time(test.optim <- cmaes(x0=c(.4,.6),optimFun=f,lower=lB,upper=uB,params=cmaEsParams(cmaAlgorithm = cmaEsAlgo()$IPOP_CMAES,maxEvals=1e3),cl=cl))
print(ipop.time)

parallel::stopCluster(cl)

assertthat::assert_that(max(abs(test.optim - pmin(uB,pmax(x_true,lB)))) < 1e-3)
