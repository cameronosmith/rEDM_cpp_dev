#file to export the csv's by reading them in here

# run first block if just running code in this dir 
dev <- file.exists("Aux.R")
prefix          <- if( dev ) "../data/" else "data/"

sampleData      <- list()

dataFileNames   <- list(c("TentMap_rEDM.csv","TentMap"),
                        c("TentMapNoise_rEDM.csv","TentMapNoise"),
                        c("circle.csv","circle"),
                        c("block_3sp.csv","block_3sp"),
                        c("sardine_anchovy_sst.csv","sardine_anchovy_sst") 
                    )


for ( datafilePair in dataFileNames ) {

    data <- read.csv( paste0( prefix, datafilePair[1] ) )
    sampleData[[ datafilePair[2] ]] = data

}

