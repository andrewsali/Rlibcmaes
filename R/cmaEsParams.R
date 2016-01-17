#' Set parameters of CMA-ES optimization
#' @param cmaAlgorithm Specifies the type of CMA search. See the source of \code{\link{cmaEsAlgo}} for possible options.
#' @param sigma Standard deviation of initial guess. If not provided, default values is guessed from bounds.
#' @param xtol Stopping tolerance based on change in parameter values
#' @param ftol Stopping tolerance based on function value
#' @param lambda Initial population size. Increase from default values if more 'global' solution is wanted. Note some strategies automatically do this (IPOP)
#' @param maxEvals Maximum number of function evaluations
#' @param trace Every trace iteration will be printed
#' @param quiet Should diagnostic messages be printed?
#' @param seed The seed of the random number generation for reproducibility. If set to 0, then a random seed is chosen (based on current time).
#' @export
cmaEsParams <- function(cmaAlgorithm = cmaEsAlgo()$CMAES_DEFAULT, sigma=NULL, xtol=1e-12, ftol=1e-12, lambda=NULL, maxEvals = 1e4L, trace=100, quiet=FALSE,seed = 0) {
  params <- list()
  
  params$cmaAlgorithm <- cmaAlgorithm
  params$sigma <- sigma
  params$lambda <- lambda
  params$maxEvals <- maxEvals
  params$xtol <- xtol
  params$ftol <- ftol
  params$trace <- trace
  params$quiet <- quiet
  params$seed <- seed
  return(params)
}