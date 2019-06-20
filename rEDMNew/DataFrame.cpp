#include "RcppEDMCommon.cpp"

//-----------------------------------------------------------------------
// Convert DF list< pair<string, valarray> > to cppEDM DataFrame<double>
//-----------------------------------------------------------------------
DataFrame< double > DFToDataFrame ( DF df ) {

    // Get number of valarray rows from first pair
    size_t numRows = 0;
    if ( df.size() ) {
        numRows = df.front().second.size();
    }
    
    // Get column names
    std::vector< std::string > colNames;
    for ( auto colPair : df ) {
        colNames.push_back( colPair.first );
    } 

    // Create cpp DataFrame
    DataFrame< double > dataFrame ( numRows, colNames.size(), colNames ); 

    for ( DF::iterator it = df.begin(); it != df.end(); it++ ) {

        dataFrame.WriteColumn( std::distance( df.begin(), it), it->second ); 

    }

    return dataFrame;
}
