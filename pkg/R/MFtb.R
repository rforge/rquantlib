mf.tbilldisc2yield <- function(Discount, Settle, Maturity){
  DSM <- as.numeric(Maturity - Settle)

  ret <- c()
  if (DSM <= 182){
    x <- 360 * Discount / (360 - Discount * DSM)
    y <- x * 365 / 360
    ret['MMYield'] <- x
    ret['BEYield'] <- y
  }
  else{
    Price <- 100 (1 - Discount * DSM / 360)
    ret['MMYield'] <- ( 100 / Price - 1) * (360 / DSM)

    X <- DSM / 365
    ret['BEYield'] <- (-2 * X + 2 * sqrt(X^2 - (2 * X -1) * ( 1- 100/Price))) / (2 * X - 1)
  }
  
  ret
}

mf.tbillprice <- function(Rate, Settle, Maturity,  Type=1){
  r <- mf.tbillyield2disc(Rate, Settle, Maturity, Type)
  Face <- 100
  DSM <- as.numeric(Maturity - Settle)
  Price <- Face - (r * Face * DSM / 360)
  Price
}

mf.tbillyield2disc <- function(Yield, Settle, Maturity, Type=1){
  Discount <- 0
  A <- 0
  if (Type == 1)
    A <- 360
  else A <- 365

  DSM <- as.numeric(Maturity - Settle)

  if (DSM <= 182) {
    Discount <- 360 / DSM * (1 - (1/ ( 1 + Yield * DSM / A)))
  }
  else {
    
    Discount = 360/DSM *(1-(1/(((1 + Yield/2)) * (1 +(2*DSM/A-1)*Yield/2))));
  }
  Discount
}

mf.tbillrepo <- function(RepoRate, InitialDiscount, PurchaseDate, SaleDate, Maturity){
  T1 <- dayCount(PurchaseDate, Maturity, 2)
  T2 <- dayCount(SaleDate, Maturity, 2)

  tbediscount <- (1 - (1 - InitialDiscount*T1/360)*(1 + RepoRate*(T1-T2)/360) ) * 360/T2
  tbediscount
}

mf.tbillval01 <- function(Settle, Maturity){
  DSM <- as.numeric(Maturity - Settle)

  Rate <- 0.0001
  Face <- 100

  CMMY <- 360 * Rate / (360 + Rate * DSM)
  CBEY <- 360 * Rate / (365 + Rate * DSM)

  ret <- c()
  ret['Val01Disc'] <- Rate * Face * DSM / 360
  ret['Val01MMY'] <- CMMY * Face * DSM / 360
  ret['Val01BEY'] <- CBEY * Face * DSM / 360
  ret
}

mf.tbillyield <- function(Price, Settle, Maturity){
  DSM <- as.numeric(Maturity - Settle)
  ret <- c()
  ret['MMYield'] <- (100 / Price - 1) * 360 / DSM
  ret['Discount'] <- (1 - Price / 100)*360 / DSM

  if (DSM <= 182){
    ret['BEYield'] <- ret['MMYield'] * 365 / 360    
  }
  else{
    X <- DSM / 365
    ret['BEYield'] <-(-2*X + 2*sqrt( X^2 -(2*X - 1)*(1 - 100/Price))) / (2*X - 1)
  }
  ret
}
