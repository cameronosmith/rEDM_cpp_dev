#include "RcppEDMCommon.h"

//forward decs cus rcpp compiles weird 
DataFrame< double > DFToDataFrame ( Rcpp::DataFrame df );
r::DataFrame DataFrameToDF ( DataFrame< double > dataFrame );

// [[Rcpp::export]]
Rcpp::DataFrame rcpp_testing(Rcpp::DataFrame dataframe) {

	DataFrame< double > df = DFToDataFrame( dataframe );
	return DataFrameToDF( df );
}


