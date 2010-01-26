% $Id: MFCD.Rd 121 2009-11-02 22:50:50Z edd $
\name{Matlab Treasury Bills}
\alias{mf.tbilldisc2yield}
\alias{mf.tbillprice}
\alias{mf.tbillyield2disc}
\alias{mf.tbillrepo}
\alias{mf.tbillval01}
\alias{mf.tbillyield}
\title{Matlab's treasury bill functions}
\description{
Treasury bills functions in Matlab.
}
\usage{
mf.tbilldisc2yield(Discount, Settle, Maturity)
mf.tbillprice(Rate, Settle, Maturity,  Type=1)
mf.tbillyield2disc(Yield, Settle, Maturity, Type = 1)
mf.tbillrepo(RepoRate, InitialDiscount, PurchaseDate,
SaleDate, Maturity)
mf.tbillval01(Settle, Maturity)
mf.tbillyield(Price, Settle, Maturity)
}
\arguments{
  \item{Discount}{a numeric, Discount rate of Treasury bills in decimal. The discount rate basis is actual/360.}
  \item{Settle}{a Date, Settlement date}
  \item{Maturity}{a Date, Maturity date}
  \item{Rate}{a numeric, Bond-equivalent yield, money-market yield, or discount rate in decimal.}
  \item{Type}{(Optional) a numeric, Rate type. Determines how to interpret values entered in Rate. 1 = money market (default). 2 = bond-equivalent. 3 = discount rate.}
  \item{Yield}{a numeric, Yield of Treasury bills in decimal.}
  \item{RepoRate}{a numeric, The annualized, 360-day based repurchase rate, in decimal}
  \item{InitialDiscount}{a numeric, Discount on the Treasury bill on the day of purchase, in decimal.}
  \item{PurchaseDate}{a Date, Date the Treasury bill is purchased.}
  \item{SaleDate}{a Date, Date the Treasury bill repurchase term is due.}
  \item{Price}{a numeric, Price of Treasury bills for every $100 face value.}
}
\value{

  mf.tbilldisc2yield converts Treasury bill discount to equivalent yield
  
  mf.tbillprice prices treasury bill
  
  mf.tbillyield2disc converts Treasury bill yield to equivalent discount
  
  mf.tbillrepo returns the break-even discount of purchase agreement
  
  mf.tbillval01 returns the value of one basis point
  
  mf.tbillyield returns yield on Treasury bill
  
}
\references{\url{http://www.mathworks.com/access/helpdesk/help/toolbox/finfixed/f5-6010.html#f5-7414}}
\author{Khanh Nguyen \email{knguyen@cs.umb.edu}}
\examples{
Discount = 0.0497;
Settle = as.Date('2002-10-01')
Maturity = as.Date('2003-03-31')
mf.tbilldisc2yield(Discount, Settle, Maturity)

Rate = 0.045
Settle = as.Date('2002-10-01')
Maturity = as.Date('2003-03-31')

Type = 2;

mf.tbillprice(Rate, Settle, Maturity, Type)

RepoRate = 0.045
InitialDiscount = 0.0475;
PurchaseDate = as.Date('2002-01-01')
SaleDate = as.Date('2002-02-03')
Maturity = as.Date('2002-04-03')

mf.tbillrepo(RepoRate, InitialDiscount,
PurchaseDate, SaleDate, Maturity)


Settle = as.Date('2003-03-01')
Maturity = as.Date('2003-06-30')
mf.tbillval01(Settle, Maturity)


Price = 98.75;
Settle = as.Date('2002-10-01')
Maturity = as.Date('2003-03-31')

mf.tbillyield(Price, Settle,Maturity)


Yield = 0.0497;
Settle = as.Date('2002-10-01')
Maturity = as.Date('2003-03-31')

mf.tbillyield2disc(Yield, Settle, Maturity)

}


