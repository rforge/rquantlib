ZeroCouponBond <- function(settlementDays, calendar, faceAmount, maturityDate,
                           businessDayConvention, redemption, issueDate, 				todayDate,riskFreeRate ) {
    UseMethod("ZeroCouponBond")
}

ZeroCouponBond.default <- function(settlementDays, calendar, faceAmount, maturityDate,
                           businessDayConvention, redemption, issueDate, 				todayDate,riskFreeRate ) {
    val <- .Call("QL_ZeroCouponBond",
                 list(settlementDays=as.double(settlementDays),
                      calendar=as.character(calendar),
			faceAmount = as.double(faceAmount), 
			maturityDate=as.character(maturityDate),
                         businessDayConvention=as.character(businessDayConvention), 
			redemption= as.double(redemption), 
			issueDate=as.character(issueDate), 
			todayDate=as.character(todayDate),
			riskFreeRate= as.double(riskFreeRate)),
                 PACKAGE="RQuantLib")
    class(val) <- c("ZeroCouponBond", "Bond")
    val
}

#I am not sure how to if these are correct. I just copy from asian.R
plot.Bond <- function(x, ...) {
    warning("No plotting available for class", class(x)[1],"\n")
    invisible(x)
}

print.Bond <- function(x, digits=4, ...) {
    cat("Concise summary of valuation for", class(x)[1], "\n")
    print(round(unlist(x[1:7]), digits))
    invisible(x)
}

summary.Bond <- function(object, digits=4, ...) {
    cat("Detailed summary of valuation for", class(object)[1], "\n")
    print(round(unlist(object[1:7]), digits))
    cat("with parameters\n")
    print(unlist(object[["parameters"]]))
    invisible(object)
}
