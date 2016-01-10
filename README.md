# Rlibcmaes

This is a lightweight R wrapper on the libcmaes C++ library (https://github.com/beniz/libcmaes/). Currently it supports box-constrained optimization only.

For expensive objective functions, parallel evaluations is made available by specifying a parallel cluster.

All of the libcmaes CMA algorithms are available for selection, as well as population size control & maximum function evaluations.

# Installation

The libcmaes library requires C++11, therefore currently the package only works under UNIX variants. This will change with 3.3., which is going to use gcc 4.9+. The package has been tested under experimental Windows builds, so it is highly likely that it will be available for Windows platforms in the near future.

To install the package, use the devtools package and then execute: 

```
library(devtools)
install_github("andrewsali/Rlibcmaes",quick=TRUE,dependencies=TRUE)
```

# Testing
A quick-test of the package can be run via:

```R
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
```

# Authors
The R wrapper has been created by Andras Sali. All credit for the underlying library goes to libcmaes developers. 

Development support has been provided by the Alphacruncher Team (http://alphacruncher.com/).
