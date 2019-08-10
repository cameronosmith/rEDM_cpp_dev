#wrapping the wrapped edm functions 

if ( TRUE ) {
    source("Aux.R")
    library(rEDMNew)
} else {
    source("R/Aux.R")
}

#------------------------------------------------------------------------
# 
#------------------------------------------------------------------------
MakeBlock <- function( dataFrame,
					   E           = 0, 
					   tau         = 1,
					   columnNames = "",
					   verbose     = FALSE ) {
    #Takens time-delay embedding on columnNames in Pandas DataFrame.
    #Truncates the timeseries by tau * (E-1) rows.

	dataFrame <- isValidDF( NULL, dataFrame, "MakeBlock" )

	if ( typeof(columnNames)=="character" && columnNames == "" ) 
		columnNames <- colnames(dataFrame)

    # cppEDM Embed called
    made_block = INTERNAL_MakeBlock(dataFrame, E, tau, columnNames, verbose )

    return ( made_block )
}
#------------------------------------------------------------------------
# 
#------------------------------------------------------------------------
Embed <- function (dataFrame = NULL,
				   E         = 0, 
				   tau       = 1,
				   columns   = "",
				   path      = "./",
				   dataFile  = "",
				   verbose   = FALSE ) {
    #Takens time-delay embedding on path/file.
    #Embed DataFrame columns (subset) in E dimensions.
    #Calls MakeBlock() after validation and column subset selection.

    # Establish DF as empty list or Pandas DataFrame for Embed()
    dataFrame <- isValidDF( dataFile, dataFrame, "Embed" )

	#check cols
	columns <- checkCols( dataFrame, columns )
	
    # call cppEDM Embed
    df = INTERNAL_Embed(  path,
						  dataFile,
						  dataFrame,
						  E, 
						  tau,
						  columns,
						  verbose )

    return ( df )
}
#------------------------------------------------------------------------
#
#------------------------------------------------------------------------
Simplex <- function (
				  	 pathIn       = "./",
					 dataFile     = "",
                     dataFrame    = NULL,
					 pathOut      = "./",
					 predictFile  = "",
					 lib          = "",
					 pred         = "",
					 E            = 0, 
					 Tp           = 1,
					 knn          = 0,
					 tau          = 1,
					 columns      = "",
					 target       = "", 
					 embedded     = FALSE,
					 verbose      = FALSE,
					 statsOnly	  = TRUE,
					 showPlot     = FALSE ) {

	#check args valid
    #DF 		<- isValidDF( dataFile, dataFrame, "Simplex" )
	#columns <- checkCols( DF, columns )
	#lib	 	<- checkRangeForm( lib )
	#pred 	<- checkRangeForm( pred )
	#tmp  	<-checkEmptyLibPred(lib,pred,DF); lib <- tmp[[1]];pred<-tmp[[2]];

    model_output <- INTERNAL_Simplex(   pathIn, 
                                        dataFile, 
                                        dataFrame, 
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
                                        embedded, 
                                        verbose )
    if ( showPlot ) {
        if ( statsOnly ) print("For showPlot you need to have statsOnly=FALSE")
        PlotObsPred( model_output, dataFile, E, Tp ) 
    }

    return ( model_output )
}
#------------------------------------------------------------------------
#
#------------------------------------------------------------------------
SMap <- function( 
				  pathIn       = "./",
				  dataFile     = "",
                  dataFrame    = NULL,
				  pathOut      = "./",
				  predictFile  = "",
				  lib          = "",
				  pred         = "",
				  E            = 0, 
				  Tp           = 1,
				  knn          = 0,
				  tau          = 1,
				  theta        = 0,
				  columns      = "",
				  target       = "",
				  smapFile     = "",
				  jacobians    = "",
				  embedded     = FALSE,
				  verbose      = FALSE,
				  statsOnly	   = TRUE,
                  showPlot ) {
    #S-Map prediction on path/file.

    # Establish DF as empty list or Pandas DataFrame for SMap()
    #dataFrame <- isValidDF( dataFile, dataFrame, "SMap")
	#columns <- checkCols( dataFrame, columns )
	#lib	 <- checkRangeForm( lib )
	#pred <- checkRangeForm( pred )
	#tmp <-	checkEmptyLibPred(lib,pred,dataFrame);
    #lib <- tmp[[1]];
    #pred<-tmp[[2]];
	
    model_output <- INTERNAL_SMap(  pathIn,
                                    dataFile,
                                    dataFrame,
                                    pathOut,
                                    predictFile,
                                    lib,
                                    pred,  
                                    E, 
                                    Tp,
                                    knn,
                                    tau,
                                    theta,
                                    columns,
                                    target,
                                    smapFile,
                                    jacobians,
                                    embedded,
                                    verbose)
    if (showPlot) {
      PlotObsPred( model_output$predictions, dataFile, E, Tp, FALSE )                           
      PlotCoeff  ( model_output$coefficients, dataFile, E, Tp )                                  
    }
        

    return( model_output )
}

