
source("R/EDM_AuxFuncs.R")

#------------------------------------------------------------------------
# Takens time-delay embedding on columnNames in dataFrame.
# Truncates the timeseries by tau * (E-1) rows.
#------------------------------------------------------------------------
MakeBlock <- function( dataFrame,
                       E       = 0, 
                       tau     = 1,
                       columns = "",
                       verbose = FALSE ) {

  if ( ! isValidDF( dataFrame ) ) {
    stop( "MakeBlock(): dataFrame argument is not a data.frame." )
  }
  
  # Mapped to MakeBlock_rcpp() (Embed.cpp) in RcppEDMCommon.cpp
  block = INTERNAL_MakeBlock( dataFrame, E, tau, columns, verbose )
  
  return ( block )
}

#------------------------------------------------------------------------
# Takens time-delay embedding on path/file.
# Embed DataFrame columns (subset) in E dimensions.
# Calls MakeBlock() after validation and column subset selection.
#------------------------------------------------------------------------
Embed <- function( path      = "./",
                   dataFile  = "",
                   dataFrame = NULL,
                   E         = 0, 
                   tau       = 1,
                   columns   = "",
                   verbose   = FALSE ) {

  if ( ! isValidDF( dataFrame ) ) {
    stop( "Embed(): dataFrame argument is not a data.frame." )
  }

  # Mapped to Embed_rcpp() (Embed.cpp) in RcppEDMCommon.cpp
  df = INTERNAL_Embed( path,
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
Simplex <- function( pathIn       = "./",
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

  if ( ! ColumnsInDataFrame( pathIn, dataFile, dataFrame, columns, target ) ) {
    stop( "Simplex(): Failed to find column or target in DataFrame." )
  }
  
  # Mapped to Simplex_rcpp() (Simplex.cpp) in RcppEDMCommon.cpp
  smplx <- INTERNAL_Simplex( pathIn, 
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
    PlotObsPred( smplx, dataFile, E, Tp ) 
  }
  
  return ( smplx )
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

  if ( ! ColumnsInDataFrame( pathIn, dataFile, dataFrame, columns, target ) ) {
    stop( "SMap(): Failed to find column or target in DataFrame." )
  }
  
  # Mapped to SMap_rcpp() (SMap.cpp) in RcppEDMCommon.cpp
  # smapList has data.frames of "predictions" and "coefficients"
  smapList <- INTERNAL_SMap( pathIn,
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
                             verbose )

    if ( showPlot ) {
      PlotSmap( smapList, dataFile, E, Tp )
    }
  
  return( smapList )
}

#------------------------------------------------------------------------
#
#------------------------------------------------------------------------
Multiview <- function( pathIn          = "./",
                       dataFile        = "",
                       dataFrame       = NULL,
                       pathOut         = "./",
                       predictFile     = "",
                       lib             = "",
                       pred            = "",
                       E               = 0, 
                       Tp              = 1,
                       knn             = 0,
                       tau             = 1,
                       columns         = "",
                       target          = "",
                       multiview       = 0,
                       exclusionRadius = 0,
                       verbose         = FALSE,
                       numThreads      = 4,
                       showPlot        = FALSE ) {

  if ( ! ColumnsInDataFrame( pathIn, dataFile, dataFrame, columns, target ) ) {
    stop( "Multiview(): Failed to find column or target in DataFrame." )
  }
  
  # Mapped to Multiview_rcpp() (Multiview.cpp) in RcppEDMCommon.cpp
  # mvList has data.frames "Combo_rho" and  "Predictions" 
  mvList <- INTERNAL_Multiview( pathIn,
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
                                exclusionRadius,
                                verbose,
                                numThreads )

  if ( showPlot ) {
    PlotObsPred( mvList $ Predictions, dataFile, E, Tp )
  }

  # mvList: [[ "Views" = Rcpp::StringVector, "Predictions" = data.frame ]]

  # Convert mvList "Views" StringVector into data.frame
  headerVec = strsplit( mvList $ Views[1], ', ' )[[1]]

  # headerVec has 2 * N + 3 elements (columns)
  # The first N are column indices (integer)
  # Second N are column names
  # The last 3 are rho, MAE, RMSE
  Ncol = ( length( headerVec ) - 3 ) / 2

  combos = as.data.frame( matrix( 0, ncol = length( headerVec ),
                                     nrow = length( mvList $ Views ) - 1 ) )
  names( combos ) = headerVec
  
  # Process each data row, in the most inelegant way possible...
  for ( row in 2 : length( mvList $ Views ) ) {
    rowVec = strsplit( mvList $ Views[ row ], ', ' )[[1]]
    
    col.i     = as.integer( rowVec[ 1 : Ncol ] )
    col.names = rowVec[ (Ncol + 1) : (2 * Ncol) ]
    rho       = as.numeric( rowVec[ (2 * Ncol + 1) ] )
    MAE       = as.numeric( rowVec[ (2 * Ncol + 2) ] )
    RMSE      = as.numeric( rowVec[ (2 * Ncol + 3) ] )

    # "manually" insert to preserve types
    combos[ (row - 1), 1 : Ncol ] = col.i
    combos[ (row - 1), (Ncol + 1) : (2 * Ncol) ] = col.names
    combos[ (row - 1), (2 * Ncol + 1) ] = rho
    combos[ (row - 1), (2 * Ncol + 2) ] = MAE 
    combos[ (row - 1), (2 * Ncol + 3) ] = RMSE
    
  }

  MV = list( "View" = combos, "Predictions" = mvList $ Predictions )
  
  return( MV )
}

#------------------------------------------------------------------------
#
#------------------------------------------------------------------------
CCM <- function( pathIn       = "./",
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
  
  if ( ! ColumnsInDataFrame( pathIn, dataFile, dataFrame, columns, target ) ) {
    stop( "CCM(): Failed to find column or target in DataFrame." )
  }
  
  # Mapped to CCM_rcpp() (CCM.cpp) in RcppEDMCommon.cpp
  # CCMList has "LibSize" and columns:target target:columns
  CCMList <- INTERNAL_CCM( pathIn,
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

  if ( showPlot ) {
    libSize = CCMList[[ 'LibSize' ]]
    V1      = names( CCMList )[2]
    V2      = names( CCMList )[3]
                                    
    title <- paste( V1, " : ", V2, "\nE=" , E )
    
    plot( libSize, CCMList[[ V1 ]],
          ylim = range( CCMList[[ V1 ]], CCMList[[ V2 ]] ),
          main = title, col = "blue", type = "l", lwd = 3,
          xlab = 'Library Size', ylab = 'Prediction Skill (\U03C1)' )
    lines( libSize, CCMList[[ V2 ]], col = "red", lwd = 3 )
    abline( h = 0 )
    legend( 'topright', c( V1, V2 ), 
            fill = c( 'blue', 'red' ), bty = 'n', cex = 1.2 )
  }
  
  return( CCMList )
}

#------------------------------------------------------------------------
#
#------------------------------------------------------------------------
EmbedDimension <- function ( pathIn       = "./",
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

  if ( ! ColumnsInDataFrame( pathIn, dataFile, dataFrame, columns, target ) ) {
    stop( "EmbedDimension(): Failed to find column or target in DataFrame." )
  }
  
  # Mapped to EmbedDimension_rcpp() (EmbedDim.cpp) in RcppEDMCommon.cpp
  df = INTERNAL_EmbedDimension( pathIn,
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
    plot( df $ E, df $ rho, main = title, xlab = "Embedding Dimension",
          ylab = "Prediction Skill (\U03C1)", type = "l", lwd = 3 )
  }
  
  return ( df )
}

#------------------------------------------------------------------------
#
#------------------------------------------------------------------------
PredictInterval <- function( pathIn      = "./",
                             dataFile    = "",
                             dataFrame   = NULL,
                             pathOut     = "./",
                             predictFile = "",
                             lib         = "",
                             pred        = "",
                             maxTp       = 10,
                             E           = 1,
                             tau         = 1,
                             columns     = "",
                             target      = "",
                             embedded    = FALSE,
                             verbose     = FALSE,
                             numThreads  = 4,
                            showPlot    = TRUE ) {
  
  if ( ! ColumnsInDataFrame( pathIn, dataFile, dataFrame, columns, target ) ) {
    stop( "PredictInterval(): Failed to find column or target in DataFrame." )
  }
  
  # Mapped to PredictInterval_rcpp() (PredictInterval.cpp) in RcppEDMCommon.cpp
  df = INTERNAL_PredictInterval( pathIn,
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
    title <- paste( dataFile , "\nE=" , E )
    plot( df $ Tp, df $ rho, main = title, xlab = "Forecast Interval",
          ylab = "Prediction Skill (\U03C1)", type = "l", lwd = 3 )
  }
  
  return( df )
}

#------------------------------------------------------------------------
#
#------------------------------------------------------------------------
PredictNonlinear <- function( pathIn      = "./",
                              dataFile    = "",
                              dataFrame   = NULL,
                              pathOut     = "./",
                              predictFile = "",
                              lib         = "",
                              pred        = "",
                              theta       = "",
                              E           = 1,
                              Tp          = 1,
                              tau         = 1,
                              columns     = "",
                              target      = "",
                              embedded    = FALSE,
                              verbose     = FALSE,
                              numThreads  = 4,
                              showPlot    = TRUE ) {

  if ( ! ColumnsInDataFrame( pathIn, dataFile, dataFrame, columns, target ) ) {
    stop( "PredictNonlinear(): Failed to find column or target in DataFrame." )
  }
  
  # Mapped to PredictNonlinear_rcpp() (PredictNL.cpp) in RcppEDMCommon.cpp
  df = INTERNAL_PredictNonlinear( pathIn,
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
    plot( df $ Theta, df $ rho, main=title, 
          xlab = "S-map Localisation", ylab = "Prediction Skill (\U03C1)",
          type = "l", lwd = 3 )
  }
  
  return( df )
}
