#' Wrapper for the libcmaes library to run state-of-the art local / global optimization using CMA-ES variants. See \href{https://github.com/beniz/libcmaes/}{libcmaes} and \href{https://www.lri.fr/~hansen/cmaesintro.html}{CMA-ES webpage} for further details.
#' @param x0 Initial guess  for parameters (mean)
#' @param optimFun R function to be minimized
#' @param ineqFun An R function that specifies the inequality constraint
#' @param lower Lower bounds for parameters
#' @param upper Upper bounds for parameters
#' @param params The CMA-ES parameters, can be set with \code{\link{cmaEsParams}}
#' @param cl A cluster that can be used for parallel evaluation (use only if objective function is costly!)
#' @param penaltySchedule A function that takes the iteration number as its parameter and returns a penalty coefficient
#' @useDynLib Rlibcmaes
#' @export
cmaes <- function(x0, optimFun, ineqFun, lower, upper, params=cmaEsParams(), cl=NULL,penaltySchedule = function(n_iter) {0}) {
  stopifnot(all(upper > lower))
  
  # set default value for sigma
  if (is.null(params$sigma)) {
    params$sigma <- stats::median(upper-lower) / 4
  } 
  
  # the previous_population
  iteration_num <- 0
  
  optimFunBlock <- function(x) {
    iteration_num <<- iteration_num+1

    if (is.null(cl)) {
      penalty_vec <- apply(x,2,ineqFun)
      fun_vec <- apply(x,2,optimFun) 
    }  else {
      penalty_vec <- parallel::parApply(cl,x,2,ineqFun) 
      fun_vec <- parallel::parApply(cl,x,2,optimFun)
    }
    
    penalty_offset <- (penaltySchedule(iteration_num-1)-penaltySchedule(iteration_num)) * median(penalty_vec) - 1e-16

    fun_vec + penalty_vec * penaltySchedule(iteration_num) + penalty_offset
  }
  Rlibcmaes::cmaesOptim(x0, params$sigma, optimFun, optimFunBlock,lower, upper, cmaAlgo = as.integer(params$cmaAlgorithm), lambda = ifelse(is.null(params$lambda),-1,params$lambda), maxEvals = params$maxEvals, xtol=params$xtol, ftol=params$ftol, traceFreq =params$trace, seed = params$seed, quietRun=params$quiet)
}