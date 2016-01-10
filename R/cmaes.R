#' Wrapper for block evaluation
#' @export
cmaes <- function(x0, sigma, optimFun, lowerB, upperB, maxevals = 1e3L, cl=NULL) {
  stopifnot(all(upperB > lowerB))
  
  optimFunBlock <- function(x) {
    if (is.null(cl))
      return(apply(x,2,optimFun))
    else
      return(parallel::parApply(cl,x,2,optimFun))
  }
  Rlibcmaes::cmaesOptim(x0, sigma, optimFun, optimFunBlock,lowerB, upperB, maxevals = 1e3L)
}