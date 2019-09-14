#include "RcppEDMCommon.h"
//-----------------------------------------------------------------------
// Convert R DataFrame to cppEDM DataFrame<double>
//-----------------------------------------------------------------------
DataFrame< double > DFToDataFrame ( Rcpp::DataFrame df ) {

    // Get number of valarray rows from first pair

    size_t numRows = df.nrow();

	// ensure that we have > 1 columns for reading since starting after time col

    if ( df.ncol() == 1 ) {
        std::string err  ="Input data must have > 1 column, as first column \n"
                            "is interpreted as a time column.\n";
        throw std::runtime_error( err );
    }

    // Get column names
    
    std::vector< std::string > colNames;
	r::CharacterVector tmp_colNames = df.names();

	for ( size_t idx = 1; idx < tmp_colNames.size(); idx++ ) {
		colNames.push_back( r::as<std::string>( tmp_colNames[idx] ) );
	}

    // Create cpp DataFrame
    DataFrame< double > dataFrame ( numRows, df.ncol()-1, colNames ); 

    //have to setup time column and time name for dataframe 
    
    r::CharacterVector tmp  = r::as<r::CharacterVector>( df[0] );
    dataFrame.Time()        = r::as< std::vector<std::string> >( tmp );
    dataFrame.TimeName()    = r::as<std::string>( 
                                ((r::CharacterVector)df.names())[0] );  

    //read in the data columns to the cppEDM DF
    
	for ( size_t idx = 1; idx < df.ncol(); idx++ ) {
		//unfortunately we can't convert numeric vec to valarray
		std::vector<double> tmp = r::as<std::vector<double>>(df[idx]);
		std::valarray<double> col ( tmp.data(), tmp.size() );
        dataFrame.WriteColumn( idx-1, col ); 
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
		std::vector<double> col_vec( std::begin(col_val), std::end(col_val) );
		cols.push_back( col_vec );
	}



    // prepend time/name to col names and cols if need to and set names attr
    // w special case for smap coefficients with time col and `Time` attr
    
    std::vector<std::string> tmpColNames = dataFrame.ColumnNames();

    if ( dataFrame.Time().size() and dataFrame.ColumnNames()[1]!="C0" ) {
        cols.insert( cols.begin(), dataFrame.Time() );
        tmpColNames.insert( tmpColNames.begin(), dataFrame.TimeName() );
    }

	r::DataFrame df ( cols );
	df.attr("names") = tmpColNames;

    return df;
}

//---------------------------------------------------------------
// Load path/file into cppEDM DataFrame, convert to Python
// dict{ column : array }
//---------------------------------------------------------------
r::DataFrame ReadDataFrame ( std::string path, std::string file ) {
    return DataFrameToDF( DataFrame< double >( path, file ) );
}
