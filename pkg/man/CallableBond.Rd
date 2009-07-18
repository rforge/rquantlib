% $Id: CallableBond.Rd 87 2009-06-09 16:48:13Z knguyen $
\name{CallableBond}
\alias{CallableBond}
\alias{CallableBond.default}
\title{CallableBond evaluation}
\description{
  The \code{CallableBond} function evaluates a callable fixed rate bond 
  with a Hull White pricing engine 
  For more detail, see the source codes in quantlib's example, Examples/CallableBond/CallableBond.cpp

}
\usage{
\method{CallableBond}{default}(bondparams, hullWhite, coupon, dateparams )
\method{plot}{Bond}
\method{print}{Bond}
\method{summary}{Bond}
}
\arguments{
\item{bondparams}{bond paramters, \code{faceAmount}, \code{issueDate},\code{maturityDate}, 
            \code{redemption}, \code{callabilitySchedule} }
\item{hullWhite}{parameter to set up HullWhite, \code{term}, \code{alpha}, \code{sigma}, \code{gridIntervals}. For more detail, see QuantLib's doc on HullWhite. Currently, the codes only support a flat rate yield term structure. }
\item{coupon}{ vector of coupon rates}
\item{dateparams}{ date parameter of the bond}

}
\value{
  The \code{CallableBond} function returns an object of class
  \code{CallableBond} (which inherits from class 
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
  Please see any decent Finance textbook for background reading, and the
  \code{QuantLib} documentation for details on the \code{QuantLib}
  implementation.  
}
\references{\url{http://quantlib.org} for details on \code{QuantLib}.}

\author{Khanh Nguyen \email{knguyen@cs.umb.edu} for the inplementation; Dirk Eddelbuettel \email{edd@debian.org} for the \R interface;
  the QuantLib Group for \code{QuantLib}}
\note{The interface might change in future release as \code{QuantLib}
  stabilises its own API.}
\examples{
params <- list(tradeDate=as.Date("2007-10-16"),
               settleDate=as.Date("2007-10-16"),
               dt=.25,
               interpWhat="discount",
               interpHow="loglinear")
times <- seq(0,10,.1)
#termStructure <- DiscountCurve(params, list(flat=0.055), times)
#HullWhite <- list(term = termStructure, alpha = 0.03, sigma = 0.01
#                  , gridIntervals = 40)

HullWhite <- list(term = 0.055, alpha = 0.03, sigma = 0.01,
                  gridIntervals = 40)
Price <- rep(as.double(100),24)
Type <- rep(as.character("C"), 24)
Date <- seq(as.Date("2006-09-15"), by = '3 months', length = 24)
callSch <- data.frame(Price, Type, Date)
callSch$Type <- as.character(callSch$Type)

bondparams <- list(faceAmount=100, issueDate = as.Date("2004-09-16"),
                   maturityDate=as.Date("2012-09-16"), redemption=100,
                   callabilitySchedule = callSch)
dateparams <- list(settlementDays=3, calendar="us", 
                   dayCounter = "ActualActual", 
                   period="Quarterly", 
                   businessDayConvention = "Unadjusted", 
                   terminationDateConvention= "Unadjusted")
coupon <- c(0.0465)

CallableBond(bondparams, HullWhite, coupon, dateparams)

}
\keyword{misc}

