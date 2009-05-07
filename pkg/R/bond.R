## RQuantLib -- R interface to the QuantLib libraries
##
## Copyright (C) 2002 - 2009 Dirk Eddelbuettel <edd@debian.org>
## Copyright (C) 2009        Khanh Nguyen <knguyen@cs.umb.edu>
##
## $Id: asian.R 58 2009-03-31 03:50:44Z edd $
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

ZeroCouponBond <- function(settlementDays, 
	       	  	calendar, faceAmount,maturityDate,
                        businessDayConvention,redemption, 
			issueDate, todayDate,riskFreeRate ) {
    UseMethod("ZeroCouponBond")
}

ZeroCouponBond.default <- function(settlementDays, 
		       calendar, faceAmount, maturityDate,
		       businessDayConvention, redemption, 
		       issueDate, todayDate,riskFreeRate ) {
    val <- .Call("QL_ZeroCouponBond",
                     list(
		     settlementDays=as.double(settlementDays),
		     calendar=as.character(calendar),
		     faceAmount = as.double(faceAmount),
		     businessDayConvention=as.character(businessDayConvention),
		     redemption= as.double(redemption),
		     riskFreeRate= as.double(riskFreeRate),
		     maturityDate = maturityDate,
		     issueDate = issueDate,
		     todayDate = todayDate),
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
