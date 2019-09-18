#wrapping the wrapped edm functions 

# run first block if just running code in this dir 
dev <- file.exists("EDM_AuxFuncs.R")
if ( dev ) {
    source("EDM_AuxFuncs.R")
    library(rEDMNew)
} else {
    source("R/EDM_AuxFuncs.R")
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

	dataFrame <- isValidDF( "", dataFrame, "MakeBlock" )

	#check cols
	columns <- checkCols( dataFrame, columns )

    # cppEDM Embed called
    made_block = INTERNAL_MakeBlock(dataFrame, E, tau, columns, verbose )

    return ( made_block )
}
#------------------------------------------------------------------------
# 
#------------------------------------------------------------------------
Embed <- function (
				   path      = "./",
				   dataFile  = "",
                   dataFrame = NULL,
				   E         = 0, 
				   tau       = 1,
				   columns   = "",
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
Simplex <- function (pathIn       = "./",
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
                     exclusionRadius = 0,
					 columns      = "",
					 target       = "", 
					 embedded     = FALSE,
					 verbose      = FALSE,
                     const_pred   = FALSE,
					 showPlot     = FALSE ) {

	#check args valid
    dataFrame   <- isValidDF( dataFile, dataFrame, "Simplex" )
	columns     <- checkCols( dataFrame, columns )
	
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
                                        exclusionRadius,
                                        columns, 
                                        target, 
                                        embedded, 
                                        const_pred,
                                        verbose )
    if ( showPlot ) {
        PlotObsPred( model_output, dataFile, E, Tp ) 
    }

    return ( model_output )
}
#------------------------------------------------------------------------
#
#------------------------------------------------------------------------
SMap <- function( pathIn       = "./",
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
                  exclusionRadius = 0,
				  columns      = "",
				  target       = "",
				  smapFile     = "",
				  jacobians    = "",
				  embedded     = FALSE,
				  const_pred   = FALSE,
				  verbose      = FALSE,
                  showPlot     = FALSE ) {

	#check args valid
    dataFrame   <- isValidDF( dataFile, dataFrame, "SMap" )
	columns     <- checkCols( dataFrame, columns )

    # return is df with predictions and coefficients

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
                                    exclusionRadius,
                                    columns,
                                    target,
                                    smapFile,
                                    jacobians,
                                    embedded,
                                    const_pred,
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
	dataFrame <- isValidDF( dataFile, dataFrame, "Multiview" )
	columns <- checkCols( dataFrame, columns )
    
    #  returns df with "Combo_rho" and  "Predictions" 
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
				 replacement  = FALSE,
				 seed         = 0,
				 verbose      = FALSE,
				 showPlot     = FALSE ) {
    #Convergent Cross Mapping on path/file.

    # Establish DF as empty list or Pandas DataFrame for CCM()
	dataFrame   <- isValidDF( dataFile, dataFrame, "CCM" )
	columns     <- checkCols( dataFrame, columns )
    
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
                        replacement,
                        seed,
                        verbose )

    if (showPlot) {
        title <- paste( "\nE=" , E )
		plot(df$LibSize, df[['anchovy:np_sst']], main=title, col="red",type="l")
		lines(df$LibSize, df[['np_sst:anchovy']], col="green")
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
							pathOut      = "",
							predictFile  = "",
							lib          = "",
							pred         = "",
							maxE         = 10,
							Tp           = 1,
							tau          = 1,
							columns      = "",
							target       = "",
							embedded     = FALSE,
							verbose      = FALSE,
							numThreads   = 4,
							showPlot     = TRUE ) {
    #Estimate optimal embedding dimension [1,10] on path/file.

    # Establish DF as empty list or Pandas DataFrame for EmbedDimension()
	dataFrame 	<- isValidDF( dataFile, dataFrame, "EmbedDimension" )	
	columns 	<- checkCols( dataFrame, columns )

    # D is a Python dict from pybind11 < cppEDM CCM
    df = INTERNAL_EmbedDimension(  pathIn,
                                   dataFile,
                                   dataFrame,
                                   pathOut,
                                   predictFile,
                                   lib,
                                   pred, 
                                   maxE, 
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
PredictInterval <- function (pathIn       = "./",
							 dataFile     = "",
							 dataFrame    = NULL,
							 pathOut      = "./",
							 predictFile  = "",
							 lib          = "",
							 pred         = "",
							 maxTp        = 10,
							 E            = 1,
							 tau          = 1,
							 columns      = "",
							 target       = "",
							 embedded     = FALSE,
							 verbose      = FALSE,
							 numThreads   = 4,
							 showPlot     = TRUE ) {
    #Estimate optimal prediction interval [1,10] on path/file.

    # Establish DF as empty list or Pandas DataFrame for PredictInterval()
	dataFrame 	<- isValidDF( dataFile, dataFrame, "PredictInterval" )
	columns 	<- checkCols( dataFrame, columns )
    
    # D is a Python dict from pybind11 < cppEDM PredictInterval
    df = INTERNAL_PredictInterval(  pathIn,
                                    dataFile,
                                    dataFrame,
                                    pathOut,
                                    predictFile,
                                    lib,
                                    pred, 
                                    maxTp,
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
							  theta        = "",
							  E            = 1,
							  Tp           = 1,
							  tau          = 1,
							  columns      = "",
							  target       = "",
							  embedded     = FALSE,
							  verbose      = FALSE,
							  numThreads   = 4,
							  showPlot     = TRUE ){
    #Estimate S-map localisation on theta in [0.01,9] on path/file.

    # Establish DF as empty list or Pandas DataFrame for PredictNonlinear()
	DF      <- isValidDF( dataFile, dataFrame, "PredictNonlinear" )
	columns <- checkCols( dataFrame, columns )
    
    # D is a Python dict from pybind11 < cppEDM PredictNonlinear
    df = INTERNAL_PredictNonlinear(  pathIn,
									 dataFile,
									 dataFrame,
									 pathOut,
									 predictFile,
									 lib,
									 pred, 
									 theta,
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
