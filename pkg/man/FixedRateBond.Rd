% $Id$
\name{FixedRateBond}
\alias{FixedRateBond}
\alias{FixedRateBond.default}
\title{Fixed rate bond evaluation using discount curve solution}
\description{
  The \code{FixedRateBond} function evaluates a fixed rate bond using discount curve. 
  More specificly, the calculation is done by DiscountingBondEngine from QuantLib.
  The clean price of the bond is returned. 
  For more detail, see the source codes in quantlib's test-suite. test-suite/bond.cpp

}
\usage{
\method{FixedRateBond}{default}(bond, rates, discountCurve, dateparams )
\method{plot}{Bond}
\method{print}{Bond}
\method{summary}{Bond}
}
\arguments{
\item{bond}{a list specifying the basic arguments of the fixed rate bond,
            \code{faceAmount}, \code{issueDate},\code{maturityDate}, 
            \code{redemption}, \code{effectiveDate}}
\item{rates}{a double vector of rates}
\item{discountCurve}{ A list specifying the discount curve 
    that will be used in pricing of the bond. There are two way to
    specify a discount curve. One is a flat curve, which can be specify
    using a list of two values \code{todayDate} and \code{riskFreeRate}
    . Another way is to construct a curve from market data
    using a list of three values, \code{params} , \code{tsQuotes},
    \code{times}. For more detail, see example or the discountCurve function
}
\item{dateparams}{ A list specifying date paramters, \code{settlemenDays},
    \code{calendar} - a string 'us' or 'uk', \code{businessDayConvention}- an integer,
    \code{dayCounter}, \code{period}
    \code{terminationDateConvention} - an integer,
    \code{dateGeneration} - an integer,
    \code{endOfMonth} - value 1 or 0.  For more detail, see \link{Enum} and 
    the quantlib docs for FixedRateBond
}

}
\value{
  The \code{FixedRateBond} function returns an object of class
  \code{FixedRateBond} (which inherits from class 
  \code{Bond}). It contains a list with the following
  components:
  \item{cleanValue}{clean value of the bond}
  \item{cashflows}{display the cashflow of the bond}
}
\details{
  A discount curve is built to calculate the bond value. 

  Please see any decent Finance textbook for background reading, and the
  \code{QuantLib} documentation for details on the \code{QuantLib}
  implementation.  
}
\references{\url{http://quantlib.org} for details on \code{QuantLib}.}

\author{Khanh Nguyen \email{knguyen@cs.umb.edu}; Dirk Eddelbuettel \email{edd@debian.org} for the \R interface;
  the QuantLib Group for \code{QuantLib}}
\note{The interface might change in future release as \code{QuantLib}
  stabilises its own API.}


\examples{

bond <- list(faceAmount=100, issueDate=as.Date("2004-11-30"),
             maturityDate=as.Date("2008-11-30"), redemption=100, 
             effectiveDate=as.Date("2004-11-30"))
dateparams <- list(settlementDays=1, calendar="us", dayCounter = 1, period=3, 
                   businessDayConvention = 4, terminationDateConvention=4,
                   dateGeneration=1, endOfMonth=1)
curve <- list(todayDate=as.Date("2004-11-04"), riskFreeRate=0.03)
rates <- c(0.02875)
                       
FixedRateBond(bond, rates, curve, dateparams)

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
FixedRateBond(bond, rates, curve, dateparams)


}
\keyword{misc}

