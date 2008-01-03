### Name: ImpliedVolatility
### Title: Base class for option-price implied volatility evalution
### Aliases: ImpliedVolatility print.ImpliedVolatility
###   summary.ImpliedVolatility
### Keywords: misc

### ** Examples

impVol<-EuropeanOptionImpliedVolatility("call", value=11.10, strike=100, volatility=0.4, 100, 0.01, 0.03, 0.5)
print(impVol)
summary(impVol)



