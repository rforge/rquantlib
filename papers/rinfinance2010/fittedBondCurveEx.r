lengths <- c(2,4,6,8,10,12,14,16,18,20,22,24,26,28,30)
coupons <- c(0.0200, 0.0225, 0.0250, 0.0275, 0.0300,
         	 0.0325, 0.0350, 0.0375, 0.0400, 0.0425,
             0.0450, 0.0475, 0.0500, 0.0525, 0.0550 )
marketQuotes <- rep(100, length(lengths))
dateparams <- list(settlementDays=0, period="Annual", 
                             dayCounter="ActualActual", 
                             businessDayConvention ="Unadjusted")
curveparams <- list(method="ExponentialSplinesFitting", 
                                origDate = Sys.Date())
curve <- FittedBondCurve(curveparams, lengths, coupons, marketQuotes, dateparams)
library(zoo)
z <- zoo(curve$table$zeroRates, order.by=curve$table$date)
plot(z)
