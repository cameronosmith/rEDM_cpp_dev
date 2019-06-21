proj_name="rEDMNew"
build:
	R CMD build $(proj_name)
	#generate exports kinda hackish
	rm -f $(proj_name)/src/RcppExports.*
	echo "Rcpp:::compileAttributes('./$(proj_name)')" | R --no-save
	#
	R CMD INSTALL $(proj_name)
	echo "library($(proj_name))" | R --save
run:
	Rscript basicTest_rInterfaceEDM.R

