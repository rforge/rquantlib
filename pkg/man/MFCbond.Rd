% $Id: MFCD.Rd 121 2009-11-02 22:50:50Z edd $
\name{Matlab Convertible bond pricing}
\alias{mf.cbprice}
\title{Matlab's convertible bond pricing}
\description{
This function mirrors Matlab's cbprice function in Matlab. It price
convertible bond.
}
\usage{
mf.cbprice(RiskFreeRate, StaticSpread, Sigma, Price,
                    ConvRatio, NumSteps, IssueDate, Settle,
                    Maturity, CouponRate, Period = 2, Basis = 6,
                    EndMonthRule = 0, DividendType = 0,
                    DividendInfo, CallType = 0, CallInfo, TreeType = 0)
}
\arguments{
  \item{RiskFreeRate}{a numeric, Annual yield of risk-free bond with the same maturity as the convertible, compounded continuously. (Recommended value is the yield of a risk-free bond with the same maturity as the convertible.}
  \item{StaticSpread}{a numeric, Value of constant spread to the risk free rate. Adding this to the RiskFreeRate produces the issuer's yield, which reflects its credit risk. }
  \item{Sigma}{a numeric, Annual volatility in decimal.}
  \item{Price}{a numeric, Price of asset at settlement or valuation date.}
  \item{ConvRatio}{a numeric, Number of assets convertible to a single bond.}
  \item{NumSteps}{a numeric, Number of steps in binomial tree.}
  \item{IssueDate}{a Date, Issue date of bond.}
  \item{Settle}{a Date, Settlement date of bond.}
  \item{Maturity}{a Date, Maturity date of bond}
  \item{CouponRate}{a numeric, Coupon rate payable per unit of face value.}
  \item{Period}{(Optional) a numeric, frequency of paymend. Defaul is 2,
  or 'Semiannual'.}
  \item{Basis}{(Optional) a numeric, day counter basis. Default value is
  6, or 'Thirty360'.}
  \item{EndMonthRule}{(Optional) a numeric. Default value is 0.}
  \item{DividendType}{ (Optional) 0 = dollar dividend (default). 1 = dividend yield.}
  \item{DividendInfo}{(Optional) Two-column data frame of dividend information. First column contains the ex-dividend date corresponding to the amount in the second column. Default = no dividend. }
  \item{CallType}{0 = call on cash price (default). 1 = call on clean price.}
  \item{CallInfo}{(Optional) Two-column matrix of call information. First column contains the call dates. Second column contains call prices for every $100 face of bond. A call in the amount of call prices is activated after the corresponding call date. Default = no call feature.}
  \item{TreeType}{(Optional) 0 = binomial tree (default). 1 = trinomial tree.}
}
\value{
  Returns the price of the given convertible bond.
}
\references{\url{http://www.mathworks.com/access/helpdesk/help/toolbox/finfixed/f5-6010.html#f5-8321}}
\author{Khanh Nguyen \email{knguyen@cs.umb.edu}}
\examples{
RiskFreeRate = 0.05
Sigma        = 0.3
ConvRatio    = 1
NumSteps     = 200
IssueDate    = as.Date("2002-01-02")
Settle       = as.Date("2002-01-01")
Maturity     = as.Date("2007-01-02")
CouponRate   = 0.04;
CallInfo     = data.frame(Date=as.Date("2004-01-02"), Amount=110)
CallType     = 1;
TreeType     = 1;

DividendInfo=data.frame(Date=as.Date(character(0)), Amount=numeric(0))

StaticSpread <- 0.005
Price <- 70
mf.cbprice(RiskFreeRate, StaticSpread, Sigma, Price,
ConvRatio, NumSteps, IssueDate, Settle, Maturity, CouponRate, Period=2,
Basis=6, EndMonthRule=0, DividendType=0, DividendInfo,
CallType, CallInfo, TreeType)
}


