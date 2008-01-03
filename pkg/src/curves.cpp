#ifndef _MSC_VER
#include <stdexcept>
#endif

#include "rquantlib.hpp"

// Database of interest rate instrument contract details.
ObservableDB::ObservableDB() {
    db_["d1w"] = new RQLObservable(RQLDeposit, 1, 0, Weeks);
    db_["d1m"] = new RQLObservable(RQLDeposit, 1, 0, Months);
    db_["d2m"] = new RQLObservable(RQLDeposit, 2, 0, Months);
    db_["d3m"] = new RQLObservable(RQLDeposit, 3, 0, Months);
    db_["d6m"] = new RQLObservable(RQLDeposit, 6, 0, Months);
    db_["d9m"] = new RQLObservable(RQLDeposit, 9, 0, Months);
    db_["d1y"] = new RQLObservable(RQLDeposit, 1, 0, Years);
    db_["s2y"] = new RQLObservable(RQLSwap, 2, 0, Years);
    db_["s3y"] = new RQLObservable(RQLSwap, 3, 0, Years);
    db_["s5y"] = new RQLObservable(RQLSwap, 5, 0, Years);
    db_["s10y"] = new RQLObservable(RQLSwap, 10, 0, Years);
    db_["s15y"] = new RQLObservable(RQLSwap, 15, 0, Years);
    db_["s20y"] = new RQLObservable(RQLSwap, 20, 0, Years);
    db_["s30y"] = new RQLObservable(RQLSwap, 30, 0, Years);
    db_["fut1"] = new RQLObservable(RQLFuture, 1, 0, Months);
    db_["fut2"] = new RQLObservable(RQLFuture, 2, 0, Months);
    db_["fut3"] = new RQLObservable(RQLFuture, 3, 0, Months);
    db_["fut4"] = new RQLObservable(RQLFuture, 4, 0, Months);
    db_["fut5"] = new RQLObservable(RQLFuture, 5, 0, Months);
    db_["fut6"] = new RQLObservable(RQLFuture, 6, 0, Months);
    db_["fut7"] = new RQLObservable(RQLFuture, 7, 0, Months);
    db_["fut8"] = new RQLObservable(RQLFuture, 8, 0, Months);
    db_["fra3x6"] = new RQLObservable(RQLFRA, 3, 6, Months);
    db_["fra6x9"] = new RQLObservable(RQLFRA, 6, 9, Months);
    db_["fra6x12"] = new RQLObservable(RQLFRA, 6, 12, Months);
}


// Get RateHelper used to build the yield curve corresponding to a
// database key ('ticker') and observed rate/price.
boost::shared_ptr<RateHelper> ObservableDB::getRateHelper(string ticker, Rate r) {
    RQLMapIterator iter = db_.find(ticker);
    if(iter == db_.end()) {
	NULL;
    }
    RQLObservable *p = iter->second;
    RQLObservableType type = p->getType();
    int n1 = p->getN1(), n2 = p->getN2();
    TimeUnit units = p->getUnits();

    Date settlementDate = RQLContext::instance().settleDate;
    Calendar calendar = RQLContext::instance().calendar;
    Integer fixingDays = RQLContext::instance().fixingDays;
    DayCounter depositDayCounter = Actual360();

    // Tried to use a switch statement here, but there was an
    // internal compiler error using g++ Version 3.2.2.
    if(type == RQLDeposit) {
	boost::shared_ptr<Quote> quote(new SimpleQuote(r));
	boost::shared_ptr<RateHelper> depo(new DepositRateHelper(
	    Handle<Quote>(quote),
            n1, units, fixingDays,	
            calendar, ModifiedFollowing, depositDayCounter));
	return depo;
    }
    else if(type == RQLSwap) {
	Frequency swFixedLegFrequency = Annual;
	BusinessDayConvention swFixedLegConvention = Unadjusted;
	DayCounter swFixedLegDayCounter = Thirty360(Thirty360::European);
	Frequency swFloatingLegFrequency = Semiannual;
	boost::shared_ptr<Quote> quote(new SimpleQuote(r));
	boost::shared_ptr<RateHelper> swap(new SwapRateHelper(
            Handle<Quote>(quote),
            n1, units, fixingDays,
            calendar, swFixedLegFrequency,
            swFixedLegConvention, swFixedLegDayCounter,
            swFloatingLegFrequency, ModifiedFollowing));
	return swap;
    }
    else if(type == RQLFuture) {
	Integer futMonths = 3;
	Date imm = Date::nextIMMdate(settlementDate);
	for(int i = 1; i < n1; i++)
	    imm = Date::nextIMMdate(imm+1);
	boost::shared_ptr<Quote> quote(new SimpleQuote(r));
	boost::shared_ptr<RateHelper> future(new FuturesRateHelper(
	    Handle<Quote>(quote),
            imm,
            futMonths, calendar, ModifiedFollowing,
            depositDayCounter));
	return future;
    }
    else if(type == RQLFRA) {
	boost::shared_ptr<Quote> quote(new SimpleQuote(r));
	boost::shared_ptr<RateHelper> FRA(new FraRateHelper(
            Handle<Quote>(quote),
            n1, n2, fixingDays, calendar, ModifiedFollowing,
            depositDayCounter));
	return FRA;
    }
    else {
	throw range_error("Bad type in curve construction");
    }
}

