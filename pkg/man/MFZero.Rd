% $Id: MFCD.Rd 121 2009-11-02 22:50:50Z edd $
\name{Matlab Zero coupon bond}
\alias{mf.zeroyield}
\alias{mf.zeroprice}
\title{Matlab's zero coupon bond functions}
\description{
Zero coupon instruments releated functions in Matlab.
}
\usage{
mf.zeroprice(Yield, Settle, Maturity, Period=2, Basis=6, EndMonthRule=0)
mf.zeroyield(Price, Settle, Maturity, Period=2, Basis=6, EndMonthRule=0)

}
\arguments{
  \item{Yield}{a numeric, yield to maturity of instruments}
  \item{Price}{a numeric, price of the instrument}
  \item{Settle}{a Date, settlement date}
  \item{Maturity}{a Date, maturity date}
  \item{Period}{(Optional) a numeric, number of quasi-coupon per year. Defaul is 2,
    or 'Semiannual'. See \link{Enum}}
  \item{Basis}{(Optional) a numeric, day counter. Default is 6, or 'Thirty360'. See
    \link{Enum}}
  \item{EndMonthRule}{(Optional) a numeric, end of month rule. Default is 0.}
}
\value{
  mf.zeroprice returns the price of a bond given yield

  mf.zeroyield returns the yield of the bond given price
}
\references{\url{http://www.mathworks.com/access/helpdesk/help/toolbox/finfixed/f5-6010.html#f5-8238}}
\author{Khanh Nguyen \email{knguyen@cs.umb.edu}}
\examples{
Settle <- as.Date("1993-06-24")
Maturity <- as.Date("1993-11-01")
Period <- 2
Basis <- 2
Yield <- 0.04

mf.zeroprice(Yield, Settle, Maturity, Period, Basis)  

Price <- 95
mf.zeroyield(Price, Settle, Maturity, Period, Basis) 
}


