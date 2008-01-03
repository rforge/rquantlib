## Dominick Samperi, 9/5/2005

BermudanSwaption <- function(params, tsQuotes, swaptionMaturities,
                             swapTenors, volMatrix) {
    UseMethod("BermudanSwaption")
}

BermudanSwaption.default <- function(params, tsQuotes, swaptionMaturities,
                                     swapTenors, volMatrix) {

  # The C++ code assumes that we have checked carefully for consistent
  # input here...

  # Check that params is properly formatted.
  if(class(params) != "list" || length(params) == 0) {
    stop("The params parameter must be a non-empty list");
  }
  ok <- 1
  paramsNames <- c("tradeDate", "settleDate", "payFixed", "strike",
                   "method", "interpWhat", "interpHow")
  if(length(names(params)) != length(paramsNames)) {
    ok <- 0
  }
  else {
    if(!all(toupper(names(params)) == toupper(paramsNames))) {
      ok <- 0
    }
  }
  if(ok == 0) {
    cat("Required parameters:\n")
    cat(paste(paramsNames, collapse=", "), "\n(plus market info)\n")
    stop("Please specify these parameters")
  }

  # Check that the term structure quotes are properly formatted.
  if(class(tsQuotes) != "list" || length(tsQuotes) == 0) {
    stop("Term structure quotes must be a non-empty list");
  }
  if(length(tsQuotes) != length(names(tsQuotes))) {
    stop("Term structure quotes must include labels");
  }

  # Check for correct matrix/vector dimensions.
  if(class(volMatrix) != "matrix"
     || class(swaptionMaturities) != "numeric"
     || class(swapTenors) != "numeric") {
    stop("Swaption vol must be a matrix, maturities/tenors must be vectors")
  }
  if(prod(dim(volMatrix)) != length(swaptionMaturities)*length(swapTenors)) {
    stop("Dimensions of swaption vol matrix not compatible with maturity/tenor vectors")
  }

  # Finally ready to make the call...
  val <- .Call("QL_BermudanSwaption",
               params, tsQuotes,
               swaptionMaturities, swapTenors, volMatrix)
  class(val) <- c(params$method, "BermudanSwaption")
  val
}

summary.G2Analytic <- function(obj,...) {
  cat('\n\tSummary of pricing results for Bermudan Swaption\n')
  cat('\nPrice (in bp) of Bermudan swaption is ', pricing$price)
  cat('\nStike is ', format(params$strike,digits=6))
  cat(' (ATM strike is ', format(pricing$ATMStrike,digits=6), ')')
  cat('\nModel used is: G2/Jamshidian using analytic formulas')
  cat('\nCalibrated model parameters are:')
  cat('\na = ', format(obj$a,digits=4))
  cat('\nb = ', format(obj$b,digits=4))
  cat('\nsigma = ', format(obj$sigma,digits=4))
  cat('\neta = ', format(obj$eta,digits=4))
  cat('\nrho = ', format(obj$rho,digits=4))
  cat('\n\n')
}

summary.HWAnalytic <- function(obj,...) {
  cat('\n\tSummary of pricing results for Bermudan Swaption\n')
  cat('\nPrice (in bp) of Bermudan swaption is ', pricing$price)
  cat('\nStike is ', format(params$strike,digits=6))
  cat(' (ATM strike is ', format(pricing$ATMStrike,digits=6), ')')
  cat('\nModel used is: Hull-White using analytic formulas')
  cat('\nCalibrated model parameters are:')
  cat('\na = ', format(obj$a,digits=4))
  cat('\nsigma = ', format(obj$sigma,digits=4))
  cat('\n\n')
}

summary.HWTree <- function(obj,...) {
  cat('\n\tSummary of pricing results for Bermudan Swaption\n')
  cat('\nPrice (in bp) of Bermudan swaption is ', pricing$price)
  cat('\nStike is ', format(params$strike,digits=6))
  cat(' (ATM strike is ', format(pricing$ATMStrike,digits=6), ')')
  cat('\nModel used is: Hull-White using a tree')
  cat('\nCalibrated model parameters are:')
  cat('\na = ', format(obj$a,digits=4))
  cat('\nsigma = ', format(obj$sigma,digits=4))
  cat('\n\n')
}

summary.BKTree <- function(obj,...) {
  cat('\n\tSummary of pricing results for Bermudan Swaption\n')
  cat('\nPrice (in bp) of Bermudan swaption is ', pricing$price)
  cat('\nStike is ', format(params$strike,digits=6))
  cat(' (ATM strike is ', format(pricing$ATMStrike,digits=6), ')')
  cat('\nModel used is: Black-Karasinski using a tree')
  cat('\nCalibrated model parameters are:')
  cat('\na = ', format(obj$a,digits=4))
  cat('\nsigma = ', format(obj$sigma,digits=4))
  cat('\n\n')
}