// Return the term structure built using a set of RateHelpers (curveInput)
// employing the specified interpolation method and day counter.
boost::shared_ptr<YieldTermStructure> getTermStructure
(char *interpWhat, char *interpHow, const Date& settlementDate,
const std::vector<boost::shared_ptr<RateHelper> >& curveInput,
 DayCounter& dayCounter, Real tolerance) {
    
    if(strcmp(interpWhat,"discount") == 0 &&
       strcmp(interpHow,"linear") == 0) {
	boost::shared_ptr<YieldTermStructure> ts(new
	       PiecewiseYieldCurve<Discount,Linear>(settlementDate, 
	       curveInput, dayCounter, tolerance));
	return ts;
    }
    else if(strcmp(interpWhat,"discount") == 0 &&
       strcmp(interpHow,"loglinear") == 0) {
	boost::shared_ptr<YieldTermStructure> ts(new
	       PiecewiseYieldCurve<Discount,LogLinear>(settlementDate, 
	       curveInput, dayCounter, tolerance));
	return ts;
    }
    else if(strcmp(interpWhat,"discount") == 0 &&
       strcmp(interpHow,"spline") == 0) {
	boost::shared_ptr<YieldTermStructure> ts(new
	       PiecewiseYieldCurve<Discount,Cubic>(settlementDate, 
	       curveInput, dayCounter, tolerance));
	return ts;
    }
    else if(strcmp(interpWhat,"forward") == 0 &&
       strcmp(interpHow,"linear") == 0) {
	boost::shared_ptr<YieldTermStructure> ts(new
	       PiecewiseYieldCurve<ForwardRate,Linear>(settlementDate, 
	       curveInput, dayCounter, tolerance));
	return ts;
    }
    else if(strcmp(interpWhat,"forward") == 0 &&
       strcmp(interpHow,"loglinear") == 0) {
	boost::shared_ptr<YieldTermStructure> ts(new
	       PiecewiseYieldCurve<ForwardRate,LogLinear>(settlementDate, 
	       curveInput, dayCounter, tolerance));
	return ts;
    }
    else if(strcmp(interpWhat,"forward") == 0 &&
       strcmp(interpHow,"spline") == 0) {
	boost::shared_ptr<YieldTermStructure> ts(new
	       PiecewiseYieldCurve<ForwardRate,Cubic>(settlementDate, 
	       curveInput, dayCounter, tolerance));
	return ts;
    }
    else if(strcmp(interpWhat,"zero") == 0 &&
       strcmp(interpHow,"linear") == 0) {
	boost::shared_ptr<YieldTermStructure> ts(new
	       PiecewiseYieldCurve<ZeroYield,Linear>(settlementDate, 
	       curveInput, dayCounter, tolerance));
	return ts;
    }
    else if(strcmp(interpWhat,"zero") == 0 &&
       strcmp(interpHow,"loglinear") == 0) {
	boost::shared_ptr<YieldTermStructure> ts(new
	       PiecewiseYieldCurve<ZeroYield,LogLinear>(settlementDate, 
	       curveInput, dayCounter, tolerance));
	return ts;
    }
    else if(strcmp(interpWhat,"zero") == 0 &&
       strcmp(interpHow,"spline") == 0) {
	boost::shared_ptr<YieldTermStructure> ts(new
	       PiecewiseYieldCurve<ZeroYield,Cubic>(settlementDate, 
	       curveInput, dayCounter, tolerance));
	return ts;
    }
    else {
	throw range_error("What/How term structure options not recognized");
    }
}
