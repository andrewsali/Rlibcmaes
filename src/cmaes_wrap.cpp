#include "cmaes.h"
#include <iostream>
#include <Rcpp.h> 
#include "cmaparameters.h"

using namespace Rcpp; 
using namespace libcmaes; 

ProgressFunc<CMAParameters<GenoPheno<pwqBoundStrategy>>,CMASolutions> progress_fun = [](const CMAParameters<GenoPheno<pwqBoundStrategy>> &cmaparams, const CMASolutions &cmasols)
{
  if ((cmasols.niter()+1) % cmaparams.get_traceFreq() == 0) {
    cmasols.print(std::cerr,0,cmaparams.get_gp()) << std::endl;
  }
  return 0;
};

// [[Rcpp::export]] 
NumericVector cmaesOptim(const NumericVector x0, double sigma, Function optimFun, Function optimFunBlock, NumericVector lowerB, NumericVector upperB, int cmaAlgo, int lambda = -1, int maxEvals=1e3, double xtol=1e-12, double ftol=1e-12, int traceFreq=1, int seed=0, bool quietRun=false) 
{ 
  libcmaes::FitFunc cigtab = [&](const double *x, const int N) 
  { 
    NumericVector inputVal(N);
    for (int i=0;i<N;i++) {
      inputVal[i]=x[i];
    }
    NumericVector retval = optimFun(inputVal);
    return(retval[0]);
  };
  
  libcmaes::BlockFitFunc cigtabBlock = [&](const double *x, const int N, const int M) 
  { 
    NumericMatrix inputVal(N,M);
    for (int i=0;i<N*M;i++) {
      inputVal[i]=x[i];
    }
    NumericVector retval = optimFunBlock(inputVal);
    return(retval);
  };
  
  int dim = x0.size(); 
  std::vector<double> x0_stl= Rcpp::as<std::vector<double> >(x0); 

  GenoPheno<pwqBoundStrategy> gp(lowerB.begin(),upperB.begin(),dim);

  CMAParameters<GenoPheno<pwqBoundStrategy>> cmaparams(dim,&x0_stl.front(),sigma,lambda,seed,gp,cigtabBlock); 

  // set additional parameters
  cmaparams.set_max_fevals(maxEvals);
  cmaparams.set_algo(cmaAlgo);
  cmaparams.set_ftolerance(ftol);
  cmaparams.set_xtolerance(xtol);
  cmaparams.set_traceFreq(traceFreq);
  cmaparams.set_quiet(quietRun);
  
  CMASolutions cmasols = cmaes<GenoPheno<pwqBoundStrategy>>(cigtab,cmaparams,progress_fun);
  
  cmasols.sort_candidates();
  
  NumericVector outputVal(dim);
  
  dVec phenox = gp.pheno(cmasols.best_candidate().get_x_dvec());
  
  for (int j=0;j<dim;j++) {
    outputVal[j]=phenox[j];
  }
  return(outputVal);
}