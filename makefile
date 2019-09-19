proj_name="rEDMNew"
build:
	rm rEDMNew_* -f 
	R CMD build $(proj_name)
	#
check:
	R CMD check "$(proj_name)_1.0.tar.gz" --no-manual

