mf.cdai <- function(CouponRate, Settle, Maturity, IssueDate, Basis = 6){
  100 * CouponRate * yearFraction(IssueDate, Settle, Basis)
}


mf.cdprice <- function(Yield, CouponRate, Settle, Maturity,
                    IssueDate, Basis = 6){
 Tis <- yearFraction(IssueDate, Settle, Basis)
 Tim <- yearFraction(IssueDate, Maturity, Basis)
 Tsm <- yearFraction(Settle, Maturity, Basis)

 AccrInt <- CouponRate * Tis
 Price <- 100 * ((1 + CouponRate * Tim) / ( 1 + Yield * Tsm) - AccrInt);
 ret <- list(AccrtInt = AccrInt, Price = Price)
 ret
}

mf.cdyield <- function(Price, CouponRate, Settle, Maturity, IssueDate, Basis = 6){
  Tis <- yearFraction(IssueDate, Settle, Basis)
  Tim <- yearFraction(IssueDate, Maturity, Basis)
  Tsm <- yearFraction(Settle, Maturity, Basis)

  AccrInt <- CouponRate * Tis;
  
  B <- Price/100 + AccrInt;
  
  Yield <- ((1 + CouponRate * Tim) / B  - 1) * (1/Tsm);
  
  Yield
}