#------------------------------------------------------------------------
#
#------------------------------------------------------------------------
Multiview <- function (
					   pathIn       = "./",
					   dataFile     = "",
                       dataFrame    = NULL,
					   pathOut      = "./",
					   predictFile  = "",
					   lib          = "",
					   pred         = "",
					   E            = 0, 
					   Tp           = 1,
					   knn          = 0,
					   tau          = 1,
					   columns      = "",
					   target       = "",
					   multiview    = 0,
					   verbose      = FALSE,
					   numThreads   = 4,
					   showPlot     = FALSE ) {
    #Multiview prediction on path/file.

    # Establish DF as empty list or Pandas DataFrame for Multiview()
	#dataFrame <- isValidDF( dataFile, dataFrame, "Multiview" )
	#columns <- checkCols( dataFrame, columns )
	#lib	 	<- checkRangeForm( lib )
	#pred 	<- checkRangeForm( pred )
	#tmp 	<- checkEmptyLibPred(lib,pred,dataFrame);lib <- tmp[[1]];pred<-tmp[[2]];
	#if ( E==0 ) E=1
   	#if ( knn==0 ) knn = E+1 
    
    # D is a Python dict from pybind11 < cppEDM Multiview:
    #  { "Combo_rho" : {}, "Predictions" : {} }
    D <- INTERNAL_Multiview(  pathIn,
							  dataFile,
							  dataFrame,
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
							  numThreads )

    if ( showPlot ) {
        PlotObsPred( D$Predictions, dataFile, E, Tp )
    }

    return( D )
}
#------------------------------------------------------------------------
#
#------------------------------------------------------------------------
CCM <- function (
			     pathIn       = "./",
				 dataFile     = "",
				 dataFrame    = NULL,
				 pathOut      = "./",
				 predictFile  = "",
				 E            = 0, 
				 Tp           = 1,
				 knn          = 0,
				 tau          = 1,
				 columns      = "",
				 target       = "",
				 libSizes     = "",
				 sample       = 0,
				 random       = TRUE,
				 seed         = 0,
				 verbose      = FALSE,
				 showPlot     = FALSE ) {
    #Convergent Cross Mapping on path/file.

    # Establish DF as empty list or Pandas DataFrame for CCM()
	#dataFrame <- isValidDF( dataFile, dataFrame, "CCM" )
    
    # D is a Python dict from pybind11 < cppEDM CCM
    df <- INTERNAL_CCM( pathIn,
                        dataFile,
                        dataFrame,
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
                        verbose )

    if (showPlot) {
		#fix this
        title <- paste( dataFile , "\nE=" , E )
		plot( df$LibSize, df[['anchovy:np_sst']], main=title, col="red",type="l")
		lines( df$LibSize, df[['np_sst:anchovy']], col="green")
		legend('topright', names(df)[-1] , 
		   lty=1, col=c('red', 'green' ), bty='n', cex=.75)
	}
    
    return( df )
}
#------------------------------------------------------------------------
#
#------------------------------------------------------------------------
EmbedDimension <- function (
							pathIn       = "./",
							dataFile     = "",
							dataFrame    = NULL,
							pathOut      = "./",
							predictFile  = "",
							lib          = "",
							pred         = "",
							Tp           = 1,
							tau          = 1,
							columns      = "",
							target       = "",
							embedded     = FALSE,
							verbose      = FALSE,
							numThreads   = 4,
							showPlot     = TRUE ) {
    #Estimate optimal embedding dimension [1,10] on path/file.
	#lib	 <- checkRangeForm( lib )
	#pred <- checkRangeForm( pred )

    # Establish DF as empty list or Pandas DataFrame for EmbedDimension()
	#dataFrame 	<- isValidDF( dataFile, dataFrame, "EmbedDimension" )	
	#columns 	<- checkCols( dataFrame, columns )
	#tmp <-	checkEmptyLibPred(lib,pred,dataFrame);lib <- tmp[[1]];pred<-tmp[[2]];

    # D is a Python dict from pybind11 < cppEDM CCM
    df = INTERNAL_EmbedDimension(pathIn,
					   dataFile,
					   dataFrame,
					   pathOut,
					   predictFile,
					   lib,
					   pred, 
					   Tp,
					   tau,
					   columns,
					   target,
					   embedded,
					   verbose,
					   numThreads )

    if ( showPlot ) {
        title <- paste(dataFile , "\nTp=" , Tp )
		plot(df$E, df$rho, main=title,xlab="Embedding Dimension",
				ylab="Prediction Skill",type="o")
	}
    
    return ( df )
}

