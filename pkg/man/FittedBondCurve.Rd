\name{FittedBondCurve}
\alias{FittedBondCurve}
\alias{FittedBondCurve.default}
\alias{plot.FittedBondCurve}
\title{Returns the discount curve (with zero rates and forwards) given times}
\description{
  \code{FittedBondCurve} fits a term structure to a set of bonds
    using four different fitting methodologies. For more detail,
    see QuantLib/Example/FittedBondCurve.
}

\usage{
FittedBondCurve(curveparams, lengths, coupons, dateparams)
}

\arguments{
\item{curveparams}{curve parameters}
\item{lengths}{length of the bonds}
\item{coupons}{vector of rate}
\item{dateparams}{date parameter}
}
\value{
 \code{table}, a three columns date-zeroRate-discount data frame 
}
\examples{

lengths <- c(2,4,6,8,10,12,14,16,18,20,22,24,26,28,30)
coupons <- c( 0.0200, 0.0225, 0.0250, 0.0275, 0.0300,
              0.0325, 0.0350, 0.0375, 0.0400, 0.0425,
              0.0450, 0.0475, 0.0500, 0.0525, 0.0550 )
dateparams <- list(settlementDays=0, period="Annual", 
                   dayCounter="SimpleDayCounter", 
                  businessDayConvention ="Unadjusted")
curveparams <- list(method="ExponentialSplinesFitting", 
                    origDate = Sys.Date())
curve <- FittedBondCurve(curveparams, lengths, coupons, dateparams)
library(zoo)
z <- zoo(curve$table$zeroRates, order.by=curve$table$date)
plot(z)
}