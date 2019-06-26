#wrapping the wrapped edm functions 

#library(rEDMNew)
source("R/Aux.R")

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

	if (! inherits(dataFrame, "data.frame")  ) {
        stop( "MakeBlock(): dataFrame is not a data.frame." )
	}
    
    # cppEDM Embed called
    made_block = MakeBlock(DF, E, tau, columnNames, verbose )

    return ( made_block )
}
#------------------------------------------------------------------------
# 
#------------------------------------------------------------------------
Embed <- function (path      = "./",
				   dataFile  = NULL,
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
    
    # call cppEDM Embed
    df = INTERNAL_Embed(  path,
						  dataFile,
						  DF,
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
					 dataFile     = NULL,
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
					 showPlot     = FALSE ) {
    #Simplex prediction on path/file.

    # Establish DF as empty list or Pandas DataFrame for Simplex()
    DF <- isValidDF( dataFile, dataFrame, "Simplex" )
    
    # D is a Python dict from pybind11 < cppEDM Simplex 
    df <- INTERNAL_Simplex( pathIn,
                            dataFile,
                            DF,
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
                            verbose  )

    if ( showPlot ) 
        PlotObsPred( df, dataFile, E, Tp )
    
    return ( df )
}
#------------------------------------------------------------------------
#
#------------------------------------------------------------------------
SMap <- function (pathIn       = "./",
				  dataFile     = NULL,
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
				  showPlot     = FALSE ) {
    #S-Map prediction on path/file.

    # Establish DF as empty list or Pandas DataFrame for SMap()
    dataFrame <- isValidDF( dataFile, dataFrame, "SMap")

	# D is a Python dict from pybind11 < cppEDM SMap:
    #  { "predictions" : {}, "coefficients" : {} }
    D <- INTERNAL_SMap(  pathIn,
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
						 verbose  )

    if ( showPlot ) {
        PlotObsPred( D$predictions, dataFile, E, Tp, FALSE )
        PlotCoeff  ( D$coefficients, dataFile, E, Tp )
	}

    return( D )
}

#------------------------------------------------------------------------
#
#------------------------------------------------------------------------
Multiview <- function (pathIn       = "./",
					   dataFile     = NULL,
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

    if ( showPlot )
        PlotObsPred( D$Predictions, dataFile, E, Tp )

    return( D )
}
#------------------------------------------------------------------------
#
#------------------------------------------------------------------------
CCM <- function (pathIn       = "./",
				 dataFile     = NULL,
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
	dataFrame <- isValidDF( dataFile, dataFrame, "CCM" )
    
    # D is a Python dict from pybind11 < cppEDM CCM
    df <- INTERNAL_CCM(pathIn,
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
EmbedDimension <- function (pathIn       = "./",
							dataFile     = NULL,
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

    # Establish DF as empty list or Pandas DataFrame for EmbedDimension()
	dataFrame <- isValidDF( dataFile, dataFrame, "EmbedDimension" )	

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
PredictInterval <- function (pathIn       = "./",
							 dataFile     = NULL,
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

    # Establish DF as empty list or Pandas DataFrame for PredictInterval()
	dataFrame <- isValidDF( dataFile, dataFrame, "PredictInterval" )
    
    # D is a Python dict from pybind11 < cppEDM PredictInterval
    df = INTERNAL_PredictInterval(pathIn,
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
							  dataFile     = NULL,
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

    # Establish DF as empty list or Pandas DataFrame for PredictNonlinear()
	DF <- isValidDF( dataFile, dataFrame, "PredictNonlinear" )
    
    # D is a Python dict from pybind11 < cppEDM PredictNonlinear
    df = INTERNAL_PredictNonlinear(  pathIn,
									 dataFile,
									 DF,
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
