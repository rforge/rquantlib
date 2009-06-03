% $Id: ZeroBondCC.Rd 78 2009-05-30 18:31:48Z edd $
\name{ZeroBondCC}
\alias{ZeroBondCC}
\alias{ZeroBondCC.default}
\title{Zero-oupon bond evaluation using discount curve solution}
\description{
  The \code{ZeroBondCC} function evaluations a zero-coupon plainly using the spot term structure of interest
  rates that is contructed based on input market data including the settlement date,
  deposit rates, futures prices, FRA rates, or swap rates, in various
  combinations
  More specificly, the calculation is done by DiscountingBondEngine from QuantLib.
  The NPV, clean price, dirty price, accrued interest, yield and cash flows of the bond is returned. 
  For more detail, see the source codes in quantlib's test-suite. test-suite/bond.cpp

}
\usage{
\method{ZeroBondCC}{default}(settlementDays, calendar, faceAmount, maturityDate,
                           businessDayConvention, redemption, issueDate, todayDate, params, tsQuotes, times)

\method{plot}{Bond}
\method{print}{Bond}
\method{summary}{Bond}
}
\arguments{
  \item{settlementDays}{an integer, 1 for T+1, 2 for T+2, etc...}
  \item{calendar}{Business Calendar. Either \code{us} or \code{uk}}
  \item{faceAmount}{face amount of the bond}
  \item{maturityDate}{a string, that specifies maturity date in form \code{dd-mm-yyyy} or \code{dd/mm/yyyy}}
  \item{businessDayConvention}{These conventions specify the algorithm used to adjust a date in case it is not a valid business day. See quantlib for more detail}
  \item{redemption}{redemption when the bond expires}
  \item{issueDate}{date the bond is issued}
  \item{todayDate}{neccessary to for building the discount curve. Different todayDate will return different values of the bond}
  \item{params}{A list specifying the \code{tradeDate} (month/day/year),
    \code{settleDate}, forward rate
    time span \code{dt}, and two curve
    construction options: \code{interpWhat} (with possible values
    \code{discount}, \code{forward}, and \code{zero}) and
    \code{interpHow} (with possible values \code{linear},
    \code{loglinear}, and \code{spline}). \code{spline} here means cubic spline
    interpolation of the \code{interpWhat} value.
  }
  \item{tsQuotes}{Market quotes used to construct the spot term
    structure of interest rates. Must be a list of name/value pairs,
    where the currently recognized names are:
    \tabular{ll}{
      \code{flat} \tab rate for a flat yield curve\cr
      \code{d1w}  \tab 1-week deposit rate\cr
      \code{d1m}  \tab 1-month deposit rate\cr
      \code{d3m}  \tab 3-month deposit rate\cr
      \code{d6m}  \tab 6-month deposit rate\cr
      \code{d9m}  \tab 9-month deposit rate\cr
      \code{d1y}  \tab 1-year deposit rate\cr
      \code{s2y}  \tab 2-year swap rate\cr
      \code{s3y}  \tab 3-year swap rate\cr
      \code{s5y}  \tab 5-year swap rate\cr
      \code{s10y} \tab 10-year swap rate\cr
      \code{s15y} \tab 15-year swap rate\cr
      \code{s20y} \tab 20-year swap rate\cr
      \code{s30y} \tab 30-year swap rate\cr
      \code{fut1}--\code{fut8} \tab 3-month futures contracts\cr
      \code{fra3x6} \tab 3x6 FRA\cr
      \code{fra6x9} \tab 6x9 FRA\cr
      \code{fra6x12}\tab 6x12 FRA
    }
    Here rates are expected as fractions (so 5\% means .05).
    If \code{flat} is specified it must be the first and only item in
    the list. The eight futures correspond to the first eight IMM
    dates. The maturity dates of the instruments specified need not be
    ordered, but they must be distinct.
    }
  \item{times}{A vector of times at which to return the discount
    factors, forward rates, and zero rates. Times must be specified such
    that the largest time plus \code{dt} does not exceed the longest
    maturity of the instruments used for calibration (no extrapolation).
    }
}
\value{
  The \code{ZeroBondCC} function returns an object of class
  \code{ZeroBondCC} (which inherits from class 
  \code{Bond}). It contains a list with the following
  components:
  \item{NPV}{net present value of the bond}
  \item{cleanPrice}{price price of the bond}
  \item{dirtyPrice}{dirty price of the bond}
  \item{accruedAmount}{accrued amount of the bond}
  \item{yield}{yield of the bond}
  \item{cashFlows}{cash flows of the bond}
}
\details{
  A discount curve is built to calculate the bond value. 

  Please see any decent Finance textbook for background reading, and the
  \code{QuantLib} documentation for details on the \code{QuantLib}
  implementation.  
}
\references{\url{http://quantlib.org} for details on \code{QuantLib}.}
\author{Dirk Eddelbuettel \email{edd@debian.org} for the \R interface;
  the QuantLib Group for \code{QuantLib}}
\note{The interface might change in future release as \code{QuantLib}
  stabilises its own API.}


\examples{

params <- list(tradeDate=as.Date('2002-2-15'),
               settleDate=as.Date('2002-2-19'),
               dt=.25,
               interpWhat="discount",
               interpHow="loglinear")

tsQuotes <- list(d1w  =0.0382,
                 d1m  =0.0372,
                 fut1=96.2875,
                 fut2=96.7875,
                 fut3=96.9875,
                 fut4=96.6875,
                 fut5=96.4875,
                 fut6=96.3875,
                 fut7=96.2875,
                 fut8=96.0875,
                 s3y  =0.0398,
                 s5y  =0.0443,
                 s10y =0.05165,
                 s15y =0.055175)

times <- seq(0,10,.1)


# simple call with unnamed parameters
ZeroBondCC(1, "us", 1000000, as.Date("2008-11-30"), 4 , 100, as.Date("2004-11-30"), as.Date("2004-11-24"), params, tsQuotes, times )
}
\keyword{misc}

