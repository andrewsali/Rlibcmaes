#' Wrapper for the libcmaes library to run state-of-the art local / global optimization using CMA-ES variants. See \href{https://github.com/beniz/libcmaes/}{libcmaes} and \href{https://www.lri.fr/~hansen/cmaesintro.html}{CMA-ES webpage} for further details.
#' @param x0 Initial guess  for parameters (mean)
#' @param optimFun R function to be minimized
#' @param ineqFun A list of R functions that specifies the inequality constraint
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
  penalty_level <- rep(1,length(ineqFun))

  if (is.null(cl)) {
    apply_rows <- function(x,f) apply(x,2,f)
  } else {
    apply_rows <- function(x,f) parallel::parApply(cl,x,2,f)
  }
  
  n_iter <- 0
  
  optimFunBlock <- function(x) {
    n_iter <<- n_iter + 1
    
    fun_vec <- apply_rows(x,optimFun) 
    
    penalty_mat <- matrix(0,length(ineqFun),nrow(x))
    
    for (i in 1:length(ineqFun)) {
      penalty_mat[i,] <- apply_rows(x,ineqFun[[i]]) * penalty_level[i]
    }
    
    if (n_iter %% 10==0) {
      print(sprintf("Penalty level:%s",paste(penalty_level,collapse=",")))
    }
    
    optimal_element <- which.min(colSums(outer(rep(1,length(ineqFun)),fun_vec)+penalty_mat))
    
    for (i in 1:length(ineqFun)) {
      if (penalty_mat[i,optimal_element]>0) {
        penalty_level[i] <<- penalty_level[i] * 1.01
      } else {
        penalty_level[i] <<- penalty_level[i] / 1.01
      }
    }
  
    fun_vec + colSums(penalty_mat)
  }
  Rlibcmaes::cmaesOptim(x0, params$sigma, optimFun, optimFunBlock,lower, upper, cmaAlgo = as.integer(params$cmaAlgorithm), lambda = ifelse(is.null(params$lambda),-1,params$lambda), maxEvals = params$maxEvals, xtol=params$xtol, ftol=params$ftol, traceFreq =params$trace, seed = params$seed, quietRun=params$quiet)
}