% $Id$
\name{ZeroCouponBond}
\alias{ZeroCouponBond}
\alias{ZeroCouponBond.default}
\title{Zero-oupon bond evaluation using discount curve solution}
\description{
  The \code{ZeroCouponBond} function evaluations a zero-coupon plainly using discount curve. 
  More specificly, the calculation is done by DiscountingBondEngine from QuantLib.
  The clean price of the bond is returned. 
  For more detail, see the source codes in quantlib's test-suite. test-suite/bond.cpp

}
\usage{
\method{ZeroCouponBond}{default}(settlementDays, calendar, faceAmount, maturityDate,
                           businessDayConvention, redemption, issueDate, todayDate, riskFreeRate)

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
  \item{riskFreeRate}{Risk-free rate}
}
\value{
  The \code{ZeroCouponBond} function returns an object of class
  \code{ZeroCouponBond} (which inherits from class 
  \code{Bond}). It contains a list with the following
  components:
  \item{clean value}{clean value of the bond}
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
# simple call with unnamed parameters
ZeroCouponBond(1, "us", 1000000, as.Date("2008-11-30"), 4 , 100, as.Date("2004-11-30"), as.Date("2004-11-24"), 0.03)
}
\keyword{misc}

