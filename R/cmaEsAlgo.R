#' Map algorithms to libcmaes constants
#' @export
cmaEsAlgo <- function() {
  algoList <- list(
    # vanilla version of CMA-ES. 
      CMAES_DEFAULT = 0,
    # IPOP-CMA-ES 
      IPOP_CMAES = 1,
    # BIPOP-CMA-ES 
      BIPOP_CMAES = 2,
    # Active CMA-ES 
      aCMAES = 3,
    # Active IPOP-CMA-ES 
      aIPOP_CMAES = 4,
    # Active BIPOP-CMA-ES 
      aBIPOP_CMAES = 5,
    # sep-CMA-ES 
      sepCMAES = 6,
    # sep-IPOP-CMA-ES 
      sepIPOP_CMAES = 7,
    # sep-BIPOP-CMA-ES 
      sepBIPOP_CMAES = 8,
    # Active sep-CMA-ES 
      sepaCMAES = 9,
    # Active sep-IPOP-CMA-ES 
      sepaIPOP_CMAES = 10,
    # Active sep-BIPOP-CMA-ES 
      sepaBIPOP_CMAES = 11,
    # VD-CMA-ES 
      VD_CMAES = 12,
    # VD-IPOP-CMA-ES 
      VD_IPOP_CMAES = 13,
    # VD-BIPOP-CMA-ES 
      VD_BIPOP_CMAES = 14
  )
  return(algoList)
}