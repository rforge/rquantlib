% $Id: MFCD.Rd 121 2009-11-02 22:50:50Z edd $
\name{Matlab Derivative Securities}
\alias{mf.bkcaplet}
\alias{mf.bkfloorlet}
\title{Matlab's zero coupon bond functions}
\description{
Derivative securities function in Matlab.
}
\usage{
mf.bkcaplet(CapData, FwdRates, ZeroPrices,
            Settles, BeginDates, EndDates, Sigmas)
mf.bkfloorlet(FloorData, FwdRates, ZeroPrices,
             Settles, BeginDates, EndDates, Sigmas)

}
\arguments{
  \item{CapData}{a 2 column data frame containing cap rates and bases.}
  \item{FloorData}{a 2 column data frame containing floor rates and base.}
  \item{FwdRates}{a numeric vector, forward rates in decimal.}
  \item{ZeroPrices}{a numeric vector,zero coupon prices with maturities
    corresponding to those of each cap in CapData or FloorData, per $100 nominal value. }
  \item{Settles}{a vector of Date, identical elements containing
    settlement date of caplets or floorlet}
  \item{BeginDates}{vector containing start dates of the caplets/floorlets.}
  \item{EndDates}{vector containing end dates of the caplets/floorlets.}
  \item{Sigmas}{a numeric vector, volatility of forward rates in decimal, corresponding to each caplet/floorlet}
  
}
\value{
  mf.zeroprice returns the price of a bond given yield

  mf.zeroyield returns the yield of the bond given price
}
\references{\url{http://www.mathworks.com/access/helpdesk/help/toolbox/finfixed/f5-6010.html#f5-8238}}
\author{Khanh Nguyen \email{knguyen@cs.umb.edu}}
\examples{
CapData = data.frame(x=0.08,y=6)
FloorData = data.frame(x=008, y=6)
FwdRates = 0.07
ZeroPrice = 100*exp(-0.065*1.25)
Settle = as.Date('2002-10-15')
BeginDates = as.Date('2003-10-15')
EndDates = as.Date('2004-01-15')
Sigma = 0.20

Notional = 1000000/100

CapPrice = Notional*mf.bkcaplet(CapData, FwdRates, ZeroPrice,
Settle, BeginDates, EndDates, Sigma)

FloorPrice = Notional*mf.bkfloorlet(FloorData, FwdRates,
ZeroPrice, Settle, BeginDates, EndDates, Sigma)     
}