#------------------------------------------------------------------------
#
#------------------------------------------------------------------------
PredictInterval <- function (
							 pathIn       = "./",
							 dataFile     = "",
							 dataFrame    = NULL,
							 pathOut      = "./",
							 predictFile  = "",
							 lib          = "",
							 pred         = "",
							 E            = 1,
							 tau          = 1,
							 columns      = "",
							 target       = "",
							 embedded     = FALSE,
							 verbose      = FALSE,
							 numThreads   = 4,
							 showPlot     = TRUE ) {
    #Estimate optimal prediction interval [1,10] on path/file.
	#lib	 <- checkRangeForm( lib )
	#pred <- checkRangeForm( pred )

    # Establish DF as empty list or Pandas DataFrame for PredictInterval()
	#dataFrame 	<- isValidDF( dataFile, dataFrame, "PredictInterval" )
	#columns 	<- checkCols( dataFrame, columns )
	#tmp <-	checkEmptyLibPred(lib,pred,dataFrame);lib <- tmp[[1]];pred<-tmp[[2]];
    
    # D is a Python dict from pybind11 < cppEDM PredictInterval
    df = INTERNAL_PredictInterval(  pathIn,
                                    dataFile,
                                    dataFrame,
                                    pathOut,
                                    predictFile,
                                    lib,
                                    pred, 
                                    E,
                                    tau,
                                    columns,
                                    target,
                                    embedded,
                                    verbose,
                                    numThreads )

    if ( showPlot ) {
        title <- paste(dataFile , "\nE=" , E )
		plot(df$Tp, df$rho, main=title,xlab="Forecast Interval",
				ylab="Prediction Skill",type="o")
	}
    
    return( df )
}
#------------------------------------------------------------------------
#
#------------------------------------------------------------------------
PredictNonlinear <- function (pathIn       = "./",
							  dataFile     = "",
							  dataFrame    = NULL,
							  pathOut      = "./",
							  predictFile  = "",
							  lib          = "",
							  pred         = "",
							  E            = 0,
							  Tp           = 1,
							  tau          = 1,
							  columns      = "",
							  target       = "",
							  embedded     = FALSE,
							  verbose      = FALSE,
							  numThreads   = 4,
							  showPlot     = TRUE ){
    #Estimate S-map localisation on theta in [0.01,9] on path/file.
	#lib	 <- checkRangeForm( lib )
	#pred <- checkRangeForm( pred )

    # Establish DF as empty list or Pandas DataFrame for PredictNonlinear()
	#DF <- isValidDF( dataFile, dataFrame, "PredictNonlinear" )
    
    # D is a Python dict from pybind11 < cppEDM PredictNonlinear
    df = INTERNAL_PredictNonlinear(  pathIn,
									 dataFile,
									 dataFrame,
									 pathOut,
									 predictFile,
									 lib,
									 pred, 
									 E,
									 Tp,
									 tau,
									 columns,
									 target,
									 embedded,
									 verbose,
									 numThreads )
    if ( showPlot ) {
        title = paste(dataFile , "\nE=", E )
		plot( df$Theta, df$rho, main=title, 
				xlab="S-map Localisation", ylab="Prediction Skill", type="o")
	}
    
    return( df )
}
