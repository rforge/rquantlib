% $Id: MFCD.Rd 121 2009-11-02 22:50:50Z edd $
\name{Matlab Certificate of Deposit}
\alias{mf.cdai}
\alias{mf.cdprice}
\alias{mf.cdyield}
\title{Matlab's certificate of deposit functions}
\description{
  Accrued interest, price and yield of certificate of deposit functions
  in Matlab.
}
\usage{
mf.cdai(CouponRate, Settle, Maturity, IssueDate, Basis=6)
mf.cdprice(Yield, CouponRate, Settle, Maturity, IssueDate, Basis=6)
mf.cdyield(Price, CouponRate, Settle, Maturity, IssueDate, Basis=6)
}
\arguments{
  \item{CouponRate}{a numeric, coupon rate of the CD}
  \item{Settle}{a Date, settle date of the CD}
  \item{Maturity}{a Date, maturity date of the CD}
  \item{IssueDate}{a Date, issue date of the CD}
  \item{Yield}{a numeric, yield on the CD}
  \item{Price}{a numeric, price of the CD}
  \item{Basis}{(Optional) a numeric, day counter. Default is 6, or
    'Thirty360. See \link{Enum}.}
}
\value{
  mf.cdai returns the accrued interest on the CD
  
  mf.cdprice returns a two items list.  AccrtInt and Price.
  
  mf.cdyield returns the yield on the CD
}
\references{\url{http://www.mathworks.com/access/helpdesk/help/toolbox/finfixed/f5-6010.html#f5-8321}}
\author{Khanh Nguyen \email{knguyen@cs.umb.edu}}
\examples{
CouponRate <- 0.05
Settle <- as.Date('2002-01-02')
Maturity <- as.Date('2002-03-31')
IssueDate <- as.Date('2001-10-01')

mf.cdai(CouponRate, Settle, Maturity, IssueDate)

Yield <- 0.05225
price <- mf.cdprice(Yield, CouponRate, Settle, Maturity, IssueDate)

mf.cdyield(price$Price, CouponRate, Settle, Maturity, IssueDate)

}


