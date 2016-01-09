# A simple test of the cmaesOptim function
f <- function(x) {
  return(crossprod(x-c(.3,.5))[1])
}

test.optim <- cmaes(c(.4,.6),.1,f,c(0.35,0),c(1,1))
