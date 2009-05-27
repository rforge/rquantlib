% $Id: ZeroCouponBond.Rd,v 1.5 2006/11/11 04:12:45 edd Exp $
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
\method{FixedRateBond}{default}( settlementDays=1, faceAmount, 
                                 effectiveDate, maturityDate,
                                 period, calendar="us", 
                                 rates, dayCounter=2,
                                 businessDayConvention=0, redemption=100, 
                                 issueDate, riskFreeRate, todayDate)

\method{plot}{Bond}
\method{print}{Bond}
\method{summary}{Bond}
}
\arguments{
  \item{settlementDays}{an integer, 1 for T+1, 2 for T+2, etc...}
  \item{effectiveDate}{bond's effective date}
  \item{maturityDate}{bond's maturity date}
  \item{period}{frequency of events,0=NoFrequency, 1=Once, 2=Annual, 3=Semiannual, 4=EveryFourthMonth, 5=Quarterly, 6=Bimonthly ,7=Monthly ,8=EveryFourthWeely,9=Biweekly, 10=Weekly, 11=Daily. For more information, see QuantLib's Frequency class }
  \item{calendar}{Business Calendar. Either \code{us} or \code{uk}}
  \item{faceAmount}{face amount of the bond}
  \item{rates}{vector of rates}
  \item{businessDayConvention}{convention used to adjust a date in case it is not a valid business day. See quantlib for more detail. 0 = Following, 1 = ModifiedFollowing, 2 = Preceding, 3 = ModifiedPreceding, other = Unadjusted}
  \item{dayCounter}{day count convention. 0 = Actual360(), 1 = Actual365Fixed(), 2 = ActualActual(), 3 = Business252(), 4 = OneDayCounter(), 5 = SimpleDayCounter(), all other = Thirty360(). For more information, see QuantLib's DayCounter class}
  \item{redemption}{redemption when the bond expires}
  \item{issueDate}{date the bond is issued}
  \item{todayDate}{neccessary to for building the discount curve. Different todayDate will return different values of the bond}
  \item{riskFreeRate}{Risk-free rate}
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
\author{Dirk Eddelbuettel \email{edd@debian.org} for the \R interface;
  the QuantLib Group for \code{QuantLib}}
\note{The interface might change in future release as \code{QuantLib}
  stabilises its own API.}


\examples{
# simple call with unnamed parameters
FixedRateBond(, 100000, as.Date("2004-11-30"), as.Date("2008-11-30"), 3, , c(0.02875), , , ,as.Date("2004-11-30"), 0.03, as.Date("2004-11-22"))
}
\keyword{misc}

