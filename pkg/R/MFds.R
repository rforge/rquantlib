bkcaplet.once <- function(x){

  CRate <- x[1]
  Basis <- x[2]
  FwdRate <- x[3]
  ZeroPrice <-x[4]
  Settle <- x[5]
  BeginDate <- x[6]
  EndDate <- x[7]
  Sigma <- x[8]
  dt <- yearFraction(BeginDate, EndDate, Basis)
  tSettle <- yearFraction(Settle, BeginDate, Basis)

  d1 <- (log(FwdRate / CRate) + Sigma^2 * tSettle / 2) / (Sigma * sqrt(tSettle))
  d2 <- d1 - Sigma * sqrt(tSettle)
  
  
  p <- dt * ZeroPrice * (FwdRate * pnorm(d1) - CRate * pnorm(d2))
  p
  
}

mf.bkcaplet <- function(CapData, FwdRates, ZeroPrices,
                     Settles, BeginDates, EndDates, Sigmas){
  x <- cbind(CapData[,1],  CapData[,2]
             , FwdRates,  ZeroPrices,
             Settles,  BeginDates,
             EndDates,  Sigmas)

  apply(x, 1, bkcaplet.once)
  
}



bkfloor.once <- function(x){

  FRate <- x[1]
  Basis <- x[2]
  FwdRate <- x[3]
  ZeroPrice <-x[4]
  Settle <- x[5]
  BeginDate <- x[6]
  EndDate <- x[7]
  Sigma <- x[8]
  dt <- yearFraction(BeginDate, EndDate, Basis)
  tSettle <- yearFraction(Settle, BeginDate, Basis)

  d1 <- (log(FwdRate / FRate) + Sigma^2 * tSettle / 2) / (Sigma * sqrt(tSettle))
  d2 <- d1 - Sigma * sqrt(tSettle)
  
  
  p <- dt * ZeroPrice * (FRate * pnorm(-d2) - FwdRate * pnorm(-d1))
  p
    
}


mf.bkfloorlet <- function(FloorData, FwdRates, ZeroPrices,
                     Settles, BeginDates, EndDates, Sigmas){
  x <- cbind(FloorData[,1],  FloorData[,2]
             , FwdRates,  ZeroPrices,
             Settles,  BeginDates,
             EndDates,  Sigmas)

  apply(x, 1, bkfloor.once)
  
}
