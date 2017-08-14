#' Wrapper for the libcmaes library to run state-of-the art local / global optimization using CMA-ES variants. See \href{https://github.com/beniz/libcmaes/}{libcmaes} and \href{https://www.lri.fr/~hansen/cmaesintro.html}{CMA-ES webpage} for further details.
#' @param x0 Initial guess  for parameters (mean)
#' @param optimFun R function to be minimized
#' @param ineqFun An R function that specifies the inequality constraint
#' @param lower Lower bounds for parameters
#' @param upper Upper bounds for parameters
#' @param params The CMA-ES parameters, can be set with \code{\link{cmaEsParams}}
#' @param cl A cluster that can be used for parallel evaluation (use only if objective function is costly!)
#' @param penaltySchedule A function that takes the iteration number as its parameter and returns a penalty coefficient
#' @useDynLib Rlibcmaes, .registration = TRUE
#' @export
cmaes <- function(x0, optimFun, ineqFun, lower, upper, params=cmaEsParams(), cl=NULL) {
  stopifnot(all(upper > lower))
  
  # set default value for sigma
  if (is.null(params$sigma)) {
    params$sigma <- stats::median(upper-lower) / 4
  } 
  
  # the previous_population
  penalty_level <- 1
  avg_penalty_level <- penalty_level
  n_iter <- 1
  
  optimFunBlock <- function(x) {
    if (n_iter %% 10==0) {
      print(sprintf("Avg-penalty level:%s",avg_penalty_level))
    }
    
    n_iter <<- n_iter+1
    if (is.null(cl)) {
      penalty_vec <- apply(x,2,ineqFun) * avg_penalty_level
      fun_vec <- apply(x,2,optimFun) 
    }  else {
      penalty_vec <- parallel::parApply(cl,x,2,ineqFun) * avg_penalty_level 
      fun_vec <- parallel::parApply(cl,x,2,optimFun)
    }

    if (penalty_vec[which.min(penalty_vec + fun_vec)] > 0) {
      penalty_level <<- penalty_level * 1.01
    } else {
      penalty_level <<- penalty_level * .99
    }
    
    avg_penalty_level <<- n_iter/(n_iter+1) * avg_penalty_level + penalty_level / (n_iter+1)
    
    fun_vec + penalty_vec
  }
  Rlibcmaes::cmaesOptim(x0, params$sigma, optimFun, optimFunBlock,lower, upper, cmaAlgo = as.integer(params$cmaAlgorithm), lambda = ifelse(is.null(params$lambda),-1,params$lambda), maxEvals = params$maxEvals, xtol=params$xtol, ftol=params$ftol, traceFreq =params$trace, seed = params$seed, quietRun=params$quiet)
}