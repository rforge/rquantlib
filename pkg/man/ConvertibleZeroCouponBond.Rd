% $Id: ConvertibleZeroCouponBond 84 2009-06-19 knguyen $
\name{ConvertibleZeroCouponBond}
\alias{ConvertibleZeroCouponBond}
\alias{ConvertibleZeroCouponBond.default}
\title{Convertible Zero Coupon Bond evaluation}
\description{
Setup and evaluate a ConvertibleZeroCouponBond. For detail, see QuantLib/test-suite/convertiblebond.cpp
}
\usage{
\method{ConvertibleZeroCouponBond}{default}(bondparams, process, dateparams)
\method{plot}{Bond}
\method{print}{Bond}
\method{summary}{Bond}
}
\arguments{
\item{bondparams}{a list specifying the basic arguments of the convertible 
            zero bond , \code{exercise} (either 'eu' or 'am'), \code{faceAmount}, \code{issueDate},\code{maturityDate}, 
            \code{redemption}, \code{issueDate}, \code{maturityDate}, 
            \code{dividendScheduele}, \code{callabilitySchedule}, 
            \code{creditSpread}, \code{conversitionRatio}}
\item{process}{ a list that specifies necessary arguments to construct
a pricing engine for this bond. \code{underlying} and \code{volatility} must be
double value, \code{dividendYield} and \code{riskFreeRate} are DiscountCurve objects}
\item{dateparams}{date parameters}
}
\value{
  The \code{ConvertibleZeroCouponBond} function returns an object of class
  \code{ConvertibleZeroCouponBond} (which inherits from class 
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
\references{ 
\url{http://quantlib.org/reference/class_quant_lib_1_1_convertible_zero_coupon_bond.html}
}
\author{
Khanh Nguyen \email{knguyen@cs.umb.edu} for the inplementation; Dirk Eddelbuettel \email{edd@debian.org} for the \R interface;
  the QuantLib Group for \code{QuantLib}
}
\examples{
#this follow an example in test-suite/convertiblebond.cpp for ConvertibleZeroCouponBond
params <- list(tradeDate=Sys.Date()-2,
               settleDate=Sys.Date(),
               dt=.25,
               interpWhat="discount",
               interpHow="loglinear")
times <- seq(0,10,.1)


dividendYield <- DiscountCurve(params, list(flat=0.02), times)
riskFreeRate <- DiscountCurve(params, list(flat=0.05), times)

dividendSchedule <- data.frame(Type=character(0), Amount=numeric(0),
                            Rate = numeric(0), Date = as.Date(character(0)))
callabilitySchedule <- data.frame(Price = numeric(0), Type=character(0),
                          Date = as.Date(character(0)))

process <- list(underlying=50, divYield = dividendYield,
                rff = riskFreeRate, volatility=0.15)

today <- Sys.Date()
bondparams <- list(exercise="am", faceAmount=100, divSch = dividendSchedule, 
                   callSch = callabilitySchedule, redemption=100, 
                   creditSpread=0.005, conversionRatio = 0.0000000001, 
                   issueDate=as.Date(today+2), 
                   maturityDate=as.Date(today+3650))
dateparams <- list(settlementDays=3, 
                   dayCounter="Actual360", 
                   period = "Once", calendar = "us", 
                   businessDayConvention="Following", 
                   todayDate=as.Date(today))

ConvertibleZeroCouponBond(bondparams, process, dateparams)

}
