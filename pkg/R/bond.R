## RQuantLib -- R interface to the QuantLib libraries
##
## Copyright (C) 2002 - 2009 Dirk Eddelbuettel <edd@debian.org>
## Copyright (C) 2009        Khanh Nguyen <knguyen@cs.umb.edu>
##
## $Id$
##
## This file is part of the RQuantLib library for GNU R.
## It is made available under the terms of the GNU General Public
## License, version 2, or at your option, any later version,
## incorporated herein by reference.
##
## This program is distributed in the hope that it will be
## useful, but WITHOUT ANY WARRANTY; without even the implied
## warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
## PURPOSE.  See the GNU General Public License for more
## details.
##
## You should have received a copy of the GNU General Public
## License along with this program; if not, write to the Free
## Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
## MA 02111-1307, USA

ZeroCouponBond <- function(bond, discountCurve, dateparams ) {
    UseMethod("ZeroCouponBond")
}

ZeroCouponBond.default <- function(bond, discountCurve, dateparams) {
    val <- 0
    if (length(discountCurve)==2){
       val <- .Call("QL_ZBond1", 
                     bond, discountCurve, dateparams,
                     PACKAGE="RQuantLib")
    }
    if (length(discountCurve)==3){
       val <- .Call("QL_ZBond2", 
                    bond, discountCurve[[1]], 
                    discountCurve[[2]], discountCurve[[3]],
                    dateparams,
                    PACKAGE="RQuantLib")      
    }
    val$cashFlow <- as.data.frame(val$cashFlow)
    class(val) <- c("ZeroCouponBond", "Bond")    
    val
}



ZeroPriceByYield <- function(yield, faceAmount,
                      issueDate, maturityDate,
                      dayCounter, frequency,
                      compound, businessDayConvention){
          UseMethod("ZeroPriceByYield")
}

ZeroPriceByYield.default <- function(yield, faceAmount,
                              issueDate, maturityDate,
                              dayCounter=2, frequency=2,
                              compound=0, businessDayConvention=4){

     val <- .Call("QL_ZeroPriceByYield",
                     list(
   		          yield=as.double(yield),
	                  faceAmount = as.double(faceAmount),
	                  dayCounter = as.double(dayCounter),
                          compound = as.double(compound),
                          businessDayConvention = as.double(businessDayConvention),
	                  frequency = as.double(frequency),
	                  maturityDate = maturityDate,
	                  issueDate = issueDate),
                 PACKAGE="RQuantLib")
     class(val) <- c("ZeroPriceByYield")
     val
}

ZeroYield <- function(price, faceAmount,
                      issueDate, maturityDate,
                      dayCounter, frequency,
                      compound,	businessDayConvention){
	  UseMethod("ZeroYield")
}
ZeroYield.default <- function(price, faceAmount,
                              issueDate, maturityDate,
                              dayCounter=2, frequency=2,
                              compound=0, businessDayConvention=4){

     val <- .Call("QL_ZeroYield",
                     list(
   		          price=as.double(price),
	                  faceAmount = as.double(faceAmount),
	                  dayCounter = as.double(dayCounter),
                          compound = as.double(compound),
                          businessDayConvention = as.double(businessDayConvention),
	                  frequency = as.double(frequency),
	                  maturityDate = maturityDate,
	                  issueDate = issueDate),
                 PACKAGE="RQuantLib")
     class(val) <- c("ZeroYield")
     val
}



FixedRateBond <- function(bond, rates, discountCurve, dateparams){
     UseMethod("FixedRateBond")
}
FixedRateBond.default <- function(bond, rates, discountCurve, dateparams){
    val <- 0
    if (length(discountCurve)==2){
       val <- .Call("QL_FixedRateBond1", 
                     bond, rates, discountCurve, dateparams,
                     PACKAGE="RQuantLib")
    }
    if (length(discountCurve)==3){
       val <- .Call("QL_FixedRateBond2", 
                    bond, rates, discountCurve[[1]], 
                    discountCurve[[2]], discountCurve[[3]],
                    dateparams,
                    PACKAGE="RQuantLib")      
    }
    val$cashFlow <- as.data.frame(val$cashFlow)
    class(val) <- c("FixedRateBond", "Bond")    
    val
}


FixedRateBondYield <- function( settlementDays, price, faceAmount,
                           effectiveDate, maturityDate,
                           period, calendar, rates,
                           dayCounter, businessDayConvention,
                           compound, redemption, issueDate) {
     UseMethod("FixedRateBondYield")
}
FixedRateBondYield.default <- function(settlementDays = 1,price, faceAmount,
                                effectiveDate, maturityDate,
                                period, calendar = "us", rates,
                                dayCounter=2, businessDayConvention=0,
                                compound = 0, redemption = 100, issueDate) {
     val <- .Call("QL_FixedRateBondYield",
                    list(
                         settlementDays=as.double(settlementDays),
                         price = as.double(price),
                         calendar=as.character(calendar),
		         faceAmount = as.double(faceAmount),
                         period = as.double(period),
		         businessDayConvention=as.double(businessDayConvention),
                         compound = as.double(compound),
		         redemption= as.double(redemption),
                         dayCounter = as.double(dayCounter),
		         maturityDate = maturityDate,
                         effectiveDate = effectiveDate,
		         issueDate = issueDate
		         ), rates,
                 PACKAGE="RQuantLib")
    class(val) <- c("FixedRateBondYield")
    val
}


