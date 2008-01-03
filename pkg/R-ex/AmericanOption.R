### Name: AmericanOption
### Title: American Option evaluation using Finite Differences
### Aliases: AmericanOption AmericanOption.default
### Keywords: misc

### ** Examples

# simple call with unnamed parameters
AmericanOption("call", 100, 100, 0.02, 0.03, 0.5, 0.4)
# simple call with some explicit parameters
AmericanOption("put", strike=100, volatility=0.4, 100, 0.02, 0.03, 0.5)



