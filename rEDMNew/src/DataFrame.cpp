#include "RcppEDMCommon.h"

//-----------------------------------------------------------------------
// Convert R DataFrame to cppEDM DataFrame<double>
//-----------------------------------------------------------------------
DataFrame< double > DFToDataFrame ( Rcpp::DataFrame df ) {

    // Get number of valarray rows from first pair
    size_t numRows = df.nrow();

    // ensure that we have > 1 column for reading
    if ( df.ncol() == 1 ) {
        std::string err = "DFToDataFrame(): Input must have > 1 column, "
                          "first column is interpreted as a time vector.\n";
        throw Rcpp::exception( err.c_str() );
    }

    // Get column names
    // JP: Are df.names() ensured to be in order as accessed by index?
    //     If not, this will give incorrect results.
    std::vector< std::string > colNames;
    r::CharacterVector tmp_colNames = df.names();

    for ( size_t idx = 1; idx < tmp_colNames.size(); idx++ ) {
        colNames.push_back( r::as<std::string>( tmp_colNames[idx] ) );
    }

    // Create cpp DataFrame
    DataFrame< double > dataFrame ( numRows, df.ncol()-1, colNames ); 
    
    // Setup time column and time name for dataframe
    // It is assumed that the first column is a time vector !!!
    r::CharacterVector tmp = r::as<r::CharacterVector>( df[0] );
    dataFrame.Time()       = r::as< std::vector<std::string> >( tmp );
    dataFrame.TimeName()   = r::as<std::string>( 
                             ((r::CharacterVector)df.names())[0] );  

    // read in data columns to the cppEDM DF
    // JP: Are df.names() ensured to be in order as accessed by index?
    //     If not, this will give incorrect results.
    for ( size_t idx = 1; idx < df.ncol(); idx++ ) {
        // unfortunately we can't convert numeric vec to valarray
        std::vector<double> tmp = r::as<std::vector<double>>( df[idx] );
        std::valarray<double> col ( tmp.data(), tmp.size() );
        dataFrame.WriteColumn( idx-1, col ); 
    }
    
    return dataFrame;
}

//---------------------------------------------------------------
// Convert cppEDM DataFrame<double> to R DataFrame
//---------------------------------------------------------------
r::DataFrame DataFrameToDF ( DataFrame< double > dataFrame ) {
    
    r::List columnList; // List of columns to create new R data.frame

    // NOTE: cppEDM DataFrame columnNames are data only, not time
    std::vector<std::string> columnNamesIn = dataFrame.ColumnNames();
    std::vector<std::string> columnNames;
    bool hasTime = false;

    // If dataFrame has time vector and timeName, add to columnList
    if ( dataFrame.Time().size() ) {
        hasTime = true; // Skip time column in dataFrame.VectorColumnName()
        columnList.push_back( dataFrame.Time() );
        columnNames.push_back( dataFrame.TimeName() );
    }

    // Copy data: NOTE in cppEDM data and time vector are separate
    //            data are in a row-major valarray with NColumns().
    for ( auto ci = columnNamesIn.begin(); ci != columnNamesIn.end(); ci++ ) {
        if ( hasTime and (*ci).compare( dataFrame.TimeName() ) == 0 ) {
            continue;  // skip time. It's a vector< std::string > 
        }

        // unfortunately we have to copy to vector first
        std::valarray<double> col_val = dataFrame.VectorColumnName( *ci );
        std::vector<double> col_vec(std::begin(col_val), std::end(col_val));
        columnList.push_back( col_vec );
        columnNames.push_back( *ci );
    }
    
    r::DataFrame df ( columnList );
    df.attr("names") = columnNames;
        
    return df;
}

//---------------------------------------------------------------
// Load path/file into cppEDM DataFrame, convert to Python
// dict{ column : array }
//---------------------------------------------------------------
r::DataFrame ReadDataFrame ( std::string path, std::string file ) {
    return DataFrameToDF( DataFrame< double >( path, file ) );
}
