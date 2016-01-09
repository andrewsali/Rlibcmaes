#' Wrapper for block evaluation
#' @export
cmaes <- function(x0, sigma, optimFun, lowerB, upperB, maxevals = 1e3L) {
  optimFunBlock <- function(x) {
    return(as.vector(apply(x,2,optimFun)))
  }
  Rlibcmaes::cmaesOptim(x0, sigma, optimFun, optimFunBlock,lowerB, upperB, maxevals = 1e3L)
}