## Dominick Samperi, 9/5/2005

DiscountCurve <- function(params, tsQuotes, times) {
  UseMethod("DiscountCurve")
}

DiscountCurve.default <- function(params, tsQuotes, times) {

  # The C++ code assumes that we have checked carefully for consistent
  # input here...

  # Check that params is properly formatted.
  if(class(params) != "list" || length(params) == 0) {
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

  # Check that the term structure quotes are properly formatted.
  if(class(tsQuotes) != "list" || length(tsQuotes) == 0) {
    stop("Term structure quotes must be a non-empty list");
  }
  if(length(tsQuotes) != length(names(tsQuotes))) {
    stop("Term structure quotes must include labels");
  }

  # Check the times vector
  if(class(times) != "numeric" || length(times) == 0)
    stop("The times parameter must be a non-emptry numeric vector")
    
  # Finally ready to make the call...
  val <- .Call("QL_DiscountCurve", params, tsQuotes, times)
  class(val) <- c("DiscountCurve")
  val
}

plot.DiscountCurve <- function(obj,...) {
  savepar <- par(mfrow=c(3,1))
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
  par(savepar)
}
