##  RQuantLib R code for BermudanSwaption
##
##  Copyright (C) 2005  Dominick Samperi
##
##  This program is free software; you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation; either version 2 of the License, or
##  (at your option) any later version.
##
##  This program is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU General Public License for more details.
##
##  You should have received a copy of the GNU General Public License
##  along with this program; if not, write to the Free Software
##  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

BermudanSwaption <- function(params, tsQuotes, swaptionMaturities,
                             swapTenors, volMatrix) {
    UseMethod("BermudanSwaption")
}

BermudanSwaption.default <- function(params, tsQuotes, swaptionMaturities,
                                     swapTenors, volMatrix) {

  # The C++ code assumes that we have checked carefully for consistent
  # input here...

  # Check that params list names
  if(!is.list(params) || length(params) == 0) {
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

  # Check tradeDate
  if(!is.numeric(params$tradeDate) || length(params$tradeDate) != 3) {
    stop("Invalid tradeDate value");
  }
  
  # Check settleDate
  if(!is.numeric(params$settleDate) || length(params$settleDate) != 3) {
    stop("Invalid settleDate value");
  }

  # Check payFixed flag
  if(!is.logical(params$payFixed)) {
    stop("payFixed paramter must be logical (T/F)")
  }

  # Check strike
  if(!is.numeric(params$strike)) {
    stop("strike must be numeric")
  }

  # Check method
  if(!is.character(params$method)) {
    stop("method must be a character string")
  }

  # Check interpWhat
  if(!is.character(params$interpWhat)) {
    stop("interpWhat must be a character string")
  }

  # Check interpHow
  if(!is.character(params$interpHow)) {
    stop("interpHow must be a character string")
  }
  
  # Check that the term structure quotes are properly formatted.
  if(!is.list(tsQuotes) || length(tsQuotes) == 0) {
    stop("Term structure quotes must be a non-empty list");
  }
  if(length(tsQuotes) != length(names(tsQuotes))) {
    stop("Term structure quotes must include labels");
  }
  if(!is.numeric(unlist(tsQuotes))) {
    stop("Term structure quotes must have numeric values")
  }
  
  # Check for correct matrix/vector types
  if(!is.matrix(volMatrix)
     || !is.numeric(swaptionMaturities)
     || !is.numeric(swapTenors)) {
    stop("Swaption vol must be a matrix, maturities/tenors must be vectors")
  }

  # Check that matrix/vectors have compatible dimensions
  if(prod(dim(volMatrix)) != length(swaptionMaturities)*length(swapTenors)) {
    stop("Dimensions of swaption vol matrix not compatible with maturity/tenor vectors")
  }

  # Finally ready to make the call...
  # We could coerce types here and pass as.integer(round(swapTenors)),
  # temp <- as.double(volMatrix), dim(temp) < dim(a) [and pass temp instead
  # of volMatrix]. But this is taken care of in the C/C++ code.
  val <- .Call("QL_BermudanSwaption",
               params, tsQuotes,
               swaptionMaturities,
               swapTenors,
               volMatrix)
  class(val) <- c(params$method, "BermudanSwaption")
  val
}

summary.G2Analytic <- function(obj,...) {
  cat('\n\tSummary of pricing results for Bermudan Swaption\n')
  cat('\nPrice (in bp) of Bermudan swaption is ', obj$price)
  cat('\nStike is ', format(obj$params$strike,digits=6))
  cat(' (ATM strike is ', format(obj$ATMStrike,digits=6), ')')
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
  cat('\nPrice (in bp) of Bermudan swaption is ', obj$price)
  cat('\nStike is ', format(obj$params$strike,digits=6))
  cat(' (ATM strike is ', format(obj$ATMStrike,digits=6), ')')
  cat('\nModel used is: Hull-White using analytic formulas')
  cat('\nCalibrated model parameters are:')
  cat('\na = ', format(obj$a,digits=4))
  cat('\nsigma = ', format(obj$sigma,digits=4))
  cat('\n\n')
}

summary.HWTree <- function(obj,...) {
  cat('\n\tSummary of pricing results for Bermudan Swaption\n')
  cat('\nPrice (in bp) of Bermudan swaption is ', obj$price)
  cat('\nStike is ', format(obj$params$strike,digits=6))
  cat(' (ATM strike is ', format(obj$ATMStrike,digits=6), ')')
  cat('\nModel used is: Hull-White using a tree')
  cat('\nCalibrated model parameters are:')
  cat('\na = ', format(obj$a,digits=4))
  cat('\nsigma = ', format(obj$sigma,digits=4))
  cat('\n\n')
}

summary.BKTree <- function(obj,...) {
  cat('\n\tSummary of pricing results for Bermudan Swaption\n')
  cat('\nPrice (in bp) of Bermudan swaption is ', obj$price)
  cat('\nStike is ', format(obj$params$strike,digits=6))
  cat(' (ATM strike is ', format(obj$ATMStrike,digits=6), ')')
  cat('\nModel used is: Black-Karasinski using a tree')
  cat('\nCalibrated model parameters are:')
  cat('\na = ', format(obj$a,digits=4))
  cat('\nsigma = ', format(obj$sigma,digits=4))
  cat('\n\n')
}
