#wrapping the wrapped the auxillary functions used in rEDM

#------------------------------------------------------------------------
# 
#------------------------------------------------------------------------
ComputeError <- function( obs, pred ) {
	#Pearson rho, RMSE, MAE.
    return ( INTERNAL_ComputeError( obs, pred ) )
}
#------------------------------------------------------------------------
# 
#------------------------------------------------------------------------
ReadDataFrame <- function( path, file ) {
    #Read path/file into DataFrame.
    df <- ReadDataFrame( path, file )
    return ( df )
} 
#------------------------------------------------------------------------
# 
#------------------------------------------------------------------------
isValidDF <- function(dataFile, dataFrame, functionName ) {
	# Establish DF as empty list or Pandas DataFrame for Embed()
    if ( !is.null(dataFile) ) {
        return( data.frame() )
	}
    else if (inherits(dataFrame, "data.frame") ) {
        if (nrow(dataFrame) == 0 || dataFrame == NULL )
            stop( paste(functionName,"(): dataFrame is empty." ) )
		return( dataFrame )
	}
    else {
        stop( paste( functionName, "(): Invalid data input." ) )
	}
}
#------------------------------------------------------------------------
# 
#------------------------------------------------------------------------
PlotObsPred <- function( df, dataFile = None, E = None, Tp = None, block = True ) {
    #Plot observations and predictions
	df[is.na(df)] <- 0
    # stats: {'MAE': 0., 'RMSE': 0., 'rho': 0. }
    stats = ComputeError( df[['Observations']],
						  df[['Predictions']] )
    title = paste(dataFile , "\nE=" , E , " Tp=" , Tp,
            " rho="   , round( stats[['rho']],  2 ),    
            " RMSE=" , round( stats[['RMSE']], 2  ) )

	plot( df$Time, df$Observations, main=title,
			xlab="Time", type="l",col="red")
	lines(df$Time, df$Predictions,col="green")
	legend('topright', names(df)[-1] , 
	   lty=1, col=c('red', 'green','blue' ), bty='n', cex=.75)
}
    
#------------------------------------------------------------------------
# 
#------------------------------------------------------------------------
PlotCoeff <- function( df, dataFile = None, E = None, Tp = None, block = True ){
    #Plot S-Map coefficients
    
    title <- paste(dataFile , '\nE=' , E , ' Tp=' , Tp,
            '  S-Map Coefficients')
    # Coefficient columns can be in any column
	
	all_cols <- colnames(df)
	coef_cols <- all_cols[all_cols!="Time"]

	par(mfcol = c(3, 1))
	plot( df$Time, df$C0, xlab="",ylab="", main=title, col="red")
	plot( df$Time, df$C1, xlab="",ylab="",col="green")
	plot( df$Time, df$C2, xlab="Time", ylab="hi",col="blue")
    
}
