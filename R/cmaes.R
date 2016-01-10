#' Wrapper for the libcmaes library to run state-of-the art local / global optimization using CMA-ES variants. See \href{https://github.com/beniz/libcmaes/}{libcmaes} and \href{https://www.lri.fr/~hansen/cmaesintro.html}{CMA-ES webpage} for further details.
#' @param x0 Initial guess  for parameters (mean)
#' @param optimFun R function to be minimized
#' @param lowerB Lower bounds for parameters
#' @param upperB Upper bounds for parameters
#' @param cmaAlgorithm Specifies the type of CMA search. See the source of \code{\link{cmaEsAlgo}} for possible options.
#' @param sigma Standard deviation of initial guess. If not provided, default values is guessed from bounds.
#' @param lambda Initial population size. Increase from default values if more 'global' solution is wanted. Note some strategies automatically do this (IPOP)
#' @param maxEvals Maximum number of function evaluations
#' @param cl A cluster that can be used for parallel evaluation (use only if objective function is costly!)
#' @export
cmaes <- function(x0, optimFun, lowerB, upperB, params=cmaEsParams(), cl=NULL) {
  stopifnot(all(upperB > lowerB))
  
  # set default value for sigma
  if (is.null(params$sigma)) {
    sigma <- median(upperB-lowerB) / 4
  }
  
  optimFunBlock <- function(x) {
    if (is.null(cl))
      return(apply(x,2,optimFun))
    else
      return(parallel::parApply(cl,x,2,optimFun))
  }
  Rlibcmaes::cmaesOptim(x0, sigma, optimFun, optimFunBlock,lowerB, upperB, cmaAlgo = as.integer(params$cmaAlgorithm), lambda = ifelse(is.null(params$lambda),-1,params$lambda), maxEvals = params$maxEvals, xtol=params$xtol, ftol=params$ftol)
}