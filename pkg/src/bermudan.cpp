// Dominick Samperi, 9/5/2005

#include "rquantlib.hpp"

// Calibrates underlying swaptions to the input volatility matrix.
void calibrateModel(const boost::shared_ptr<ShortRateModel>& model,
                    const std::vector<boost::shared_ptr<CalibrationHelper> >&
                                                                      helpers,
                    Real lambda,
		    int *swaptionMat, int *swapLengths, double **swaptionVols,
		    Size numRows, Size numCols) {

    Simplex om(lambda, 1e-9);
    om.setEndCriteria(EndCriteria(10000, 1e-7));
    model->calibrate(helpers, om);

    // Output the implied Black volatilities
    for (Size i=0; i<numRows; i++) {
	Real npv = helpers[i]->modelValue();
	Volatility implied = helpers[i]->impliedVolatility(npv, 1e-4,
                                                           1000, 0.05, 0.50);
	Volatility diff = implied - swaptionVols[i][numCols-i-1];

	Rprintf("%dx%d: model %lf, market %lf, diff %lf\n",
		swaptionMat[i], swapLengths[numCols-i-1], implied, 
		swaptionVols[i][numCols-i-1], diff);
    }	
}	

RQLExport SEXP QL_BermudanSwaption(SEXP params, SEXP tsQuotes, 
				       SEXP maturities, SEXP tenors, 
				       SEXP vols) {
    SEXP rl;
    int *swaptionMat, *swapLengths;
    double **swaptionVols;

    try {

	Size i;

	double notional = 10000; // prices in basis points

	Date todaysDate = getDateValueAt(params, 0);
	Date settlementDate = getDateValueAt(params, 1);
	RQLContext::instance().settleDate = settlementDate;
        Settings::instance().evaluationDate() = todaysDate;

	int payFixed = getIntValueAt(params, 2);
	bool payFixedRate = (payFixed == 1) ? true : false;

	double strike = getDoubleValueAt(params, 3);

	char *method = getStringValueAt(params, 4);

	char *firstQuoteName = getNameAt(tsQuotes,0);

	char *interpWhat, *interpHow;
	if(strcmp(firstQuoteName,"flat") != 0) {

	    // Get interpolation method (not needed for "flat" case)
	    interpWhat = getStringValueAt(params, 5);
	    interpHow  = getStringValueAt(params, 6);
	    if(interpWhat == NULL || interpHow == NULL ||
	       strlen(interpWhat) == 0 || strlen(interpHow) == 0)
		error("Curve construction interpWhat/interpHow not set");

	}

        Calendar calendar = TARGET();
        Integer fixingDays = 2;
	RQLContext::instance().calendar = calendar;
	RQLContext::instance().fixingDays = fixingDays;

	// Any DayCounter would be fine.
	// ActualActual::ISDA ensures that 30 years is 30.0
	DayCounter termStructureDayCounter =
	    ActualActual(ActualActual::ISDA);
	double tolerance = 1.0e-15;

	boost::shared_ptr<YieldTermStructure> curve;
	if(strcmp(firstQuoteName,"flat") == 0) {
	    // Get flat yield curve
	    double rateQuote = getDoubleValueAt(tsQuotes,0);
	    boost::shared_ptr<Quote> flatRate(new SimpleQuote(rateQuote));
	    boost::shared_ptr<FlatForward> ts(new FlatForward(settlementDate,
					      Handle<Quote>(flatRate),
					      Actual365Fixed()));
	    curve = ts;
	}
	else {
	    // Get yield curve based on a set of market rates and/or prices.
	    std::vector<boost::shared_ptr<RateHelper> > curveInput;
	    for(i = 0; i < (Size)length(tsQuotes); i++) {
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
	Handle<YieldTermStructure> rhTermStructure;
	rhTermStructure.linkTo(curve);

	// Get swaption vol matrix.
	int dim1, dim2;
	swaptionVols = allocDoubleMatrix(vols, &dim1, &dim2);
	if(swaptionVols == NULL)
	    error("Null swaption volatility matrix\n");

	// Get swaption maturities
	int numRows;
	swaptionMat = allocIntVector(maturities, &numRows);
	if(swaptionMat == NULL)
	    error("Swaption maturity vector is empty\n");

	// Get swap tenors
	int numCols;
	swapLengths = allocIntVector(tenors, &numCols);
	if(swapLengths == NULL)
	    error("Swap tenor vector is empty\n");

	if(numRows*numCols != dim1*dim2) {
	    Rprintf("Swaption vol matrix size (%d x %d) incompatible\nwith size of swaption maturity vector (%d) and swap tenor vector (%d)\n", dim1, dim2,
		  numRows, numCols);
	    throw RQLException("hello world");
	}

	// Create dummy swap to get schedules.
        Frequency fixedLegFrequency = Annual;
        BusinessDayConvention fixedLegConvention = Unadjusted;
        BusinessDayConvention floatingLegConvention = ModifiedFollowing;
        DayCounter fixedLegDayCounter = Thirty360(Thirty360::European);
        Frequency floatingLegFrequency = Semiannual;
        Rate dummyFixedRate = 0.03;
        boost::shared_ptr<Xibor> indexSixMonths(new
            Euribor(6, Months, rhTermStructure));

        Date startDate = calendar.advance(settlementDate,1,Years,
                                          floatingLegConvention);
        Date maturity = calendar.advance(startDate,5,Years,
                                         floatingLegConvention);
        Schedule fixedSchedule(calendar,startDate,maturity,
                               fixedLegFrequency,fixedLegConvention);
        Schedule floatSchedule(calendar,startDate,maturity,
                               floatingLegFrequency,floatingLegConvention);
        boost::shared_ptr<SimpleSwap> swap(new SimpleSwap(
            payFixedRate, notional,
            fixedSchedule, dummyFixedRate, fixedLegDayCounter,
            floatSchedule, indexSixMonths, fixingDays, 0.0,
            rhTermStructure));

	// Find the ATM or break-even rate
        Rate fixedATMRate = swap->fairRate();

	Rate fixedRate;
	if(strike < 0) // factor instead of real strike
	    fixedRate = fixedATMRate * (-strike);
	else
	    fixedRate = strike;

	// The swap underlying the Bermudan swaption.
        boost::shared_ptr<SimpleSwap> mySwap(new SimpleSwap(
            payFixedRate, notional,
            fixedSchedule, fixedRate, fixedLegDayCounter,
            floatSchedule, indexSixMonths, fixingDays, 0.0,
            rhTermStructure));

	// Build swaptions that will be used to calibrate model to
	// the volatility matrix.
        std::vector<Period> swaptionMaturities;
	for(i = 0; i < (Size)numRows; i++)
	    swaptionMaturities.push_back(Period(swaptionMat[i], Years));

	// Swaptions used for calibration
        std::vector<boost::shared_ptr<CalibrationHelper> > swaptions;

        // List of times that have to be included in the timegrid
        std::list<Time> times;
        for (i=0; i<(Size)numRows; i++) { // 1x5, 2x4, 3x3, 4x2, 5x1
            boost::shared_ptr<Quote> vol(new SimpleQuote(swaptionVols[i][numCols-i-1]));
            swaptions.push_back(boost::shared_ptr<CalibrationHelper>(new
                SwaptionHelper(swaptionMaturities[i],
                               Period(swapLengths[numCols-i-1], Years),
                               Handle<Quote>(vol),
                               indexSixMonths,
                               indexSixMonths->frequency(),
                               indexSixMonths->dayCounter(),
                               rhTermStructure)));
            swaptions.back()->addTimesTo(times);
        }

        // Building time-grid
        TimeGrid grid(times.begin(), times.end(), 30);

	// Get Bermudan swaption exercise dates.
        std::vector<Date> bermudanDates;
        const std::vector<boost::shared_ptr<CashFlow> >& leg =
            swap->fixedLeg();
        for (i=0; i<leg.size(); i++) {
            boost::shared_ptr<Coupon> coupon =
                boost::dynamic_pointer_cast<Coupon>(leg[i]);
            bermudanDates.push_back(coupon->accrualStartDate());
        }
        boost::shared_ptr<Exercise> bermudaExercise(new
            BermudanExercise(bermudanDates));

	// Price based on method selected.
	if(strcmp(method,"G2Analytic") == 0) {
	    boost::shared_ptr<G2> modelG2(new G2(rhTermStructure));
	    Rprintf("G2/Jamshidian (analytic) calibration\n");
	    for(i = 0; i < swaptions.size(); i++)
		swaptions[i]->setPricingEngine(boost::shared_ptr<PricingEngine>(
                new G2SwaptionEngine(modelG2, 6.0, 16)));
	    calibrateModel(modelG2, swaptions, 0.05, 
			   swaptionMat,swapLengths, swaptionVols, 
			   numRows, numCols);
	    Swaption bermudanSwaption(mySwap, bermudaExercise, 
				      rhTermStructure,
				      boost::shared_ptr<PricingEngine>());
	    bermudanSwaption.setPricingEngine
		(boost::shared_ptr<PricingEngine>(new TreeSwaptionEngine(modelG2, 50)));
	    list<pair<string,double> > values;
	    values.push_back(make_pair("a", modelG2->params()[0]));
	    values.push_back(make_pair("sigma", modelG2->params()[1]));
	    values.push_back(make_pair("b", modelG2->params()[2]));
	    values.push_back(make_pair("eta", modelG2->params()[3]));
	    values.push_back(make_pair("rho", modelG2->params()[4]));
	    values.push_back(make_pair("price", bermudanSwaption.NPV()));
	    values.push_back(make_pair("ATMStrike", fixedATMRate));
	    rl = makeReturnList(values, params);
	}
	else if(strcmp(method,"HWAnalytic") == 0) {
	    boost::shared_ptr<HullWhite> modelHW(new HullWhite(rhTermStructure));
	    Rprintf("Hull-White (analytic) calibration\n");
	    for (i=0; i<swaptions.size(); i++)
		swaptions[i]->setPricingEngine(boost::shared_ptr<PricingEngine>(
                new JamshidianSwaptionEngine(modelHW)));
	    calibrateModel(modelHW, swaptions, 0.05, 
			   swaptionMat, swapLengths, swaptionVols, 
			   numRows, numCols);
	    Swaption bermudanSwaption(mySwap, bermudaExercise, 
				      rhTermStructure,
				      boost::shared_ptr<PricingEngine>());
	    bermudanSwaption.setPricingEngine
		(boost::shared_ptr<PricingEngine>(new TreeSwaptionEngine(modelHW, 50)));
	    list<pair<string,double> > values;
	    values.push_back(make_pair("a", modelHW->params()[0]));
	    values.push_back(make_pair("sigma", modelHW->params()[1]));
	    values.push_back(make_pair("price", bermudanSwaption.NPV()));
	    values.push_back(make_pair("ATMStrike", fixedATMRate));
	    rl = makeReturnList(values, params);
	}
	else if(strcmp(method, "HWTree") == 0) {
	    boost::shared_ptr<HullWhite> modelHW2(new HullWhite(rhTermStructure));
	    Rprintf("Hull-White (tree) calibration\n");
	    for (i=0; i<swaptions.size(); i++)
            swaptions[i]->setPricingEngine(boost::shared_ptr<PricingEngine>(
                new TreeSwaptionEngine(modelHW2,grid)));

	    calibrateModel(modelHW2, swaptions, 0.05, 
			   swaptionMat, swapLengths, swaptionVols, 
			   numRows, numCols);
	    Swaption bermudanSwaption(mySwap, bermudaExercise, 
				      rhTermStructure,
				      boost::shared_ptr<PricingEngine>());
	    bermudanSwaption.setPricingEngine
		(boost::shared_ptr<PricingEngine>(new TreeSwaptionEngine(modelHW2, 50)));
	    list<pair<string,double> > values;
	    values.push_back(make_pair("a", modelHW2->params()[0]));
	    values.push_back(make_pair("sigma", modelHW2->params()[1]));
	    values.push_back(make_pair("price", bermudanSwaption.NPV()));
	    values.push_back(make_pair("ATMStrike", fixedATMRate));
	    rl = makeReturnList(values, params);
	}
	else if(strcmp(method, "BKTree") == 0) {
	    boost::shared_ptr<BlackKarasinski> modelBK(new
		    BlackKarasinski(rhTermStructure));
	    Rprintf("Black-Karasinski (tree) calibration\n");
	    for (i=0; i<swaptions.size(); i++)
            swaptions[i]->setPricingEngine(boost::shared_ptr<PricingEngine>(
                new TreeSwaptionEngine(modelBK,grid)));
	    calibrateModel(modelBK, swaptions, 0.05, 
			   swaptionMat, swapLengths, swaptionVols, 
			   numRows, numCols);
	    Swaption bermudanSwaption(mySwap, bermudaExercise, 
				      rhTermStructure,
				      boost::shared_ptr<PricingEngine>());
	    bermudanSwaption.setPricingEngine
		(boost::shared_ptr<PricingEngine>(new TreeSwaptionEngine(modelBK, 50)));
	    list<pair<string,double> > values;
	    values.push_back(make_pair("a", modelBK->params()[0]));
	    values.push_back(make_pair("sigma", modelBK->params()[1]));
	    values.push_back(make_pair("price", bermudanSwaption.NPV()));
	    values.push_back(make_pair("ATMStrike", fixedATMRate));
	    rl = makeReturnList(values, params);
	}
	else {
	    error("Unknown method in BermudanSwaption\n");
	}
    } catch(RQLException& e) {
	    error("RQuantLib Exception: %s\n", e.what());
    } catch(std::exception& e) {
	    error("QuantLib exception: %s\n", e.what());
    } catch(...) {
	error("QuantLib exception: unknown reason\n");
    }

    // OK to free non-garbage collected storage...
    freeDoubleMatrix(swaptionVols);
    free(swapLengths);
    free(swaptionMat);

    return rl;
}

