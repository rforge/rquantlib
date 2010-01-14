% $Id: Calendars.Rd 64 2009-04-10 20:24:33Z edd $
\name{advance.by.timeunit}
\alias{advance.by.timeunit}
\title{Calendar functions from QuantLib}
\description{
The \code{advance.by.timeunit} function evaluates the given dates in the context
of the given calendar, and returns a vector that advances the given dates of the given number of business days and returns the result.  
}
\usage{
advance.by.timeunit(calendar="TARGET", dates=Sys.Date(),n, timeUnit, bdc = 0, emr = 0)
}
\arguments{
  \item{calendar}{A string identifying one of the supported QuantLib
    calendars, see Details for more}
  \item{dates}{A vector (or scalar) of \code{Date} types.}
  \item{n}{an int}
  \item{timeUnit}{a value of 0,1,2,3 that corresponds to Days, Weeks,
    Months, and Year. For more detail, see QuantLib doc
    \url{http://quantlib.org/reference/group__datetime.html}}
  \item{bdc}{business day convention. By default, this value is 0 and correspond to Following convention}
  \item{emr}{End Of Month rule. Default = false}
}
\value{
  An named vector of dates. The element names are
  the dates (formatted as text in yyyy-mm-dd format).
}
\details{
  The calendars are coming from QuantLib, and the QuantLib documentation
  should be consulted for details.

  Currently, the following strings are recognised: TARGET (a default
  calendar), Canada and Canada/Settlement, Canada/TSX, Germany and
  Germany/FrankfurtStockExchange, Germany/Settlement, Germany/Xetra,
  Germany/Eurex, Italy and Italy/Settlement, Italy/Exchange, Japan,
  UnitedKingdom and UnitedKingdom/Settlement, UnitedKingdom/Exchange,
  UnitedKingdom/Metals, UnitedStates and UnitedStates/Settlement,
  UnitedStates/NYSE, UnitedStates/GovernmentBond, UnitedStates/NERC.

  (In case of multiples entries per country, the country default is listed
  right after the country itself. Using the shorter form is equivalent.)
  
}
\references{\url{http://quantlib.org} for details on \code{QuantLib}.}
\author{Dirk Eddelbuettel \email{edd@debian.org} for the \R interface;
  Khanh Nguyen \email{nguyen.h.khanh@gmail.com} for the implementation;
  the QuantLib Group for \code{QuantLib}}
\note{The interface might change in future release as \code{QuantLib}
  stabilises its own API.}
\examples{
  dates <- seq(from=as.Date("2009-04-07"), to=as.Date("2009-04-14"), by=1)
  advance.by.timeunit("UnitedStates", dates, 10, 0)
  advance.by.timeunit("UnitedStates/Settlement", dates, 10, 1)      ## same as previous
  advance.by.timeunit("UnitedStates/NYSE", dates, 10, 2)            ## stocks
  advance.by.timeunit("UnitedStates/GovernmentBond", dates,  10, 3)  ## bonds
}
\keyword{misc}

