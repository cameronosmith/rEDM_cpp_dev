library( rEDMNew )

df <- data.frame(matrix(rnorm(20), nrow=10))
#colnames(df) <- c("a","b")

rcpp_testing( df )
