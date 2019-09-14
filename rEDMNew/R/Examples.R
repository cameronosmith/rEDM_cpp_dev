# run first block if just running code in this dir 
dev <- file.exists("Aux.R")
if ( dev ) {
    source("EDM.R")
    source("LoadData.R")
} else {
    source("R/EDM.R")
    source("R/LoadData.R")
}
#------------------------------------------------------------------------
# 
#------------------------------------------------------------------------
Examples <- function() {

    # make sure the data exists before we use it 

    sampleDataNames =
        c("TentMap","TentMapNoise","circle","block_3sp", "sardine_anchovy_sst")

    for ( dataName in sampleDataNames ) {
        if (!(dataName %in% names( sampleData ) )) {
            stop( paste0("Examples(): Failed to find sample data " ,
                  dataName , " in EDM package" ) )
        }
    }
    
    # run embed dimension demo

    cmd = paste0('EmbedDimension( dataFrame=sampleData["TentMap"][[1]],',
                       ' lib="1 100", pred="201 500",',
                       ' columns="TentMap", target="TentMap")' )
    df = eval(parse(text=cmd))


    # run predict interval demo

    cmd = paste0('PredictInterval( dataFrame=sampleData["TentMap"][[1]],',
                       ' lib="1 100", pred="201 500",',
                       ' columns="TentMap", target="TentMap") ')
    df = eval(parse(text=cmd))
    # run predict nonlinear demo

    cmd = paste0('PredictNonlinear( dataFrame=sampleData["TentMapNoise"][[1]],',
                      ' E=2,lib="1 100", pred="201 500", ',
                      ' columns="TentMap",target="TentMap") ')
    df = eval(parse(text=cmd))

    # tent map simplex : specify multivariable columns embedded = TRUE

    cmd = paste0('Simplex( dataFrame=sampleData["block_3sp"][[1]],',
                      ' lib="1 99", pred="100 195", ',
                      ' E=3, embedded=TRUE, showPlot=TRUE, const_pred=TRUE,',
                      ' columns="x_t y_t z_t", target="x_t") ')
    df = eval(parse(text=cmd))

    # Tent map simplex : Embed column x_t to E=3, embedded = False

    cmd = paste0('Simplex( dataFrame=sampleData["block_3sp"][[1]],',
                      ' lib="1 99", pred="105 190", ',
                      ' E=3, showPlot=TRUE, const_pred=TRUE,',
                      ' columns="x_t", target="x_t") ')
    df = eval(parse(text=cmd))

    # multiview demo

    cmd = paste0('Multiview( dataFrame=sampleData["block_3sp"][[1]],',
                      ' lib="1 99", pred="105 190", ',
                      ' E=3, columns="x_t y_t z_t", target="x_t",',
                      ' showPlot=TRUE) ')
    df = eval(parse(text=cmd))

    # SMap circle : specify multivariable columns embedded = TRUE

    cmd = paste0('SMap( dataFrame=sampleData["circle"][[1]],',
                      ' lib="1 100", pred="110 190", theta=4, E=2,',
                      'verbose=TRUE, showPlot=TRUE, embedded=TRUE,',
                      ' columns="x y", target="x") ')
    df = eval(parse(text=cmd))
    
    # CCM demo

    cmd = paste0('CCM( dataFrame=sampleData["sardine_anchovy_sst"][[1]],',
                      ' E=3, Tp=0, columns="anchovy", target="np_sst",',
                      ' libSizes="10 70 10", sample=100, verbose=TRUE, ',
                      ' showPlot=TRUE) ')
    df = eval(parse(text=cmd))
}
if ( dev ) Examples()