FixedRateBondPriceByYield <- function( settlementDays, yield, faceAmount,
                           effectiveDate, maturityDate,
                           period, calendar, rates,
                           dayCounter, businessDayConvention,
                           compound, redemption, issueDate) {
     UseMethod("FixedRateBondPriceByYield")
}
FixedRateBondPriceByYield.default <- function(settlementDays = 1, yield, faceAmount,
                                effectiveDate, maturityDate,
                                period, calendar = "us", rates,
                                dayCounter=2, businessDayConvention=0,
                                compound = 0, redemption = 100, issueDate) {
     val <- .Call("QL_FixedRateBondPriceByYield",
                    list(
                         settlementDays=as.double(settlementDays),
                         yield = as.double(yield),
                         calendar=as.character(calendar),
		         faceAmount = as.double(faceAmount),
                         period = as.double(period),
		         businessDayConvention=as.double(businessDayConvention),
                         compound = as.double(compound),
		         redemption= as.double(redemption),
                         dayCounter = as.double(dayCounter),
		         maturityDate = maturityDate,
                         effectiveDate = effectiveDate,
		         issueDate = issueDate
		         ), rates,
                 PACKAGE="RQuantLib")
    class(val) <- c("FixedRateBondPriceByYield")
    val
}


FloatingRateBond <- function(bond, gearings, spreads, caps, floors,
                             index, curve, dateparams){
    UseMethod("FloatingRateBond")
}

FloatingRateBond.default <- function(bond, gearings, spreads, caps, floors,
                                     index, curve, dateparams){
    val <- 0
    indexparams <- list(type=index[[1]], length=index[[2]], inTermOf=index[[3]])
    if ((length(curve)==2) && (length(index[[4]])==2)){
       val <- .Call("QL_FloatBond1", 
                     bond, gearings, spreads, caps, floors,
                     indexparams, index[[4]], curve, dateparams,
                     PACKAGE="RQuantLib")
    }
    if ((length(curve)==2) && (length(index[[4]])==3)){
       ibor <- index[[4]]
       val <- .Call("QL_FloatBond2", 
                     bond, gearings, spreads, caps, floors,
                     indexparams, ibor[[1]], ibor[[2]],
                     ibor[[3]], curve, dateparams,
                     PACKAGE="RQuantLib")
    }
    if ((length(curve)==3) && (length(index[[4]])==2)){
       val <- .Call("QL_FloatBond3", 
                    bond, gearings, spreads, caps, floors, 
                    indexparams, index[[4]], curve[[1]],curve[[2]], 
                    curve[[3]], dateparams,
                    PACKAGE="RQuantLib")      
    }
    if ((length(curve)==3) && (length(index[[4]])==3)){
       ibor <- index[[4]]
       val <- .Call("QL_FloatBond4", 
                    bond, gearings, spreads, caps, floors, 
                    indexparams, ibor[[1]], ibor[[2]], ibor[[3]], 
                    curve[[1]],curve[[2]], curve[[3]], dateparams,
                    PACKAGE="RQuantLib")      
    }
    val$cashFlow <- as.data.frame(val$cashFlow)
    class(val) <- c("FloatingRateBond", "Bond")    
    val

}


#FloatingRateBond <- function(settlementDays, faceAmount, sch, index, gearings,                                                    
#                             spreads, caps, floors, dayCounter, 
#                             businessDayConvention, fixingDays,
#                             redemption, issueDate, riskFreeRate, todayDate){
#    UseMethod("FloatingRateBond");
#}


#I am not sure how to if these are correct. I just copy from asian.R
plot.Bond <- function(x, ...) {
    warning("No plotting available for class", class(x)[1],"\n")
    invisible(x)
}


print.Bond <- function(x, digits=5, ...) {
    cat("Concise summary of valuation for", class(x)[1], "\n")
    cat(" Net present value : ", format(x$NPV), "\n")
    cat("       clean price : ", format(x$cleanPrice, digits=digits), "\n")
    cat("       dirty price : ", format(x$dirtyPrice, digits=digits), "\n")
    cat("    accrued coupon : ", format(x$accruedCoupon, digits=digits), "\n")
    cat("             yield : ", format(x$yield, digits=digits), "\n")
    cat("        cash flows : \n")
    print(x$cashFlow, row.names=FALSE, digits=digits)
    #print(round(unlist(x[1:5]), digits))
    invisible(x)
}

summary.Bond <- function(object, digits=5, ...) {
    cat("Detailed summary of valuation for", class(object)[1], "\n")
    print(round(unlist(object[1:5]), digits))
    cat("with parameters\n")
    print(unlist(object[["parameters"]]))
    invisible(object)
}
