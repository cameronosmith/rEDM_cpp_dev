source("EDM.R")
#a test df
df <- data.frame(matrix(rnorm(200), nrow=100))
single_col_df <- df[,'X1',drop=FALSE]

tmp <- list(theta=1:5,E=1:10,tp=4)
#print(RunModelVariedParams(tmp))
simplex_out <- Simplex( df )
print(GetModelStats(simplex_out))
stop("not doing analysis rn")


#makeblock
made_block <- MakeBlock(df,E=2,columnNames=c("X1","X2"))
made_block <- MakeBlock(df,E=2)

#embed
embedded <- Embed(df,E=2)
embedded <- Embed(df,E=2,columns="X1")
embedded <- Embed(df,dataFile="tmp.csv",E=2,columns="X1")

#simplex
simplex_out <- Simplex( df )
simplex_out <- Simplex( df, columns="X1", lib=c(1,5),pred="3 7" )
simplex_out <- Simplex( df, columns="X1", lib="1 5",pred=(3:7) )
simplex_out <- Simplex( df$X1, columns="X1", lib="1 5",pred=(3:7) )
#waiting for general sol to range param simplex_out <- Simplex( df$X1, columns="X1", lib="1 5",pred=(3:7), E=1:10 )

#smap
smap_out 	<- SMap( df )
smap_out 	<- SMap( df, columns="X1", lib="1 100",pred="20 40")
smap_out 	<- SMap( df$X1, columns="X1", lib="1 5",pred=(3:7) )
smap_out 	<- SMap( df$X1, columns="X1", lib="1 5",pred=(3:7) )
print("waiting for general sol to range param") #smap_out 	<- SMap( df$X1, E=1:10, lib="1 5",pred=(3:7) )

#test multiview
block_gsp_df 	<- read.csv("../data/block_3sp.csv")
print("error this causes runtime err on cpp end: ")
	#multiview_out 	<- Multiview( block_gsp_df, columns="x_t",target="x_t",lib=1:100,pred=101:195 )
multiview_out 	<- Multiview( block_gsp_df, columns="x_t y_t z_t",target="x_t",lib=1:100,pred=101:195 )
#test ccm
ccm_out 	<- CCM( block_gsp_df, columns="x_t",target="x_t",libSizes="10 80 10",sample=10 )
#causes error because no sample provided #ccm_out 	<- CCM( block_gsp_df, columns="x_t",target="x_t",libSizes="10 80 10" )

#test embed dimension
embedded_dim <- EmbedDimension( df, lib="1 50",pred="51 90" )
embedded_dim <- EmbedDimension( df, columns="X1",lib="1 50",pred="51 90" )
embedded_dim <- EmbedDimension( df )

#predict interval
predicted_interval <- PredictInterval( df ) 
predicted_interval <- PredictInterval( df, columns="X1" ) 

#ERROR LOG:
#	CCM without sample size runtime err
#	CCM without diff col names runtime err
#	support Simplex/SMap with list of diff E's
