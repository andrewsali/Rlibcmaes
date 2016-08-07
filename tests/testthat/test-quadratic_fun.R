# A simple test of the cmaesOptim function
require(Rcpp)

x_true <- c(.3,.5)
lB <- c(0.35,0)
uB <- c(1,1)

f <- function(x) {
  Sys.sleep(.1)
  return(crossprod(x-x_true)[1])
}

test.optim <- cmaes(x0=c(.4,.6),optimFun=f,lower=lB,upper=uB,params=cmaEsParams(xtol=1e-3,ftol=1e-3))

assertthat::assert_that(max(abs(test.optim - pmin(uB,pmax(x_true,lB)))) < 1e-3)
