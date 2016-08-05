## Test environments
* local Ubuntu (16.04) install, R 3.2.3

## R CMD check results
There were no ERRORs or WARNINGs. 

There was 3 NOTES:

* checking CRAN incoming feasibility ... NOTE
	Maintainer: ‘Andras Sali <andras.sali@alphacruncher.com>’
	New submission

* checking installed package size ... NOTE
  	installed size is 93.6Mb
  	sub-directories of 1Mb or more:
    	libs  93.4Mb

* checking compiled code ... NOTE
	File ‘Rlibcmaes/libs/Rlibcmaes.so’:
  	Found ‘rand’, possibly from ‘rand’ (C)
    	Object: ‘cmasolutions.o’

	Compiled code should not call entry points which might terminate R nor
	write to stdout/stderr instead of to the console, nor the system RNG.

This is due to the libcmaes using the Random() method from the Eigen library (referenced from RcppEigen)

