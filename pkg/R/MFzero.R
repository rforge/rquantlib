mf.zeroprice <- function(Yield, Settle, Maturity, Period=2, Basis=6, EndMonthRule=0){
  val <- 0
  val <- .Call("zeroprice",
               list(Yield = as.double(Yield),
                    Settle = Settle,
                    Maturity = Maturity,
                    Period = as.double(Period),
                    Basis = as.double(Basis),
                    EMR = as.double(EndMonthRule)),
               PACKAGE='RQuantLib')
  val
}

mf.zeroyield <- function(Price, Settle, Maturity, Period=2, Basis=6, EndMonthRule=0){
  val <- 0
  val <- .Call("zeroyield",
               list(Price = as.double(Price),
                    Settle = Settle,
                    Maturity = Maturity,
                    Period = as.double(Period),
                    Basis = as.double(Basis),
                    EMR = as.double(EndMonthRule)),
               PACKAGE='RQuantLib')
  val
}
