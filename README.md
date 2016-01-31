# Rlibcmaes

This is a lightweight R wrapper on the libcmaes C++ library (https://github.com/beniz/libcmaes/). Currently it supports box-constrained optimization only. The aim  is to have a simple & familiar R optimization interface that suffices for most applications, with the ability to tune the parameters of the algorithm if necessary.

For expensive objective functions, parallel evaluations is made available by specifying a parallel cluster. Due to the R interpreter being non thread-safe, parallelization is not based on the openMPI calls of libcmaes, but is handled directly through the R parallel package. It should be considered for expensive objective functions only or large population sizes.

All of the libcmaes implemented algorithms are available for selection, as well as population size control & termination based on maximum function evaluations / x-convergence / function-convergence.

Available algorithms are listed in: https://github.com/andrewsali/Rlibcmaes/blob/master/R/cmaEsAlgo.R

Default parameter values are given in: https://github.com/andrewsali/Rlibcmaes/blob/master/R/cmaEsParams.R

# Installation

The libcmaes library requires C++11, therefore currently the package only works under UNIX variants. This will change with R 3.3., which is going to use gcc 4.9+. The package has been tested under experimental Windows builds, so it is highly likely that it will be available for Windows platforms in the near future.

As a first step make sure RcppEigen package is installed. Then to install the package, clone the git repository to a folder and then execute R CMD INSTALL (for example): 

```
git clone --recursive https://github.com/andrewsali/Rlibcmaes.git /tmp/Rlibcmaes
cd /tmp
R CMD INSTALL --preclean Rlibcmaes
```
Unfortunately install_github from the devtools package does not support submodules at this point (recursive cloning), therefore one needs to manually clone the repository and install.

# Example / Testing
A quick-test of the package can be run by executing the contents of https://github.com/andrewsali/Rlibcmaes/blob/master/tests/testthat/quadratic_test.R

# Modifications to libcmaes
For the set of modifications applied to libcmaes src, see: https://github.com/andrewsali/Rlibcmaes/blob/master/Rlibcmaes.patch

# Authors
The R wrapper has been created by Andras Sali. All credit for the underlying library goes to libcmaes developers. 

Development support has been provided by the Alphacruncher Team (http://alphacruncher.com/).
