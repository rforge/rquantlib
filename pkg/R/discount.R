##  RQuantLib R code for DiscountCurve
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

DiscountCurve <- function(params, tsQuotes, times) {
  UseMethod("DiscountCurve")
}

DiscountCurve.default <- function(params, tsQuotes, times) {

  # The C++ code assumes that we have checked carefully for consistent
  # input here...

  # Check that params is properly formatted.
  if(!is.list(params) || length(params) == 0) {
    stop("The params parameter must be a non-empty list");
  }

  # Check that correct parameters are supplied in the right order.
  ok <- 1
  paramsNames <- c("tradeDate", "settleDate", "dt", "interpWhat", "interpHow")
  if(length(names(params)) != length(paramsNames)) {
    ok <- 0
  }
  else {
    if(!all(toupper(names(params)) == toupper(paramsNames))) {
      ok <- 0
    }
  }
  if(ok == 0) {
    cat("Required paramters:\n")
    cat(paste(paramsNames, collapse=", "), "\n(plus market info)\n")
    stop("Please specify these paramters")
  }

    # Check format of tradeDate
  if(!is.numeric(params$tradeDate) || length(params$tradeDate) != 3) {
    stop("Invalid tradeDate value");
  }
  

  # Check tradeDate
  if(!is.numeric(params$tradeDate) || length(params$tradeDate) != 3) {
    stop("Invalid tradeDate value");
  }
  
  # Check settleDate
  if(!is.numeric(params$settleDate) || length(params$settleDate) != 3) {
    stop("Invalid settleDate value");
  }

  # Check dt
  if(!is.numeric(params$dt)) {
    stop("dt paramter must be numeric")
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
    stop("Term structure quotes must be a non-empty list")
  }
  if(length(tsQuotes) != length(names(tsQuotes))) {
    stop("Term structure quotes must include labels")
  }
  if(!is.numeric(unlist(tsQuotes))) {
    stop("Term structure quotes must have numeric values")
  }
  
  # Check the times vector
  if(!is.numeric(times) || length(times) == 0)
    stop("The times parameter must be a non-emptry numeric vector")
    
  # Finally ready to make the call...
  val <- .Call("QL_DiscountCurve", params, tsQuotes, times)
  class(val) <- c("DiscountCurve")
  val
}

plot.DiscountCurve <- function(obj,setpar=TRUE,...) {
  if(setpar) {
      savepar <- par(mfrow=c(3,1))
  }
  if(names(tsQuotes)[1] == "flat") {
    # Don't want to plot noise when we look at a flat yield curve
    plot(c(obj$times[1],obj$times[length(obj$times)]), c(0,.5),type='n',
         main='forwards (flat)', xlab='time',ylab='forward rate')
    lines(obj$times, obj$forwards, type='l')
    plot(c(obj$times[1],obj$times[length(obj$times)]), c(0,.5),type='n',
         main='zero rates (flat)', xlab='time',ylab='zero rate')
    lines(obj$times, obj$zerorates, type='l')
  }
  else {
    plot(obj$times, obj$forwards, type='l',
         main=paste('forwards (',obj$params$interpHow,obj$params$interpWhat,')'),
         xlab='time',ylab='fwd rate')
    plot(obj$times, obj$zerorates, type='l',
         main=paste('zero rate (',obj$params$interpHow,obj$params$interpWhat,')'),
         xlab='time',ylab='zero rate')
  }
  plot(obj$times, obj$discounts, type='l',
       main=paste('discounts (',obj$params$interpHow,obj$params$interpWhat,')'),
       xlab='time',ylab='discount')
  if(setpar) {
      par(savepar)
  }
}
