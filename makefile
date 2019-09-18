proj_name="rEDMNew"
build:
	rm rEDMNew_* -f 
	R CMD build $(proj_name)
	#
	R CMD INSTALL $(proj_name) #_*.tar.gz
	echo "library($(proj_name))" | R --save

check:
	R CMD check "$(proj_name)_1.0.tar.gz" --no-manual

