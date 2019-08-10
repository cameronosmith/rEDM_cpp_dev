if ( FALSE ) {
    source("EDM.R")
    source("ExportData.R")
} else {
    source("R/EDM.R")
    source("R/ExportData.R")
}
#------------------------------------------------------------------------
# 
#------------------------------------------------------------------------
Examples <- function() {

	#run embed dimension demo
	cat( paste('\nEmbedDimension( "./", TentMap_rEDM.csv", NULL, "", "",' ,
           '"1 100", "201 500", 1, 1, "TentMap", "", FALSE, FALSE, 4 )\n' ))
    df <- EmbedDimension( "", "", TentMap, "", "",
					"1 100", "201 500", 1, 1,
					"TentMap", "", FALSE, FALSE, 4, TRUE )
	#run predict interval demo
	cat( paste('\nPredictInterval( "./", TentMap_rEDM.csv", NULL, "./", "",' ,
           '"1 100", "201 500", 2, 1, "TentMap", "", FALSE, FALSE, 4 )\n' ))
    df <- PredictInterval( "", "", TentMap, "./", "",
					"1 100", "201 500", 2, 1,
					"TentMap", "", FALSE, FALSE, 4 )
	#run predict nonlinear demo
	cat( paste('\nPredictNonlinear("./","TentMapNoise_rEDM.csv",NULL,"./","",',
           '"1 100", "201 500", 2, 1, 1, "TentMap", "", FALSE, FALSE, 4 )\n' ))
    df <- PredictNonlinear( "", "", TentMapNoise, "./", "",
					"1 100", "201 500", 2, 1, 1,
					"TentMap", "", FALSE, FALSE, 4 )
	#run simplex demo, already embedded
	cat( paste('\nSimplex( "./", block_3sp.csv", NULL, "./", "",' ,
           '"1 99", "101 195", 3, 1, 0, 1, "x_t y_t z_t", "x_t", FALSE, TRUE, TRUE )\n' ))
    df <- Simplex	("", "", block_3sp, "./", "",
				"1 99", "101 195", 3, 1, 0, 1,
				"x_t y_t z_t", "x_t", TRUE, TRUE, FALSE, TRUE )
	#run simplex demo, not pre embedded
	cat( paste('\nSimplex( "./", block_3sp.csv", NULL, "./", "",' ,
           '"1 99", "100 195", 3, 1, 0, 1, "x_t", "x_t", TRUE, FALSE, TRUE )\n' ))
    df <- Simplex	("", "", block_3sp, "./", "",
				"1 99", "101 195", 3, 1, 0, 1,
				"x_t", "x_t", FALSE, TRUE, FALSE, TRUE )
	#run multiview demo
	cat( paste('\nMultiview( "./", block_3sp.csv", NULL, "./", "",' ,
		   '"1 100", "100 195", 3, 1, 0, 1, "x_t y_t z_t", "x_t", 0, FALSE, 4, TRUE )\n' ))
    df <- Multiview	("", "", block_3sp, "./", "",
				"1 100", "101 195", 3, 1, 0, 1,
				"x_t y_t z_t", "x_t", 0, FALSE, 4, TRUE )
	#run smap demo
	cat( paste('\nSMap( "./", circle.csv", NULL, "./", "",' ,
		   '"1 100", "100 195", 2, 1, 0, 1, 4, "x y", "x", "","",TRUE, TRUE, TRUE )\n' ))
	
    df <- SMap("", "", circle, "./", "",
				"1 100", "101 195", 2, 1, 0, 1, 4,
				"x y ", "x", "","", TRUE, TRUE, TRUE, TRUE )
	#run ccm demo
    cat( ('\nCCM( "./", "sardine_anchovy_sst.csv", NULL, "./", "",
           3, 0, 0, 1, "anchovy", "np_sst",
           "10 80 10", 100, TRUE, 0, TRUE, TRUE )' ))
    df <- CCM( "", "",sardine_anchovy_sst, "./", "", 
              3, 0, 0, 1, "anchovy", "np_sst",
              "10 80 10", 100, TRUE, 0, TRUE, TRUE )
}
Examples()
