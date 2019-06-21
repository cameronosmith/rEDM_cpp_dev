library( rEDMNew )

df <- data.frame(matrix(rnorm(20), nrow=500))
colnames(df)<-c("a")

Simplex("","",df,lib="1 100", pred="101 200",columns="a")

funcs <-'
r::function( "ComputeError", &ComputeError_rcpp );
	r::function( "ReadDataFrame", &ReadDataFrame, ReadDataFrameArgs);
	r::function( "MakeBlock", &MakeBlock_rcpp, MakeBlockArgs);
	r::function( "Embed", &Embed_rcpp, EmbedArgs);
	r::function( "Simplex", &Simplex_rcpp, SimplexArgs);
	r::function( "SMap", &SMap_rcpp, SMapArgs);
	r::function( "Multiview", &Multiview_rcpp, MultiviewArgs);
	r::function( "CCM", &CCM_rcpp, CCMArgs);
	r::function( "EmbedDimension", &EmbedDimension_rcpp, 
			EmbedDimensionArgs);
	r::function( "PredictInterval", &PredictInterval_rcpp, 
			PredictIntervalArgs);
	r::function( "PredictNonlinear", &PredictNonlinear_rcpp, 
			PredictNonlinearArgs);
}

