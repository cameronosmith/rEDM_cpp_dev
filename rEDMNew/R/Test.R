source("R/EDM.R")
#------------------------------------------------------------------------
# 
#------------------------------------------------------------------------
Examples <- function() {
    #Run examples

	tmp 	  <- data(package="rEDMNew")
	data_path <- tmp$results[1,]['LibPath']
	data_path <- paste(data_path,"rEDMNew/data",sep="/")

    dataFiles = c("TentMap_rEDM.csv",
                  "TentMapNoise_rEDM.csv",
                  "circle.csv",
                  "block_3sp.csv",
                  "sardine_anchovy_sst.csv" )
    # Create map of module dataFiles pathnames in Files
    Files <- vector()
    for (file in dataFiles ) {
        filename = paste(data_path,file,sep="/")
		print(filename)
        if ( file.exists(filename)  ) {
			Files <- c(Files,filename)
		}
        else 
            stop( paste( "Examples(): Failed to find data file ", 
                             file," in EDM package" ) )
	}
	pdf("rEDMDemoGraphs.pdf")
	#run embed dimension demo
	cat( paste('\nEmbedDimension( "./", TentMap_rEDM.csv", NULL, "", "",' ,
           '"1 100", "201 500", 1, 1, "TentMap", "", FALSE, FALSE, 4 )\n' ))
    df <- EmbedDimension( "", Files[1], NULL, "./", "",
					"1 100", "201 500", 1, 1,
					"TentMap", "", FALSE, FALSE, 4 )
	#run predict interval demo
	cat( paste('\nPredictInterval( "./", TentMap_rEDM.csv", NULL, "./", "",' ,
           '"1 100", "201 500", 2, 1, "TentMap", "", FALSE, FALSE, 4 )\n' ))
    df <- PredictInterval( "", Files[1], NULL, "./", "",
					"1 100", "201 500", 2, 1,
					"TentMap", "", FALSE, FALSE, 4 )
	#run predict nonlinear demo
	cat( paste('\nPredictNonlinear( "./", TentMapNoise_rEDM.csv", NULL, "./", "",' ,
           '"1 100", "201 500", 2, 1, 1, "TentMap", "", FALSE, FALSE, 4 )\n' ))
    df <- PredictNonlinear( "", Files[2], NULL, "./", "",
					"1 100", "201 500", 2, 1, 1,
					"TentMap", "", FALSE, FALSE, 4 )
	#run simplex demo, already embedded
	cat( paste('\nSimplex( "./", block_3sp.csv", NULL, "./", "",' ,
           '"1 99", "101 195", 3, 1, 0, 1, "x_t y_t z_t", "x_t", FALSE, TRUE, TRUE )\n' ))
    df <- Simplex	("", Files[4], NULL, "./", "",
				"1 99", "101 195", 3, 1, 0, 1,
				"x_t y_t z_t", "x_t", TRUE, TRUE, TRUE )
	#run simplex demo, not pre embedded
	cat( paste('\nSimplex( "./", block_3sp.csv", NULL, "./", "",' ,
           '"1 99", "100 195", 3, 1, 0, 1, "x_t", "x_t", TRUE, TRUE, TRUE )\n' ))
    df <- Simplex	("", Files[4], NULL, "./", "",
				"1 99", "101 195", 3, 1, 0, 1,
				"x_t", "x_t", FALSE, TRUE, TRUE )
	#run multiview demo
	cat( paste('\nMultiview( "./", block_3sp.csv", NULL, "./", "",' ,
		   '"1 100", "100 195", 3, 1, 0, 1, "x_t y_t z_t", "x_t", 0, FALSE, 4, TRUE )\n' ))
    df <- Multiview	("", Files[4], NULL, "./", "",
				"1 100", "101 195", 3, 1, 0, 1,
				"x_t y_t z_t", "x_t", 0, FALSE, 4, TRUE )
	#run smap demo
	cat( paste('\nSMap( "./", circle.csv", NULL, "./", "",' ,
		   '"1 100", "100 195", 2, 1, 0, 1, 4, "x y", "x", "","",TRUE, TRUE, TRUE )\n' ))
	
    df <- SMap("", Files[3], NULL, "./", "",
				"1 100", "101 195", 2, 1, 0, 1, 4,
				"x y ", "x", "","", TRUE, TRUE, TRUE )
	#run ccm demo
    cat( ('\nCCM( "./", "sardine_anchovy_sst.csv", NULL, "./", "",
           3, 0, 0, 1, "anchovy", "np_sst",
           "10 80 10", 100, TRUE, 0, TRUE, TRUE )' ))
    df = CCM( "", Files[ 5 ], NULL, "./", "", 
              3, 0, 0, 1, "anchovy", "np_sst",
              "10 80 10", 100, TRUE, 0, TRUE, TRUE )

}
