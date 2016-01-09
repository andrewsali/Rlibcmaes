#include "cmaes.h"
#include <iostream>
#include <Rcpp.h> 
#include "cmaparameters.h"

using namespace Rcpp; 
using namespace libcmaes; 

ProgressFunc<CMAParameters<GenoPheno<pwqBoundStrategy>>,CMASolutions> progress_fun = [](const CMAParameters<GenoPheno<pwqBoundStrategy>> &cmaparams, const CMASolutions &cmasols)
{
  std::cerr << cmasols << std::endl;
  return 0;
};

// [[Rcpp::export]] 
NumericVector cmaesOptim(const NumericVector x0, const NumericVector sigma, Function optimFun, Function optimFunBlock, NumericVector lowerB, NumericVector upperB,int maxevals=1e3) 
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
  std::vector<double> sigma_stl = Rcpp::as<std::vector<double> >(sigma); 

  GenoPheno<pwqBoundStrategy> gp(lowerB.begin(),upperB.begin(),dim);

  CMAParameters<GenoPheno<pwqBoundStrategy>> cmaparams(dim,&x0_stl.front(),sigma_stl[0],-1,0,gp,cigtabBlock); 

  cmaparams.set_max_fevals(maxevals);
  //cmaparams.set_noisy();
  //cmaparams.set_uh(true);
  
  // let's limit memory usage
  //cmaparams.set_max_hist(10);
  
  //cmaparams.set_algo(VD_CMAES);
  CMASolutions cmasols = cmaes<GenoPheno<pwqBoundStrategy>>(cigtab,cmaparams,progress_fun);
  //std::cout << cmasols;
  
  cmasols.sort_candidates();
  
  //cmasols.print(std::cout,0,gp);
  NumericVector outputVal(dim);
  
  dVec phenox = gp.pheno(cmasols.best_candidate().get_x_dvec());
  //dVec phenox = gp.pheno(cmasols.xmean());
  
  for (int j=0;j<dim;j++) {
    outputVal[j]=phenox[j];
  }
  return(outputVal);
}; 