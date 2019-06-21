
#include "RcppEDMCommon.h"

//--------------------------------------------------------------
// 
//--------------------------------------------------------------
r::List Multiview_rcpp (
    std::string  pathIn,
    std::string  dataFile,
    r::DataFrame dataList,
    std::string  pathOut,
    std::string  predictFile,
    std::string  lib,
    std::string  pred,
    int          E,
    int          Tp,
    int          knn,
    int          tau, 
    std::string  columns,
    std::string  target,
    int          multiview,
    bool         verbose,
    unsigned int numThreads ) {

    MultiviewValues MV;

    if ( dataFile.size() ) {
        // dataFile specified, dispatch overloaded Multiview, ignore dataList
        
        MV = Multiview( pathIn,
                        dataFile,
                        pathOut,
                        predictFile,
                        lib,
                        pred, 
                        E,
                        Tp,
                        knn,
                        tau,
                        columns,
                        target,
                        multiview,
                        verbose,
                        numThreads );
    }
    else if ( dataList.size() ) {
        DataFrame< double > dataFrame = DFToDataFrame( dataList );
        
        MV = Multiview( dataFrame,
                        pathOut,
                        predictFile,
                        lib,
                        pred, 
                        E,
                        Tp,
                        knn,
                        tau,
                        columns,
                        target,
                        multiview,
                        verbose,
                        numThreads );
    }
    else {
        throw std::runtime_error( "Multiview_rcpp(): Invalid input.\n" );
    }

    r::DataFrame df_combo_rho   = DataFrameToDF( MV.Combo_rho   );
    r::DataFrame df_predictions = DataFrameToDF( MV.Predictions );

	r::List output = r::List::create(r::Named("Combo_rho") = df_combo_rho,
									 r::Named("Predictions")=df_predictions );

    return output;
}
