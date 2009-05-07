% $Id: Bond.Rd,v 1.1 2002/02/26 03:49:27 edd Exp $
\name{Bond}
\alias{Bond}
\alias{plot.Bond}
\alias{print.Bond}
\alias{summary.Bond}
\title{Base class for Bond price evalution}
\description{
  This class forms the basis from which the more specific classes are
  derived. }
\usage{
\method{print}{Bond}
\method{plot}{Bond}
\method{summary}{Bond}
}
\arguments{
  \item{Bond}{Any Bond object derived from this base class} 
}
\value{
  None, but side effects of displaying content.
}
\details{
  Please see any decent Finance textbook for background reading, and the
  \code{QuantLib} documentation for details on the \code{QuantLib}
  implementation.  
}
\references{\url{http://quantlib.org} for details on \code{QuantLib}.}
\author{Dirk Eddelbuettel \email{edd@debian.org} for the \R interface;
  the QuantLib Group for \code{QuantLib}}
\note{The interface might change in future release as \code{QuantLib}
  stabilises its own API.}

\examples{
ZeroCouponBond(1, "us", 1000000, as.Date("2008-11-30"), "ModifiedFollowing", 100, as.Date("2004-11-30"), as.Date("2004-11-24"), 0.03)}
\keyword{misc}

