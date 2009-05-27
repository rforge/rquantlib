
stopifnot(require(RQuantLib))

## values from Quantlib's test-suite
## Reference: Haug, Option Pricing Formulas, McGraw-Hill, 1998
##
## and generally sourced from the code in the test-suite/
## directory of the QuantLib distribution

## europeanoption.cpp:  call value == 2.1334
print(EuropeanOption("call", underlying=60, strike=65, div=0, riskFree=0.08,
                     maturity=0.25, vol=0.3), digits=5)
## europeanoption.cpp:  put value == 2.4648
print(EuropeanOption("put", underlying=100, strike=95, div=0.05, riskFree=0.1,
                     maturity=0.5, vol=0.2), digits=5)

## europeanoption.cpp:  call delta == 0.5946
print(EuropeanOption("call", underlying=105, strike=100,div=0.1,riskFree=0.1,
                     maturity=0.5, vol=0.36), digits=4)
## europeanoption.cpp:  put delta == -0.3566
print(EuropeanOption("put", underlying=105, strike=100,div=0.1,riskFree=0.1,
                     maturity=0.5, vol=0.36), digits=4)

## europeanoption.cpp:  call gamma == 0.0278
print(EuropeanOption("call", underlying=55, strike=60,div=0.0,riskFree=0.1,
                     maturity=0.75, vol=0.30), digits=4)
## europeanoption.cpp:  put gamma == 0.0278
print(EuropeanOption("put", underlying=55, strike=60,div=0.0,riskFree=0.1,
                     maturity=0.75, vol=0.30), digits=4)

## europeanoption.cpp:  call vega == 18.9358
print(EuropeanOption("call", underlying=55, strike=60,div=0.0,riskFree=0.1,
                     maturity=0.75, vol=0.30), digits=4)
## europeanoption.cpp:  put vega == 18.9358
print(EuropeanOption("put", underlying=55, strike=60,div=0.0,riskFree=0.1,
                     maturity=0.75, vol=0.30), digits=4)


## americanoption.cpp:  call value == 10.0089 -- we show 10.00606
print(AmericanOption("call", underlying=110, strike=100, div=0.1, riskFree=0.1,
                     maturity=0.1, vol=0.15), digits=5)
## americanoption.cpp:  put value == 0.3159
print(AmericanOption("call", underlying=90, strike=100, div=0.1, riskFree=0.1,
                     maturity=0.1, vol=0.25), digits=5)


## barrier: down and out call == 9.0246
print(BarrierOption("downout", barrier=95, rebate=3, type="call",
                    strike=90, underlying=100, div=0.04, riskF=0.08,
                    mat=0.5, vol=0.25), digits=4)
## barrier: down and in call == 7.7627
print(BarrierOption("downin", barrier=95, rebate=3, type="call",
                    strike=90, underlying=100, div=0.04, riskF=0.08,
                    mat=0.5, vol=0.25), digits=4)


## binary aka digital: put == 2.6710
print(BinaryOption(binType="cash", type="put", excType="european",
                   strike=80, underl=100, div=0.06, r=0.06,
                   mat=0.75, vol=0.35, cash=10), digits=4)

## asianoption.cpp:  put == 4.6922 (from testAnalyticContinuousGeometricAveragePrice())
print( AsianOption("geometric", "put", underlying=80, strike=85, div=-0.03, riskFree=0.05, maturity=0.25, vol=0.2))

## bond.cpp: The parameters are taken from test-suite/bond.cpp. Clean price = 88.55173
print( ZeroCouponBond(1, "us", 1000000, as.Date("2008-11-30"), 4 , 100, as.Date("2004-11-30"), as.Date("2004-11-24"), 0.03))

## bond.cpp: examples from Fixed Income page of Matlab
print(ZeroYield(95, 100, as.Date("1993-6-24"), as.Date("1993-11-1")))

## bond.cpp: test theoretical price of bond by its yield
print(ZeroPriceByYield(0.1478, 100, as.Date("1993-6-24"), as.Date("1993-11-1")))
