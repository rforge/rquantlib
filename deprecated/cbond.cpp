// -*- mode: c++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- 
//
// RQuantLib -- R interface to the QuantLib libraries
//
// Copyright (C) 2009 - 2010  Dirk Eddelbuettel and Khanh Nguyen
//
// $Id$
//
// This file is part of the RQuantLib library for GNU R.
// It is made available under the terms of the GNU General Public
// License, version 2, or at your option, any later version,
// incorporated herein by reference.
//
// This program is distributed in the hope that it will be
// useful, but WITHOUT ANY WARRANTY; without even the implied
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
// PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public
// License along with this program; if not, write to the Free
// Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
// MA 02111-1307, USA

#include <rquantlib.hpp>

using namespace boost;

RcppExport SEXP cbprice(SEXP params, SEXP dividendFrame, SEXP callFrame) {
    
    try {
		Rcpp::List rparams(params);

        double rff = Rcpp::as<double>(rparams["rff"]);
        double spread = Rcpp::as<double>(rparams["spread"]);
        double sigma = Rcpp::as<double>(rparams["sigma"]);
        double price = Rcpp::as<double>(rparams["price"]);
        double convRatio = Rcpp::as<double>(rparams["convRatio"]);
        double numSteps = Rcpp::as<double>(rparams["numSteps"]);
        QuantLib::Date maturity(dateFromR(Rcpp::as<RcppDate>(rparams["maturity"])));
        QuantLib::Date settle(dateFromR(Rcpp::as<RcppDate>(rparams["settle"])));
        QuantLib::Date issue(dateFromR(Rcpp::as<RcppDate>(rparams["issue"])));
        double coupon = Rcpp::as<double>(rparams["couponRate"]);
        double p = Rcpp::as<double>(rparams["period"]);
        double basis = Rcpp::as<double>(rparams["basis"]);
        DayCounter dayCounter = getDayCounter(basis);
        Frequency freq = getFrequency(p);
        Period period(freq);
        //double emr = Rcpp::as<double>(rparams["emr"]);
        double callType = Rcpp::as<double>(rparams["calltype"]);
        double dividendType = Rcpp::as<double>(rparams["dividendtype"]);
        //double treeType = Rcpp::as<double>(rparams["treeType"]);        


        DividendSchedule dividendSchedule;
        try {
            RcppFrame frame(dividendFrame);
            std::vector<std::vector<ColDatum> >  table = frame.getTableData();
            int nrow = table.size();

            for (int row = 0; row < nrow; row++){
                QuantLib::Date d(dateFromR(table[row][0].getDateValue()));            
                double value = table[row][1].getDoubleValue();
                if (dividendType == 0) {
                    dividendSchedule.push_back(
                                               boost::shared_ptr<Dividend>(
                                                                           new FixedDividend(value, d)));                    
                }
                else {
                    dividendSchedule.push_back(
                                               boost::shared_ptr<Dividend>(new FractionalDividend(value, d)));                    
                }
            }
        }
        catch (std::exception& ex) { }

        CallabilitySchedule callabilitySchedule;
        try {
            RcppFrame frame(callFrame);
            std::vector<std::vector<ColDatum> >  table = frame.getTableData();
            int nrow = table.size();

            for (int row = 0; row < nrow; row++){
                QuantLib::Date d(dateFromR(table[row][0].getDateValue()));            
                double price = table[row][1].getDoubleValue();
                if (callType == 0) {
                    callabilitySchedule.push_back(boost::shared_ptr<Callability>
                                                  (new Callability(Callability::Price(price, 
                                                                                      Callability::Price::Clean),
                                                                   Callability::Call,d )));
                }
                else {
                    callabilitySchedule.push_back(boost::shared_ptr<Callability>
                                                  (new Callability(Callability::Price(price, 
                                                                                      Callability::Price::Clean),
                                                                   Callability::Put,d )));                    
                }
            }
        }
        catch (std::exception& ex){}

        Calendar calendar = UnitedStates(UnitedStates::GovernmentBond);	// FIXME
        QuantLib::Integer fixingDays = 1;
        Date todayDate = calendar.advance(settle, -fixingDays, Days);
        Settings::instance().evaluationDate() = todayDate;

        RelinkableHandle<Quote> underlying;
        RelinkableHandle<BlackVolTermStructure> volatility;
        RelinkableHandle<YieldTermStructure> riskFree;
        underlying.linkTo(boost::shared_ptr<Quote>(new SimpleQuote(price)));
        volatility.linkTo(flatVol(todayDate,  
                                  boost::shared_ptr<SimpleQuote>(new SimpleQuote(sigma)), 
                                  dayCounter));
        
        riskFree.linkTo(flatRate(todayDate, boost::shared_ptr<SimpleQuote>(new SimpleQuote(rff)), dayCounter));
        
        boost::shared_ptr<BlackScholesProcess> blackProcess;
        blackProcess = boost::shared_ptr<BlackScholesProcess>(
                                                                    new BlackScholesProcess(underlying, 
                                                                                                  riskFree, volatility));


        RelinkableHandle<Quote> creditSpread;
        creditSpread.linkTo(
                            boost::shared_ptr<Quote>(new SimpleQuote(spread)));

        boost::shared_ptr<Exercise> ex(
                                       new AmericanExercise(issue,
                                                            maturity));
        Size timeSteps = numSteps;
        boost::shared_ptr<PricingEngine> engine(
                                                new BinomialConvertibleEngine<CoxRossRubinstein>(blackProcess,
                                                                                                 timeSteps));

        
        Schedule sch(issue, maturity, period, calendar, Following,
                     Following, DateGeneration::Backward, false);
        std::vector<double> rates;
        rates.push_back(coupon);
        ConvertibleFixedCouponBond bond(ex, convRatio,
                                        dividendSchedule, 
                                        callabilitySchedule,
                                        creditSpread, 
                                        issue, 1, rates,
                                        dayCounter, sch, 100);
        
        bond.setPricingEngine(engine);

        return Rcpp::wrap(bond.NPV());

    } catch(std::exception &ex) { 
        forward_exception_to_r(ex); 
    } catch(...) { 
        ::Rf_error("c++ exception (unknown reason)"); 
    }

    return R_NilValue;
}
