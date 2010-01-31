% $Id: MFCD.Rd 121 2009-11-02 22:50:50Z edd $
\name{Matlab Coupon Bond Dates}
\alias{mf.cfamounts}
\title{Matlab's coupon bond date functions}
\description{
Matlab's coupon bond date functions from Matlab financial toolbox.
}
\usage{
mf.cfamounts(CouponRate, Settle, Maturity,
             Period = 2, Basis = 6, EndMonthRule = 1,
             IssueDate = Settle, Face = 100)
}
\arguments{
  \item{CouponRate}{a numeric, coupon rate of the bond}
  \item{Settle}{a Date, settlement date of the bond}
  \item{Maturity}{a Date, maturity date of the bond}
  \item{Period}{(Optional) a numeric, coupon per year of the bond. See
    \link{Enum}. Default is 2.}
  \item{Basis}{(Optional) a numeric, day counter. Default is 6, or
    'Thirty360. See \link{Enum}.}
  \item{EndMonthRule}{(Optional)a numeric, end of month rule. Default is 1.}
  \item{IssueDate}{(Optional)a Date, issue date of the bond. Default value is the
    Settle date.}
  \item{Face}{(Optional)a numeric, bond's face amount. Default is 100.}  
}
\value{
  mf.cfamounts returns the cash flow and time mapping of a bond
}
\references{\url{http://www.mathworks.com/access/helpdesk/help/toolbox/finance/cfamounts.html}}
\author{Khanh Nguyen \email{knguyen@cs.umb.edu}}
\examples{
CouponRate <- 0.05
Settle <- as.Date('2002-01-02')
Maturity <- as.Date('2002-03-31')

mf.cfamounts(CouponRate, Settle, Maturity)

}


