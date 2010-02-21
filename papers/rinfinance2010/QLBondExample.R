library(RQuantLib)

fixingDays <- 3
settlementDays <- 3

settlementDate <- as.Date('2008-09-18')
todaysDate <- settlementDate - fixingDays

#begin to set up bond discounting term structure
lengths <- c(5, 6, 7, 16, 48)
coupons <- c(0.02375, 0.04625, 0.03125, 0.04000, 0.04500)
marketQuotes <- c(100.390625, 106.21875, 100.59375, 101.6875, 102.140625)
dateparams <- list(settlementDays=settlementDays,
                   period=2, 
                   dayCounter="ActualActual", 
                   businessDayConvention ="Unadjusted")
curveparams <- list(method="ExponentialSplinesFitting", 
                    origDate=todaysDate)
bondDsctTsr <- FittedBondCurve(curveparams,
                               lengths,
                               coupons,
                               marketQuotes,
                               dateparams)

#begin to set up swap term structure
swp.tsr.params <- list(tradeDate=todaysDate,
                        settleDate=todaysDate+2,
                        dt=0.25,
                        interpWhat="discount",
                        interpHow="loglinear")
market.quotes <- list(d1w=0.043375,
                      d1m=0.031875,
                      d3m=0.0320375,
                      d6m=0.03385,
                      d9m=0.0338125,
                      d1y=0.0335125,                      
                      s2y=0.0295,
                      s3y=0.0323,
                      s5y=0.0359,
                      s10y=0.0412,
                      s15y=0.0433)
depoSwpTsr <- DiscountCurve(swp.tsr.params, market.quotes)

#Zero-Coupon Bond
zc.bond.param <- list(maturityDate=as.Date('2013-08-15'),
                      issueDate=as.Date('2003-08-15'),
                      redemption=116.92)
zc.bond.dateparam <- list(refDate=todaysDate,
                          settlementDays=settlementDays,
                          businessDayConvention='Following')
ZeroCouponBond(zc.bond.param, bondDsctTsr, zc.bond.dateparam)

#Fixed-Coupon Bond
fixed.bond.param <- list(maturityDate=as.Date('2017-05-15'),
                         issueDate=as.Date('2007-05-15'),
                         redemption=100,
                         effectiveDate=as.Date('2007-05-15'))
fixed.bond.dateparam <- list(settlementDays=settlementDays,
                            dayCounter='ActualActual',
                            period='Semiannual',
                            businessDayConvention='Unadjusted',
                            terminationDateConvention='Unadjusted',
                            dateGeneration='Backward',
                            endOfMonth=0)
fixed.bond.coupon <- c(0.045)
FixedRateBond(fixed.bond.param,
              fixed.bond.coupon,
              bondDsctTsr,
              fixed.bond.dateparam)                       
