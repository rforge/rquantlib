mf.bkcall <- function(Strike, ZeroData, Sigma, BondData, Settle, 
Expiry, Period=2, Basis=6, EndMonthRule=1, InterpMethod='linear', 
StrikeConvention=0) {

  CouponRate <- BondData[,2]
  CleanPrice <- BondData[,1]
  Maturity <- BondData[,3]
  Face <- BondData[,4]


  
  cf <- mf.cfamounts(CouponRate, Settle, Maturity, Period, Basis, Face=Face)
  accruedInterest <- -cf[1,2]
  cfAmount <- cf[-1,2]
  cfDate <- cf[-1,1]

  ZeroDates <- ZeroData[,1]
  ZeroRates <- ZeroData[,2]  
  Frequency <- 0

  if (ncol(ZeroData)==2) Frequency <- rep(2, length(ZeroDates))
  else Frequency <- ZeroData[,3]
  
  for (i in 1:length(ZeroDates)){   
    if (Frequency[i] > 0){
      ZeroRates[i] <- Frequency[i] * log(1 + ZeroRates[i] / Frequency[i])
    }
  }
  
  if (Expiry > tail(ZeroDates,1)){
    ZeroDates <- c(Settle, ZeroDates, Expiry)
    ZeroRates <- c(ZeroRates[1], ZeroRates, tail(ZeroRates,1))
  } else {
    ZeroDates <- c(Settle, ZeroDates)
    ZeroRates <- c(ZeroRates[1], ZeroRates)
  }
  
  FwdPrice <- 0
  zT <- 0
  T <- 0
  relevantDates <- cfDate[cfDate < Expiry]
  I <- 0
  f <- approxfun(as.numeric(ZeroDates), ZeroRates, method=InterpMethod)
  if (length(relevantDates)==0) {
    I <- 0
  } else {
    relevantCF <- cfAmount[1:length(relevantDates)]
    TimeToCFs <- RQuantLib::yearFraction(rep(Settle, length(relevantDates)),
                                         relevantDates, as.numeric(rep(Basis, length(relevantDates))))
    z <- f(as.numeric(relevantDates))
    I <- sum(relevantCF * exp(-z * TimeToCFs))
  }                          
  
  T <- RQuantLib::yearFraction(Settle, Expiry, Basis)
  zT <- f(Expiry)
  DirtyPrice <- CleanPrice + accruedInterest
  FwdPrice <- (DirtyPrice - I) * exp(zT * T)
  P <- exp(-0.1 * T)
  
  d1 <- (log(FwdPrice / Strike) + Sigma^2 * T /2) / (Sigma * sqrt(T))
  d2 <- d1 - Sigma * sqrt(T)
  
  P * (FwdPrice * pnorm(d1) - Strike * pnorm(d2))                                         

}


mf.bkput <- function(Strike, ZeroData, Sigma, BondData, Settle, 
Expiry, Period=2, Basis=6, EndMonthRule=1, InterpMethod='linear', 
StrikeConvention=0) {

  CouponRate <- BondData[,2]
  CleanPrice <- BondData[,1]
  Maturity <- BondData[,3]
  Face <- BondData[,4]
  
  cf <- mf.cfamounts(CouponRate, Settle, Maturity, Period, Basis, Face=Face)
  accruedInterest <- -cf[1,2]
  cfAmount <- cf[-1,2]
  cfDate <- cf[-1,1]

  ZeroDates <- ZeroData[,1]
  ZeroRates <- ZeroData[,2]
  Frequency <- 0

  if (ncol(ZeroData)==2) Frequency <- rep(2, length(ZeroDates))  
  else Frequency <- ZeroData[,3]
  
  for (i in 1:length(ZeroDates)){   
    if (Frequency[i] > 0){
      ZeroRates[i] <- Frequency[i] * log(1 + ZeroRates[i] / Frequency[i])
    }
  }
  
  if (Expiry > tail(ZeroDates,1)){
    ZeroDates <- c(Settle, ZeroDates, Expiry)
    ZeroRates <- c(ZeroRates[1], ZeroRates, tail(ZeroRates,1))
  } else {
    ZeroDates <- c(Settle, ZeroDates)
    ZeroRates <- c(ZeroRates[1], ZeroRates)
  }
  
  FwdPrice <- 0
  zT <- 0
  T <- 0
  relevantDates <- cfDate[cfDate < Expiry]
  I <- 0
  f <- approxfun(as.numeric(ZeroDates), ZeroRates, method=InterpMethod)
  if (length(relevantDates)==0) {
    I <- 0
  } else {
    relevantCF <- cfAmount[1:length(relevantDates)]
    TimeToCFs <- RQuantLib::yearFraction(rep(Settle, length(relevantDates)),
                                         relevantDates, as.numeric(rep(Basis, length(relevantDates))))
    z <- f(as.numeric(relevantDates))
    I <- sum(relevantCF * exp(-z * TimeToCFs))
  }                          
  
  T <- RQuantLib::yearFraction(Settle, Expiry, Basis)
  zT <- f(Expiry)
  DirtyPrice <- CleanPrice + accruedInterest
  FwdPrice <- (DirtyPrice - I) * exp(zT * T)
  P <- exp(-0.1 * T)
  
  d1 <- (log(FwdPrice / Strike) + Sigma^2 * T /2) / (Sigma * sqrt(T))
  d2 <- d1 - Sigma * sqrt(T)
  

  P *(Strike * pnorm(-d2) - FwdPrice * pnorm(-d1))    
}

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
