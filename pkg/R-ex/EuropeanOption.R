### Name: EuropeanOption
### Title: European Option evaluation using Closed-Form solution
### Aliases: EuropeanOption EuropeanOption.default
### Keywords: misc

### ** Examples

# simple call with unnamed parameters
EuropeanOption("call", 100, 100, 0.01, 0.03, 0.5, 0.4)
# simple call with some explicit parameters, and slightly increased vol:
EuropeanOption(type="call", underlying=100, strike=100, dividendYield=0.01, 
riskFreeRate=0.03, maturity=0.5, volatility=0.5)



