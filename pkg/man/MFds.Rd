% $Id: MFCD.Rd 121 2009-11-02 22:50:50Z edd $
\name{Matlab Derivative Securities}
\alias{mf.bkcaplet}
\alias{mf.bkfloorlet}
\alias{mf.bkcall}
\alias{mf.bkput}
\title{Matlab's zero coupon bond functions}
\description{
Derivative securities function in Matlab.
}
\usage{
mf.bkcall(Strike, ZeroData, Sigma, BondData, Settle, 
          Expiry, Period=2, Basis=6, EndMonthRule=1, InterpMethod='linear', 
          StrikeConvention=0)

mf.bkcaplet(CapData, FwdRates, ZeroPrices,
            Settles, BeginDates, EndDates, Sigmas)

mf.bkfloorlet(FloorData, FwdRates, ZeroPrices,
             Settles, BeginDates, EndDates, Sigmas)

mf.bkput(Strike, ZeroData, Sigma, BondData, Settle, 
         Expiry, Period=2, Basis=6, EndMonthRule=1, InterpMethod='linear', 
         StrikeConvention=0)

}
\arguments{
  \item{Strike}{a numeric, strike price}
  \item{ZeroData}{3-column data frame, column 1 are dates associated
    with the zero rate in the second column, column 3 are annual
    compounding frequency of the annualized rate in column 2. Values in
    column 3 are 1(annual), 2(semiannual, default), 3, 4, 6 12 and -1(continuous)}
  \item{Sigma}{a numeric, annualized price volatilities required by
    Black's model.}
  \item{BondData}{a 1x4 data frame that contains characteristics of the
    underlying bond. [CleanPrice CouponRate Maturiy Face].}
  \item{Settle}{a Date, option's settlement date.}
  \item{Expiry}{a Date, option's expiry date.}
  \item{Period}{(Optional)a numeric, number of coupon per year for the underlying
    bond. Default is 2. See also \link{Enum}.}
  \item{Basis}{(Optional)a numeric, day counter. Default is 6 for
    'Thirty360'. See \link{Enum}}
  \item{EndMonthRule}{(Optional)a numeric, end month rule. Default is 1.}
  \item{InterpMethod}{(Optional)a string, either 'linear' or
    'constant'. Default is 'linear'}
  \item{StrikeConvention}{(Optional)a numeric. 0 or 1. Currently, the
    code only supports StrikeConvention=0.}
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
  
  mf.bkcall prices call option on a bond using Black's model
  
  mf.bkcaplet prices interest-rate caplet using Black's model

  mf.bkfloorlet Prices interest-rate floorlet using Black's model

  mf.bkput prices put option on a bond using Black's model
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


Settle       = as.Date("2004-03-15")
Expiry       = as.Date("2005-01-15")
Strike       =  1000
Sigma        =  0.09
Convention   =  0

ZeroDates     = c(as.Date('2004-06-15'), as.Date('2004-12-15'),
  Expiry)
ZeroRates = c(0.09,0.095,0.10)
ZeroData     = cbind(ZeroDates, ZeroRates, rep(-1, 3))
CleanPrice   =  935
CouponRate   =  0.1
Maturity     = as.Date('2013-12-15')
Face         =  1000
BondData     = data.frame(CleanPrice, CouponRate, Maturity, Face)
Period       =  2
Basis        =  1

mf.bkcall(Strike, ZeroData, Sigma, BondData, Settle, 
          Expiry, Period=2, Basis=1, EndMonthRule=1, InterpMethod='linear', 
          StrikeConvention=0)

mf.bkput(Strike, ZeroData, Sigma, BondData, Settle, 
          Expiry, Period=2, Basis=1, EndMonthRule=1, InterpMethod='linear', 
          StrikeConvention=0)
}


