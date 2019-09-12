#include "RcppEDMCommon.h"
//-----------------------------------------------------------------------
// Convert R DataFrame to cppEDM DataFrame<double>
//-----------------------------------------------------------------------
DataFrame< double > DFToDataFrame ( Rcpp::DataFrame df ) {

    // Get number of valarray rows from first pair
    size_t numRows = 0;
    if ( df.ncol() ) {
        numRows = df.nrow();
    }
	
    // Get column names
    std::vector< std::string > colNames;
	r::CharacterVector tmp_colNames = df.names();
	for ( size_t idx = 0; idx < tmp_colNames.size(); idx++ ) {
		colNames.push_back( r::as<std::string>( tmp_colNames[idx] ) );
	}

    // Create cpp DataFrame
    DataFrame< double > dataFrame ( numRows, colNames.size(), colNames ); 

    //have to setup time column and time name for dataframe 
    
    r::CharacterVector tmp = r::as<r::CharacterVector>( df[0] );
    dataFrame.Time()     = r::as< std::vector<std::string> >( tmp );
    dataFrame.TimeName() = r::as<std::string>( 
                        ((r::CharacterVector)df.names())[0] ); 


	for ( size_t idx = 0; idx < df.ncol(); idx++ ) {
		//unfortunately we can't convert numeric vec to valarray
		std::vector<double> tmp = r::as<std::vector<double>>(df[idx]);
		std::valarray<double> col ( tmp.data(), tmp.size() );
        dataFrame.WriteColumn( idx, col ); 
    }

    return dataFrame;
}

//---------------------------------------------------------------
// Convert cppEDM DataFrame<double> to R DataFrame
//---------------------------------------------------------------
r::DataFrame DataFrameToDF ( DataFrame< double > dataFrame ) {

	//get list of columns to give to r dataframe
	r::List cols;
	for ( size_t idx = 0; idx < dataFrame.NColumns(); idx++ ) {
		//unfortunately we have to copy to vector first
		std::valarray<double> col_val = dataFrame.Column( idx );
		std::vector<double> col_vec( std::begin(col_val), std::end(col_val));
		cols.push_back( col_vec );
	}
	r::DataFrame df ( cols );
	df.attr("names") = dataFrame.ColumnNames();

    return df;
}

//---------------------------------------------------------------
// Load path/file into cppEDM DataFrame, convert to Python
// dict{ column : array }
//---------------------------------------------------------------
r::DataFrame ReadDataFrame ( std::string path, std::string file ) {
    return DataFrameToDF( DataFrame< double >( path, file ) );
}
