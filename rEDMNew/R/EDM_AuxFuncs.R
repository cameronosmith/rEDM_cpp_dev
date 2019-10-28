#------------------------------------------------------------------------
# 
#------------------------------------------------------------------------
ComputeError <- function( obs, pred ) {
  # Pearson rho, RMSE, MAE.
  return ( INTERNAL_ComputeError( obs, pred ) )
}

#------------------------------------------------------------------------
# Validate columns are present
#------------------------------------------------------------------------
ColumnsInDataFrame <- function( pathIn, dataFile, dataFrame, columns, target ) {

  if ( nchar( dataFile ) ) {
    # Shame to have to read the data just for this...
    # Perhaps pass the df back ?  Gets messy.
    df = read.csv( paste( pathIn, dataFile, sep = '/' ), as.is = TRUE )
  }
  else {
    df = dataFrame
  }

  if ( ! isValidDF( df ) ) {
    print( "Error: ColumnsInDataFrame(): dataFrame is not valid." )
    return( FALSE )
  }

  columnNames = names( df )
  columnVec   = strsplit( columns, "\\s+" ) # split on whitespace
  
  if ( ! (target %in% columnNames) ) {
    print( paste( "Error: ColumnsInDataFrame(): Target",
                  target, "not found." ) )
    return( FALSE )
  }
  
  for ( column in columnVec ) {
    
    if ( length( column ) == 0 ) {
      print( "Error: ColumnsInDataFrame(): Column is empty." )
      return( FALSE )
    }
    # Why is column of length > 1 in Examples() CCM ?
    if ( ! (column[1] %in% columnNames) ) {
      print( paste( "Error: ColumnsInDataFrame(): Column",
                    column, "not found." ) )
      return( FALSE )
    }
  }

  return( TRUE )
}

#------------------------------------------------------------------------
# Is dataFrame a non-empty data.frame?  TRUE : FALSE
#------------------------------------------------------------------------
isValidDF <- function( dataFrame ) {
  if ( inherits( dataFrame, "data.frame" ) ) {
    if ( nrow( dataFrame ) == 0 || ncol( dataFrame ) == 0 ) { 
      print( paste( "isValidDF(): dataFrame is empty." ) )
      return( FALSE )
    }
    return( TRUE )
  }
  else {
    return( FALSE )
  }
}

#------------------------------------------------------------------------
# Plot data.frame with "time" "Observations" "Predictions"
#------------------------------------------------------------------------
PlotObsPred <- function( df,
                         dataFile = NULL,
                         E        = NULL,
                         Tp       = NULL ) {

  if ( ncol( df ) < 3 ) {
    print( "PlotObsPred: at least 3 columns are expected." )
    return( 0 )
  }
  if ( ! "Observations" %in% names( df ) ) {
    print( "PlotObsPred: unable to find Observations." )
    return( 0 )
  }
  if ( ! "Predictions" %in% names( df ) ) {
    print( "PlotObsPred: unable to find Predictions." )
    return( 0 )
  }

  # Try to convert first column to Date or POSIXlt or numeric
  time = NULL
  if ( is.numeric( df[,1] ) ) {
    time = df[,1]
  }
  else {
    time = try( as.Date( df[,1] ), silent = TRUE )
    if ( "try-error" %in% class( time ) ) {
      time = try( as.POSIXlt( df[,1] ), silent = TRUE )
      if ( "try-error" %in% class( time ) ) {
        time = try(as.numeric(levels(df[,1]))[df[,1]], silent = TRUE)
      }
    }
  }
  if ( "try-error" %in% class( time ) ) {
    # Create a bogus time vector
    time = seq( 1, nrow( df ) )
  }

  # stats: {'MAE': 0., 'RMSE': 0., 'rho': 0. }
  stats = ComputeError( df $ Observations,
                        df $ Predictions )
  
  title = paste( "\nE=", E, " Tp=", Tp,
                 " rho=",  round( stats[['rho']],  2 ),    
                 " RMSE=", round( stats[['RMSE']], 2 ) )
  
  plot( time, df $ Observations, main = title,
        xlab = names(df)[1], ylab = "",
        type = "l", col = "blue", lwd = 3,
        cex.axis = 1.3, cex.lab = 1.3 )
  
  lines( time, df $ Predictions, col = "red", lwd = 3 )
  
  legend( 'topright', c( "Predictions", "Observations" ), 
          fill = c('red', 'blue' ), bty = 'n', cex = 1.2 )
}

#------------------------------------------------------------------------
# Plot S-Map coefficients
#------------------------------------------------------------------------
PlotSmap <- function( SmapList,
                      dataFile = NULL,
                      E        = NULL,
                      Tp       = NULL ) {

  if ( ! "predictions" %in% names( SmapList ) ) {
    print( "PlotSmap: unable to find predictions." )
    return( 0 )
  }
  if ( ! "coefficients" %in% names( SmapList ) ) {
    print( "PlotSmap: unable to find coefficients." )
    return( 0 )
  }

  p = SmapList[[ "predictions"  ]]
  c = SmapList[[ "coefficients" ]]

  if ( ncol( p ) < 3 ) {
    print( "PlotSmap: expected at least 3 columns in predictions." )
    return( 0 )
  }
  
  # Try to convert first column to Date or POSIXlt or numeric
  time = NULL
  if ( is.numeric( p[,1] ) ) {
    time = p[,1]
  }
  else {
    time = try( as.Date( p[,1] ), silent = TRUE )
    if ( "try-error" %in% class( time ) ) {
      time = try( as.POSIXlt( p[,1] ), silent = TRUE )
      if ( "try-error" %in% class( time ) ) {
        time = try(as.numeric(levels(p[,1]))[p[,1]], silent = TRUE)
      }
    }
  }
  if ( "try-error" %in% class( time ) ) {
    # Create a bogus time vector
    time = seq( 1, nrow( p ) )
  }

  numCoeff = ncol( c ) - 1 
  
  old.par <- par( no.readonly = TRUE )
  
  par( mfrow = c( numCoeff + 1, 1 ), mar = c( 3.5, 4, 0.5, 1 ),
       mgp = c( 1.5, 0.5, 0 ), cex.axis = 1.3, cex.lab = 1.3 )
  
  # Observations & Predictions
  plot( time, p $ Observations,
        xlab = names(p)[1], ylab = "",
        type = "l", col = "blue", lwd = 3,
        cex.axis = 1.3, cex.lab = 1.3 )
  
  lines( time, p $ Predictions, col = "red", lwd = 3 )
  legend( 'topright', c( "Predictions", "Observations" ), 
          fill = c('red', 'blue' ), bty = 'n', cex = 1.5 )

  # Coefficients
  title <- paste( dataFile , 'S-Map Coefficients', '\nE=' , E, ' Tp=', Tp )

  coefName = names( c )
  for ( coef in 2:ncol(c) ) {
    plot( time, c[,coef], xlab = "Time", ylab = coefName[coef],
          col = "blue", type = "l", lwd = 3 )
    mtext( title, side = 3, line = -1.5, cex = 1.2 )
  }

  par( old.par )
}
