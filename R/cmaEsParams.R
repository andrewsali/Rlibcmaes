#' Set parameters of CMA-ES optimization
#' @param 
#' @export
cmaEsParams <- function(cmaAlgorithm = cmaEsAlgo()$CMAES_DEFAULT, sigma=NULL, xtol=1e-12, ftol=1e-12, lambda=NULL, maxEvals = 1e6L) {
  params <- list()
  
  params$cmaAlgorithm <- cmaAlgorithm
  params$sigma <- sigma
  params$lambda <- lambda
  params$maxEvals <- maxEvals
  params$xtol <- xtol
  params$ftol <- ftol
  
  return(params)
}