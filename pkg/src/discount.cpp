//  RQuantLib function DiscountCurve
//
//  Copyright (C) 2005  Dominick Samperi
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation; either version 2 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

#include "rquantlib.hpp"

RQLExport SEXP QL_DiscountCurve(SEXP params, SEXP tsQuotes,
				     SEXP times) {
    SEXP rl;

    try {

	int i;

	Date todaysDate = getDateValueAt(params, 0);
	Date settlementDate = getDateValueAt(params, 1);
	RQLContext::instance().settleDate = settlementDate;
	Settings::instance().evaluationDate() = todaysDate;

	char *firstQuoteName = getNameAt(tsQuotes,0);

	double dt = getDoubleValueAt(params,2);
	
	char *interpWhat, *interpHow;
	if(strcmp(firstQuoteName,"flat") != 0) {

	    // Get interpolation method (not needed for "flat" case)
	    interpWhat = getStringValueAt(params,3);
	    interpHow  = getStringValueAt(params,4);
	    if(interpWhat == NULL || interpHow == NULL ||
	       strlen(interpWhat) == 0 || strlen(interpHow) == 0)
		error("Curve construction interpWhat/interpHow not set");
	    
	}

        Calendar calendar = TARGET();
	RQLContext::instance().calendar = calendar;
        Integer fixingDays = 2;
	RQLContext::instance().fixingDays = fixingDays;

	// Any DayCounter would be fine.
	// ActualActual::ISDA ensures that 30 years is 30.0
	DayCounter termStructureDayCounter =
	    ActualActual(ActualActual::ISDA);
	double tolerance = 1.0e-15;

	boost::shared_ptr<YieldTermStructure> curve;
	if(strcmp(firstQuoteName,"flat") == 0) {
	    // Create a flat term structure.
	    double rateQuote = getDoubleValueAt(tsQuotes,0);
	    boost::shared_ptr<Quote> flatRate(new SimpleQuote(rateQuote));
	    boost::shared_ptr<FlatForward> ts(new FlatForward(settlementDate,
					      Handle<Quote>(flatRate),
					      Actual365Fixed()));
	    curve = ts;
	}
	else {
	    // Build curve based on a set of observed rates and/or prices.
	    std::vector<boost::shared_ptr<RateHelper> > curveInput;
	    for(i = 0; i < length(tsQuotes); i++) {
		char *name = getNameAt(tsQuotes,i);
		double val = getDoubleValueAt(tsQuotes,i);
		boost::shared_ptr<RateHelper> rh = 
		    ObservableDB::instance().getRateHelper(name, val);
		curveInput.push_back(rh);
	    }
	    boost::shared_ptr<YieldTermStructure> ts =
		getTermStructure(interpWhat, interpHow, 
			      settlementDate, curveInput,
			      termStructureDayCounter, tolerance);
	    curve = ts;
	}

	// Return discount, forward rate, and zero coupon curves
	PROTECT(times);
	int ntimes = length(times);
	SEXP disc  = PROTECT(allocVector(REALSXP, ntimes));
	SEXP fwds  = PROTECT(allocVector(REALSXP, ntimes));
	SEXP zero  = PROTECT(allocVector(REALSXP, ntimes));
	double t;
	for(i = 0; i < ntimes; i++) {
	    t = REAL(times)[i];
	    REAL(disc)[i] = curve->discount(t);
	    REAL(fwds)[i] = curve->forwardRate(t, t+dt, Continuous);
	    REAL(zero)[i] = curve->zeroRate(t, Continuous);
	}

	list<pair<string,SEXP> > values;
	values.push_back(make_pair("times", times));
	values.push_back(make_pair("discounts", disc));
	values.push_back(make_pair("forwards", fwds));
	values.push_back(make_pair("zerorates", zero));

	rl = makeReturnList(values, params);
	UNPROTECT(4);

    } catch(RQLException& e) {
	error("RQuantLib Exception: %s\n", e.what());
    } catch(std::exception& e) {
	error("QuantLib exception: %s\n", e.what());
    } catch(...) {
	error("QuantLib exception: unknown reason\n");
    }
    
    return rl;
}

