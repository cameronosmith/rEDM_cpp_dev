
#include "RcppEDMCommon.h"

//-----------------------------------------------------------
// 
//-----------------------------------------------------------
r::DataFrame CCM_rcpp( std::string pathIn, 
						 std::string dataFile,
						r::DataFrame dataList,
						 std::string pathOut,
						 std::string predictFile,
						 int         E,
						 int         Tp,
						 int         knn,
						 int         tau, 
						 std::string columns,
						 std::string target,
						 std::string libSizes,
						 int         sample,
						 bool        random,
						 unsigned    seed, 
						 bool        verbose ) {
    
    DataFrame< double > ccmOutput;

    if ( dataFile.size() ) {
        // dataFile specified, dispatch overloaded CCM, ignore dataList
        
        ccmOutput = CCM( pathIn,
                         dataFile,
                         pathOut,
                         predictFile,
                         E, 
                         Tp,
                         knn,
                         tau,
                         columns,
                         target, 
                         libSizes,
                         sample,
                         random,
                         seed,
                         verbose );
    }
    else if ( dataList.size() ) {
        DataFrame< double > dataFrame = DFToDataFrame( dataList );
        
        ccmOutput = CCM( dataFrame,
                         pathOut,
                         predictFile,
                         E, 
                         Tp,
                         knn,
                         tau,
                         columns,
                         target, 
                         libSizes,
                         sample,
                         random,
                         seed,
                         verbose );
    }
    else {
        throw std::runtime_error( "CCM_rcpp(): Invalid input.\n" );
    }

    return DataFrameToDF( ccmOutput );
}
