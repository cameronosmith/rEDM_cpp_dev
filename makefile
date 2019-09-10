proj_name="rEDMNew"
build:
	rm rEDMNew_* -f 
	#make -C $(proj_name)/cppEDM/src clean
	make -C $(proj_name)/cppEDM/src
	R CMD build $(proj_name)
	#generate exports kinda hackish
	echo "Rcpp:::compileAttributes('./$(proj_name)')" | R --no-save
	#
	R CMD INSTALL $(proj_name)
	echo "library($(proj_name))" | R --save

