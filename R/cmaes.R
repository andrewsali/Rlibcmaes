#' Wrapper for the libcmaes library to run state-of-the art local / global optimization using CMA-ES variants.
#' @param x0 Initial guess  for parameters (mean)
#' @param optimFun R function to be minimized
#' @param lowerB Lower bounds for parameters
#' @param upperB Upper bounds for parameters
#' @param sigma Standard deviation of initial guess
#' @param maxEvals Maximum number of function evaluations
#' @param lambda Initial population size. Increase from default values if more 'global' solution is wanted. Note some strategies automatically do this (IPOP)
#' @param cl A cluster that can be used for parallel evaluation (use only if objective function is costly!)
#' @export
cmaes <- function(x0, optimFun, lowerB, upperB, sigma=NULL, lambda=NULL, maxEvals = 1e3L, cl=NULL) {
  stopifnot(all(upperB > lowerB))
  
  # set default value for sigma
  if (is.null(sigma)) {
    sigma <- min(upperB-lowerB) / 2
  }
  
  optimFunBlock <- function(x) {
    if (is.null(cl))
      return(apply(x,2,optimFun))
    else
      return(parallel::parApply(cl,x,2,optimFun))
  }
  Rlibcmaes::cmaesOptim(x0, sigma, optimFun, optimFunBlock,lowerB, upperB, ifelse(is.null(lambda),-1,lambda), maxEvals = 1e3L)
}