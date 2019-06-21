// Expose cpp wrapper functions to EDM module via rcpp
#include "RcppEDMCommon.h"


Rcpp::DataFrame rcpp_testing(Rcpp::DataFrame dataframe) {

	DataFrame< double > df = DFToDataFrame( dataframe );
	return DataFrameToDF( df );
}
//the default args for the functions
auto ReadDataFrameArgs = r::List::create(
			r::_["path"]="",r::_["file"]="" );
auto MakeBlockArgs = r::List::create( 
               r::_["pyInput"]     = r::DataFrame(),
               r::_["E"]           = 0,
               r::_["tau"]         = 0,
               r::_["columnNames"] = std::vector<std::string>(),
               r::_["verbose"]     = false );
auto EmbedArgs = r::List::create( 
               r::_["path"]     = std::string(""),
               r::_["dataFile"] = std::string(""),
               r::_["pyInput"]  = r::DataFrame(),
               r::_["E"]        = 0,
               r::_["tau"]      = 0,
               r::_["columns"]  = std::string(""),
               r::_["verbose"]  = false );
auto SimplexArgs = r::List::create( 
               r::_["pathIn"]      = std::string("./"),
               r::_["dataFile"]    = std::string(""),
               r::_["pyInput"]     = r::DataFrame(),
               r::_["pathOut"]     = std::string("./"),
               r::_["predictFile"] = std::string(""),
               r::_["lib"]         = std::string(""),
               r::_["pred"]        = std::string(""),
               r::_["E"]           = 0,
               r::_["Tp"]          = 1,
               r::_["knn"]         = 0,
               r::_["tau"]         = 1,
               r::_["columns"]     = std::string(""),
               r::_["target"]      = std::string(""),
               r::_["embedded"]    = false,
               r::_["verbose"]     = false );
    
auto SMapArgs = r::List::create( 
               r::_["pathIn"]      = std::string("./"),
               r::_["pathIn"]      = std::string("./"),
               r::_["dataFile"]    = std::string(""),
               r::_["pyInput"]     = r::DataFrame(),
               r::_["pathOut"]     = std::string("./"),
               r::_["predictFile"] = std::string(""),
               r::_["lib"]         = std::string(""),
               r::_["pred"]        = std::string(""),
               r::_["E"]           = 0,
               r::_["Tp"]          = 1,
               r::_["knn"]         = 0,
               r::_["tau"]         = 1,
               r::_["theta"]       = 0,
               r::_["columns"]     = std::string(""),
               r::_["target"]      = std::string(""),
               r::_["smapFile"]    = std::string(""),
               r::_["jacobians"]   = std::string(""),
               r::_["embedded"]    = false,
               r::_["verbose"]     = false );
auto MultiviewArgs = r::List::create( 
               r::_["pathIn"]      = std::string("./"),
               r::_["dataFile"]    = std::string(""),
               r::_["pyInput"]     = r::DataFrame(),
               r::_["pathOut"]     = std::string("./"),
               r::_["predictFile"] = std::string(""),
               r::_["lib"]         = std::string(""),
               r::_["pred"]        = std::string(""),
               r::_["E"]           = 0,
               r::_["Tp"]          = 1,
               r::_["knn"]         = 0,
               r::_["tau"]         = 1,
               r::_["columns"]     = std::string(""),
               r::_["target"]      = std::string(""),
               r::_["multiview"]   = 0,
               r::_["verbose"]     = false,
               r::_["numThreads"]  = 4 );
auto CCMArgs = r::List::create( 
               r::_["pathIn"]      = std::string("./"),
               r::_["dataFile"]    = std::string(""),
               r::_["pyInput"]     = r::DataFrame(),
               r::_["pathOut"]     = std::string("./"),
               r::_["predictFile"] = std::string(""),
               r::_["E"]           = 0,
               r::_["Tp"]          = 0,
               r::_["knn"]         = 0,
               r::_["tau"]         = 1,
               r::_["columns"]     = std::string(""),
               r::_["target"]      = std::string(""),
               r::_["libSizes"]    = std::string(""),
               r::_["sample"]      = 0,
               r::_["random"]      = true,
               r::_["seed"]        = 0,
               r::_["verbose"]     = false );
    
auto EmbedDimensionArgs = r::List::create( 
               r::_["pathIn"]      = std::string("./"),
               r::_["dataFile"]    = std::string(""),
               r::_["pyInput"]     = r::DataFrame(),
               r::_["pathOut"]     = std::string("./"),
               r::_["predictFile"] = std::string(""),
               r::_["lib"]         = std::string(""),
               r::_["pred"]        = std::string(""),
               r::_["Tp"]          = 1,
               r::_["tau"]         = 1,
               r::_["columns"]     = std::string(""),
               r::_["target"]      = std::string(""),
               r::_["embedded"]    = false,
               r::_["verbose"]     = false,
               r::_["numThreads"]  = 4 );

auto PredictIntervalArgs = r::List::create( 
               r::_["pathIn"]      = std::string("./"),
               r::_["dataFile"]    = std::string(""),
               r::_["pyInput"]     = r::DataFrame(),
               r::_["pathOut"]     = std::string("./"),
               r::_["predictFile"] = std::string(""),
               r::_["lib"]         = std::string(""),
               r::_["pred"]        = std::string(""),
               r::_["E"]           = 0,
               r::_["tau"]         = 1,
               r::_["columns"]     = std::string(""),
               r::_["target"]      = std::string(""),
               r::_["embedded"]    = false,
               r::_["verbose"]     = false,
               r::_["numThreads"]  = 4 );

auto PredictNonlinearArgs = r::List::create( 
               r::_["pathIn"]      = std::string("./"),
               r::_["dataFile"]    = std::string(""),
               r::_["pyInput"]     = r::DataFrame(),
               r::_["pathOut"]     = std::string("./"),
               r::_["predictFile"] = std::string(""),
               r::_["lib"]         = std::string(""),
               r::_["pred"]        = std::string(""),
               r::_["E"]           = 0,
               r::_["Tp"]          = 1,
               r::_["tau"]         = 1,
               r::_["columns"]     = std::string(""),
               r::_["target"]      = std::string(""),
               r::_["embedded"]    = false,
               r::_["verbose"]     = false,
               r::_["numThreads"]  = 4 );
void hello_world_cpp(){
	cout << "hello word\n";
} 
//export the functions
RCPP_MODULE(rEDMInternal) {
	r::function( "INTERNAL_hello_world_cpp",&hello_world_cpp);
    r::function( "INTERNAL_ComputeError", &ComputeError_rcpp );
	r::function( "INTERNAL_ReadDataFrame", &ReadDataFrame, ReadDataFrameArgs);
	r::function( "INTERNAL_MakeBlock", &MakeBlock_rcpp, MakeBlockArgs);
	r::function( "INTERNAL_Embed", &Embed_rcpp, EmbedArgs);
	r::function( "INTERNAL_Simplex", &Simplex_rcpp, SimplexArgs);
	r::function( "INTERNAL_SMap", &SMap_rcpp, SMapArgs);
	r::function( "INTERNAL_Multiview", &Multiview_rcpp, MultiviewArgs);
	r::function( "INTERNAL_CCM", &CCM_rcpp, CCMArgs);
	r::function( "INTERNAL_EmbedDimension", &EmbedDimension_rcpp, 
			EmbedDimensionArgs);
	r::function( "INTERNAL_PredictInterval", &PredictInterval_rcpp, 
			PredictIntervalArgs);
	r::function( "INTERNAL_PredictNonlinear", &PredictNonlinear_rcpp, 
			PredictNonlinearArgs);
}
