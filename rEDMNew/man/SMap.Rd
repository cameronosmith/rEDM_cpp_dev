\name{SMap}
\alias{SMap}
\title{SMap forecasting}
\usage{
SMap(pathIn = "./", dataFile = "", dataFrame = NULL, pathOut = "./", 
  predictFile = "", lib = "", pred = "", E = 0, Tp = 1, knn = 0, tau = 1, 
  theta = 0, exclusionRadius = 0, columns = "", target = "", smapFile = "", 
  jacobians = "", embedded = FALSE, const_pred = FALSE, verbose = FALSE,
  showPlot = FALSE)  
}
\arguments{
\item{pathIn}{path to \code{dataFile}.}

\item{dataFile}{.csv format data file name. The first column must be a time
index or time values. The first row must be column names.}

\item{dataFrame}{input data.frame. The first column must be a time
index or time values. The columns must be named.}

\item{pathOut}{path for \code{predictFile} containing output predictions.}

\item{predictFile}{prediction output file name.}

\item{lib}{string with start and stop indices of input data rows used to
create the library of observations. A single contiguous range is supported.}

\item{pred}{string with start and stop indices of input data rows used for
predictions. A single contiguous range is supported.}

\item{E}{embedding dimension.}

\item{Tp}{prediction horizon (number of time column rows).}

\item{knn}{number of nearest neighbors. If knn=0, knn is set to E+1.}

\item{tau}{lag of time delay embedding specified as number of
time column rows.}

\item{theta}{neighbor localisation exponent.}

\item{exclusionRadius}{excludes vectors from the search space of nearest 
neighbors if their relative time index is within exclusionRadius.}

\item{columns}{string of whitespace separated column name(s) in the
input data used to create the library.}

\item{target}{column name in the input data used for prediction.}

\item{smapFile}{output file containing SMap coefficients.}

\item{jacobians}{not used.}

\item{embedded}{logical specifying if the input data are embedded.}

\item{const_pred}{logical to add a \emph{constant predictor} column to the
output. The constant predictor is X(t+1) = X(t).}

\item{verbose}{logical to produce additional console reporting.}

\item{showPlot}{logical to plot results.}
}

\value{
  A named list with two data.frames \code{[[predictions, coefficients]]}.
  \code{predictions} has columns \code{Observations, Predictions}.  If
  \code{const_pred} is TRUE the column \code{Const_Predictions} is added.
  The first column contains time values.

  \code{coefficients} data.frame has time values in the first column.
  Columns 2 through E+2 (E+1 columns) are the SMap coefficients. 
}

\references{Sugihara G. 1994. Nonlinear forecasting for the classification of natural time series. Philosophical Transactions: Physical Sciences and Engineering, 348 (1688):477-495.}

\description{
  \code{\link{SMap}} performs time series forecasting based on localised
  (or global) nearest neighbor projection in the time series phase space as
  described in \cite{Sugihara 1994}. 
}

\details{
  If embedded is \code{FALSE}, the data \code{column(s)} are embedded to
  dimension \code{E} with time lag \code{tau}. This embedding forms an
  E-dimensional phase space for the \code{\link{SMap}} projection.
  If embedded is \code{TRUE}, the data are assumed to contain an
  E-dimensional embedding with E equal to the number of \code{columns}.
  Predictions are made using leave-one-out cross-validation, i.e.
  observation vectors are excluded from the prediction regression.

  In contrast to \code{\link{Simplex}}, \code{\link{SMap}} uses all
  available neighbors and then weights them with an exponential decay
  in phase space distance with exponent \code{theta}.  \code{theta}=0
  uses all neighbors corresponding to a global autoregressive model.
  As \code{theta} increases, neighbors closer in vicinity to the
  observation are considered. 
}

\note{
\code{\link{SMap}} should be called with columns explicity correspondng to
dimensions E. This means that if a multivariate data set is used
(number of \code{columns} > 1) it should Not be an embedding from
\code{\link{Embed}} since \code{\link{Embed}} will add lagged
coordinates for each variable. The added columns will not correspond to
the intended dimensions in the matrix inversion and prediction
reconstruction. In this case, use the \code{embedded = TRUE} flag so
that the columns selected and their coefficients correspond to the
proper dimension.
}

\examples{
data(circle)
L = SMap( dataFrame=circle,lib="1 100", pred="110 190", theta=4, E=2,
embedded=TRUE,columns="x y", target="x")

}
