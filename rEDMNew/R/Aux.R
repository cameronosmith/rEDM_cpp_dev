#wrapping the wrapped the auxillary functions used in rEDM

#------------------------------------------------------------------------
#run model output on varying the parameters in a range
#input	: named list of args to vary
#output	: dataframe with all args ran
#------------------------------------------------------------------------
RunModelVariedParams <- function( varied_args ) {
	for ( arg in names(varied_args) ) {
		arg_range <- varied_args[arg]
		print(paste(arg,arg_range))
		print(arg_range)
	}
}
#------------------------------------------------------------------------
#get stats on model output
#input	: model output, args to include in model output
#output	: dataframe with stats
#------------------------------------------------------------------------
GetModelStats <- function ( model_output, relevant_args ) {
	stats 			<- ComputeError ( 	model_output$Observations,
										model_output$Predictions )
	all_relevant 	<- c( relevant_args, stats )
	stats_output 	<- rbind.data.frame( all_relevant )
	return( stats_output )
}
#------------------------------------------------------------------------
# 
#------------------------------------------------------------------------
ComputeError <- function( obs, pred ) {
	#Pearson rho, RMSE, MAE.
    return ( INTERNAL_ComputeError( obs, pred ) )
}
#------------------------------------------------------------------------
# takes in df and potentially empty columns and makes sure not empty
#------------------------------------------------------------------------
checkCols <- function( df,  cols ) {
	if ( cols=="" && ncol(df)!=0 ) {
		cols <- colnames(df)[1]
	}	
	return ( cols )
}
#------------------------------------------------------------------------
# takes in potentially empty lib/pred args and gives default val
#------------------------------------------------------------------------
checkEmptyLibPred <- function ( lib, pred, dataFrame ) {
	if ( ( lib == "" || pred == "" ) && nrow(dataFrame)!=0 ) {
		half 	<- nrow(dataFrame)/3
		lib 	<- paste(0, half )
		pred 	<- paste(half, 1+2*nrow(dataFrame)/3 )
	}
	return (list(lib=lib,pred=pred))
}
#------------------------------------------------------------------------
# takes in potential lib/pred arg as list and returns as string
#------------------------------------------------------------------------
checkRangeForm <- function ( libPredArg, dataFrame ) {
	if ( typeof(libPredArg)=="double"||typeof(libPredArg)=="integer"){
		start <- libPredArg[1]
		end <- libPredArg[length(libPredArg)]+1
		libPredArg <- paste(start,end)
	}
	return (libPredArg)
}
#------------------------------------------------------------------------
# 
#------------------------------------------------------------------------
isValidDF <- function(dataFile, dataFrame, functionName ) {
	# Establish DF as empty list or Pandas DataFrame for Embed()
    if ( !is.null(dataFile) && dataFile!="" ){
        return( data.frame() )
	}
    else if (inherits(dataFrame, "data.frame") ) {
        if (nrow(dataFrame) == 0)
            stop( paste(functionName,"(): dataFrame is empty." ) )
		return( dataFrame )
	}
	else if ( typeof(dataFrame)=="double"||typeof(dataFrame)=="integer") {
		tmp_df <- data.frame(X1=dataFrame)
        return( tmp_df )
	}
    else {
        stop( paste( functionName, "(): Invalid data input." ) )
	}
}
#------------------------------------------------------------------------
# 
#------------------------------------------------------------------------
PlotObsPred <- function( df, dataFile = None, E = None, Tp = None, block = TRUE ) {
    #Plot observations and predictions
	df[is.na(df)] <- 0
    # stats: {'MAE': 0., 'RMSE': 0., 'rho': 0. }
    stats = ComputeError( df$Observations,
						  df$Predictions )
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
