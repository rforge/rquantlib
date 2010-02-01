wholeQtrs <- function(settle, nextCoupon){
  settleMonth <- as.numeric(format.Date(settle, "%m"))
  nextCouponMonth <- as.numeric(format.Date(nextCoupon, "%m"))

  settleYear <- as.numeric(format.Date(settle, "%y"))
  nextCouponYear <- as.numeric(format.Date(nextCoupon, "%y"))
  hold <- 0
  if (settleMonth > nextCouponMonth){
    hold = floor((12 - settleMonth)/3) + floor(nextCouponMonth/3) +
      (nextCouponYear - settleYear - 1) * 4;
  }
  else if (settleMonth < nextCouponMonth){
        hold = floor((nextCouponMonth - settleMonth)/3);
        nonQtr = c(nextCouponMonth %% 3,  settleMonth %% 3)

        if (sum((nonQtr == c(0,0)) == 0)) {
          hold <- hold -1
        }

        if (settleYear < nextCouponYear){
          hold = (4 - hold) + (nextCouponYear - settleYear - 1)*4;
        }
  }
  else {
    hold <- nextCouponYear - settleYear * 4
  }
  hold
}

monnb <- function(d) { lt <- as.POSIXlt(as.Date(d, origin="1900-01-01")); 
                          lt$year*12 + lt$mon }
monthdf <- function(d1, d2) { monnb(d1) - monnb(d2) }

nearestMonth <- function(settle, nextCoupon){
  monthdf(settle, nextCoupon)
}
mf.convfactor <- function(RefDate, Maturity, CouponRate,
                          RefYield = 0.06, Convention = 1){


  FCF <- 1
  LCF <- 1
  LDF <- 1

  cflowDates <- mf.cfdates(RefDate, Maturity)
  cflowDates <- cflowDates[-1]
  
  n <- length(cflowDates) - 3

  if (Convention == 1){
    compQtr <- wholeQtrs(RefDate, cflowDates[1])
    DF <- (compQtr * 3)/ 6
  }
  else{
    DF <- nearestMonth(RefDate, cflowDates[1] / 6)
  }

  zeroDF <- (DF <= 0)
  if (zeroDF) {
    DF <- 1
    n <- n - 1
  }

  AIF <- 1 - DF

  a = (1 + (RefYield/2)) ^ (-DF);
  b = (CouponRate/2) * FCF;
  c = (CouponRate/RefYield) * (1 - (1 / (1 + (RefYield/2))^n));
  d = (1 + (CouponRate/2)*LCF) * (1 + (RefYield/2))^(-n-LDF);
  e = (CouponRate/2) * AIF;
  
  CF = a * (b + c + d) - e;
  CF
}
