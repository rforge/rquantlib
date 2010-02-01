% $Id: MFCD.Rd 121 2009-11-02 22:50:50Z edd $
\name{Matlab Bond Futures}
\alias{mf.convfactor}
\title{Matlab's bond future functions}
\description{
Matlab's bond future functions from Matlab financial toolbox.
}
\usage{
mf.convfactor(RefDate, Maturity, CouponRate,
              RefYield = 0.06, Convention = 1)
}
\arguments{
  \item{RefDate}{a Date, reference date for which conversion factor is computed.}  
  \item{CouponRate}{a numeric, coupon rate of the bond.}
  \item{Maturity}{a Date, maturity date of the bond.}
  \item{RefYield}{a numeric, reference semiannual yield. Default is
    0.06.}    
  \item{Convention}{a numeric, conversion factor convention. Default is
    1. See reference for detail.}

}
\value{
  mf.convfactor returns the bond conversion factors.
}
\references{\url{http://www.mathworks.com/access/helpdesk/help/toolbox/finfixed/f5-6010.html#br6r_wq-1}}
\author{Khanh Nguyen \email{knguyen@cs.umb.edu}}
\examples{
mf.convfactor(as.Date("2002-12-1"),as.Date("2012-11-15"), 0.04)
}


