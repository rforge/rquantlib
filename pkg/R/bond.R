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

ZeroCouponBond <- function(settlementDays,calendar,
                  faceAmount,maturityDate,
                  businessDayConvention,redemption, 
                  issueDate, todayDate,riskFreeRate ) {
    UseMethod("ZeroCouponBond")
}

ZeroCouponBond.default <- function(settlementDays, calendar="us", 
                       faceAmount, maturityDate,
	               businessDayConvention=4, redemption, 
                       issueDate, todayDate,riskFreeRate ) {
    val <- .Call("QL_ZeroCouponBond",
                     list(
                          settlementDays=as.double(settlementDays),
                          calendar=as.character(calendar),
	                  faceAmount = as.double(faceAmount),
	                  businessDayConvention=as.double(businessDayConvention),
	                  redemption= as.double(redemption),
	                  riskFreeRate= as.double(riskFreeRate),
	                  maturityDate = maturityDate,
	                  issueDate = issueDate,
	                  todayDate = todayDate),
                 PACKAGE="RQuantLib")
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
     class(val) <- c("ZeroPriceByYield", "Bond")
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
     class(val) <- c("ZeroYield", "Bond")
     val
}


FixedRateBond <- function( settlementDays, faceAmount,
                           effectiveDate, maturityDate, 
                           period, calendar, rates,
                           dayCounter, businessDayConvention, 
                           redemption, issueDate, riskFreeRate, todayDate) {
     UseMethod("FixedRateBond")
}
FixedRateBond.default <- function(settlementDays = 1, faceAmount,
                                effectiveDate, maturityDate, 
                                period, calendar = "us", rates,
                                dayCounter=2, businessDayConvention=0, 
                                redemption = 100, issueDate, riskFreeRate, todayDate) {
     val <- .Call("QL_FixedRateBond",
                    list(
                         settlementDays=as.double(settlementDays),
                         calendar=as.character(calendar),
		         faceAmount = as.double(faceAmount),
                         period = as.double(period),
		         businessDayConvention=as.double(businessDayConvention),
		         redemption= as.double(redemption),
                         dayCounter = as.double(dayCounter),
		         riskFreeRate= as.double(riskFreeRate),
		         maturityDate = maturityDate,
                         effectiveDate = effectiveDate,
		         issueDate = issueDate,
		         todayDate = todayDate), rates, 
                 PACKAGE="RQuantLib")
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
    class(val) <- c("FixedRateBondYield", "Bond")
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
    class(val) <- c("FixedRateBondPriceByYield", "Bond")
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
