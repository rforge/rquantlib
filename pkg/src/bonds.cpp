/* RQuantLib -- R interface to the QuantLib libraries
##
## Copyright (C) 2002 - 2009 Dirk Eddelbuettel <edd@debian.org>
## Copyright (C) 2009        Khanh Nguyen <knguyen@cs.umb.edu>
##
## $Id$
##
## This file is part of the RQuantLib library for GNU R.
## It is made available under the terms of the GNU General Public
## License, version 2, or at your option, any later version,
## incorporated herein by reference.
##
## This program is distributed in the hope that it will be
## useful, but WITHOUT ANY WARRANTY; without even the implied
## warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
## PURPOSE.  See the GNU General Public License for more
## details.
##
## You should have received a copy of the GNU General Public
## License along with this program; if not, write to the Free
## Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
## MA 02111-1307, USA
*/

#include "rquantlib.hpp"
using namespace boost;


RcppExport  SEXP QL_ZeroPriceByYield(SEXP optionParameters) {
    SEXP rl = R_NilValue;
    char* exceptionMesg=NULL;
    try{
       RcppParams rparam(optionParameters);
       double yield = rparam.getDoubleValue("yield");
       double faceAmount = rparam.getDoubleValue("faceAmount");
       double dayCounter = rparam.getDoubleValue("dayCounter");
       double frequency = rparam.getDoubleValue("frequency");
       double businessDayConvention = rparam.getDoubleValue("businessDayConvention");
       double compound = rparam.getDoubleValue("compound");
       RcppDate mDate = rparam.getDateValue("maturityDate");
       RcppDate iDate = rparam.getDateValue("issueDate");
       QuantLib::Date maturityDate(dateFromR(mDate));
       QuantLib::Date issueDate(dateFromR(iDate));
       //setup bond
       QuantLib::Integer fixingDays = 2;
       Calendar calendar=UnitedStates(UnitedStates::GovernmentBond);
       Date todaysDate = calendar.advance(issueDate, -fixingDays, Days);
       Settings::instance().evaluationDate() = todaysDate;
       Natural settlementDays = 1;
       
       BusinessDayConvention bdc = getBusinessDayConvention(businessDayConvention);
       double redemption = 100;
       ZeroCouponBond zbond(settlementDays, calendar,
                            faceAmount, maturityDate,
                            bdc, redemption, issueDate);
       
       //return cleanPrice
       RcppResultSet rs;
       DayCounter dc = getDayCounter(dayCounter);
       Compounding cp = getCompounding(compound);
       Frequency freq = getFrequency(frequency);
       rs.add("cleanPrice", zbond.cleanPrice(yield, dc, cp, freq));
       rl = rs.getReturnList();
    } catch(std::exception& ex) {
        exceptionMesg = copyMessageToR(ex.what());
    } catch(...) {
        exceptionMesg = copyMessageToR("unknown reason");
    }
    
    if(exceptionMesg != NULL)
        error(exceptionMesg);
    
    return rl;
}

RcppExport  SEXP QL_ZeroYield(SEXP optionParameters) {
    SEXP rl = R_NilValue;
    char* exceptionMesg=NULL;
    try{
       RcppParams rparam(optionParameters);
       double price = rparam.getDoubleValue("price");
       double faceAmount = rparam.getDoubleValue("faceAmount");
       double dayCounter = rparam.getDoubleValue("dayCounter");
       double frequency = rparam.getDoubleValue("frequency");
       double businessDayConvention = rparam.getDoubleValue("businessDayConvention");
       double compound = rparam.getDoubleValue("compound");
       RcppDate mDate = rparam.getDateValue("maturityDate");
       RcppDate iDate = rparam.getDateValue("issueDate");
       QuantLib::Date maturityDate(dateFromR(mDate));
       QuantLib::Date issueDate(dateFromR(iDate));
       //setup bond
       QuantLib::Integer fixingDays = 2;
       Calendar calendar=UnitedStates(UnitedStates::GovernmentBond);
       Date todaysDate = calendar.advance(issueDate, -fixingDays, Days);
       Settings::instance().evaluationDate() = todaysDate;
       Natural settlementDays = 1;
       
       BusinessDayConvention bdc = getBusinessDayConvention(businessDayConvention);
       double redemption = 100;
       ZeroCouponBond zbond(settlementDays, calendar,
                            faceAmount, maturityDate,
                            bdc, redemption, issueDate);
       
       //return yield
       RcppResultSet rs;
       DayCounter dc = getDayCounter(dayCounter);
       Compounding cp = getCompounding(compound);
       Frequency freq = getFrequency(frequency);
       rs.add("yield", zbond.yield(price, dc, cp, freq));
       rl = rs.getReturnList();
    } catch(std::exception& ex) {
        exceptionMesg = copyMessageToR(ex.what());
    } catch(...) {
        exceptionMesg = copyMessageToR("unknown reason");
    }
    
    if(exceptionMesg != NULL)
        error(exceptionMesg);
    
    return rl;
}


SEXP ZeroBond(SEXP bondparam, 
              Handle<YieldTermStructure> &discountCurve,
              SEXP dateparams) {

    SEXP rl=R_NilValue;
    char* exceptionMesg=NULL;
    try{
        RcppParams rparam(bondparam);
        double faceAmount = rparam.getDoubleValue("faceAmount");
        RcppDate mDate = rparam.getDateValue("maturityDate");
        RcppDate iDate = rparam.getDateValue("issueDate");
        QuantLib::Date maturityDate(dateFromR(mDate));
        QuantLib::Date issueDate(dateFromR(iDate));
        double redemption = rparam.getDoubleValue("redemption");

        RcppParams misc(dateparams);
        double settlementDays = misc.getDoubleValue("settlementDays");
        std::string cal = misc.getStringValue("calendar");
        double businessDayConvention = misc.getDoubleValue("businessDayConvention");
      

        
        /*
          test-suite/bonds.cpp
        */      

        //set up BusinessDayConvetion
        BusinessDayConvention bdc = getBusinessDayConvention(businessDayConvention);
        
        //set up calendar
        Calendar calendar = UnitedStates(UnitedStates::GovernmentBond);
        if (cal == "us"){
            calendar = UnitedStates(UnitedStates::GovernmentBond);
        }
        else if (cal == "uk"){
            calendar = UnitedKingdom(UnitedKingdom::Exchange);
        }
        
        
        ZeroCouponBond bond(settlementDays,
                            calendar,
                            faceAmount,
                            maturityDate,
                            bdc,
                            redemption, issueDate);
        
        boost::shared_ptr<PricingEngine> bondEngine(
                                                    new DiscountingBondEngine(discountCurve));
        bond.setPricingEngine(bondEngine);

        //cashflow
        int numCol = 2;
        std::vector<std::string> colNames(numCol);
        colNames[0] = "Date";
        colNames[1] = "Amount";
        RcppFrame frame(colNames);
        
        Leg bondCashFlow = bond.cashflows();
        for (unsigned int i = 0; i< bondCashFlow.size(); i++){
            std::vector<ColDatum> row(numCol);
            Date d = bondCashFlow[i]->date();
            row[0].setDateValue(RcppDate(d.month(), d.dayOfMonth(), d.year()));
            row[1].setDoubleValue(bondCashFlow[i]->amount());
            frame.addRow(row);
        }

        
        RcppResultSet rs;
        rs.add("NPV", bond.NPV());
        rs.add("cleanPrice", bond.cleanPrice());
        rs.add("dirtyPrice", bond.dirtyPrice());
        rs.add("accruedCoupon", bond.accruedAmount());
        rs.add("yield", bond.yield(Actual360(), Compounded, Annual));
        rs.add("cashFlow", frame);
        rl = rs.getReturnList();
    } catch(std::exception& ex) {
        exceptionMesg = copyMessageToR(ex.what());
    } catch(...) {
        exceptionMesg = copyMessageToR("unknown reason");
    }
    
    if(exceptionMesg != NULL)
        error(exceptionMesg);
    
    return rl;
}

RcppExport SEXP QL_ZBond1(SEXP bondparam, SEXP discountCurve, SEXP dateparams){
    SEXP rl = R_NilValue;
    char *exceptionMesg = NULL;
    try{
        RcppParams curve(discountCurve);
        Rate riskFreeRate = curve.getDoubleValue("riskFreeRate");
        RcppDate today_Date = curve.getDateValue("todayDate");       
        QuantLib::Date today(dateFromR(today_Date));

        boost::shared_ptr<SimpleQuote> rRate(new SimpleQuote(riskFreeRate));
        Settings::instance().evaluationDate() = today;
        Handle<YieldTermStructure> discountCurve(flatRate(today,rRate,Actual360()));

        rl = ZeroBond(bondparam, discountCurve, dateparams);
    } catch(std::exception& ex) {
        exceptionMesg = copyMessageToR(ex.what());
    } catch(...) {
        exceptionMesg = copyMessageToR("unknown reason");
    }    
    if(exceptionMesg != NULL)
        error(exceptionMesg);
    
    return rl;
}
RcppExport SEXP QL_ZBond2(SEXP bondparam, SEXP params, 
                          SEXP tsQuotes, SEXP times,
                          SEXP dateparams){
    SEXP rl = R_NilValue;
    char *exceptionMesg = NULL;
    try{
        
        Handle<YieldTermStructure> discountCurve(
                                 buildTermStructure(params, tsQuotes, times));
      
        rl = ZeroBond(bondparam, discountCurve, dateparams);
    } catch(std::exception& ex) {
        exceptionMesg = copyMessageToR(ex.what());
    } catch(...) {
        exceptionMesg = copyMessageToR("unknown reason");
    }    
    if(exceptionMesg != NULL)
        error(exceptionMesg);   
    return rl;
}



SEXP FixedBond(SEXP bondparam, SEXP ratesVec,
                   Handle<YieldTermStructure> &discountCurve,
                   SEXP dateparams){
    SEXP rl=R_NilValue;
    char* exceptionMesg=NULL;
    try{
        RcppParams rparam(bondparam);
        
        double faceAmount = rparam.getDoubleValue("faceAmount");
        
        RcppDate mDate = rparam.getDateValue("maturityDate");
        RcppDate eDate = rparam.getDateValue("effectiveDate");
        RcppDate iDate = rparam.getDateValue("issueDate");
        QuantLib::Date maturityDate(dateFromR(mDate));
        QuantLib::Date effectiveDate(dateFromR(eDate));
        QuantLib::Date issueDate(dateFromR(iDate));
        double redemption = rparam.getDoubleValue("redemption");

        RcppParams misc(dateparams);      
        double settlementDays = misc.getDoubleValue("settlementDays");
        std::string cal = misc.getStringValue("calendar");
        double dayCounter = misc.getDoubleValue("dayCounter");
        double frequency = misc.getDoubleValue("period");
        double businessDayConvention = misc.getDoubleValue("businessDayConvention");
        double terminationDateConvention = misc.getDoubleValue("terminationDateConvention");
        double dateGeneration = misc.getDoubleValue("dateGeneration");
        double endOfMonthRule = misc.getDoubleValue("endOfMonth");

        //extract coupon rates vector
        RcppVector<double> RcppVec(ratesVec); 
        std::vector<double> rates(RcppVec.stlVector());

        //set up BusinessDayConvetion
        BusinessDayConvention bdc = getBusinessDayConvention(businessDayConvention);
        BusinessDayConvention tbdc = getBusinessDayConvention(terminationDateConvention);
        DayCounter dc = getDayCounter(dayCounter);
        Frequency freq = getFrequency(frequency);
        DateGeneration::Rule rule = getDateGenerationRule(dateGeneration);
        bool endOfMonth = (endOfMonthRule==1) ? true : false;
        //set up calendar
        Calendar calendar = UnitedStates(UnitedStates::GovernmentBond);
        if (cal == "us"){
            calendar = UnitedStates(UnitedStates::GovernmentBond);
        }
        else if (cal == "uk"){
            calendar = UnitedKingdom(UnitedKingdom::Exchange);
        }

        //build the bond
        Schedule sch(effectiveDate, maturityDate,
                     Period(freq), calendar,
                     bdc, tbdc, rule, endOfMonth);
        
        FixedRateBond bond(settlementDays, faceAmount, sch,
                           rates,dc, bdc, redemption, issueDate);

        //bond price
        boost::shared_ptr<PricingEngine> bondEngine(
                                                    new DiscountingBondEngine(discountCurve));
        bond.setPricingEngine(bondEngine);   

        //cashflow
        int numCol = 2;
        std::vector<std::string> colNames(numCol);
        colNames[0] = "Date";
        colNames[1] = "Amount";
        RcppFrame frame(colNames);
        
        Leg bondCashFlow = bond.cashflows();
        for (unsigned int i = 0; i< bondCashFlow.size(); i++){
            std::vector<ColDatum> row(numCol);
            Date d = bondCashFlow[i]->date();
            row[0].setDateValue(RcppDate(d.month(), d.dayOfMonth(), d.year()));
            row[1].setDoubleValue(bondCashFlow[i]->amount());
            frame.addRow(row);
        }
        
        
        RcppResultSet rs;

        rs.add("NPV", bond.NPV());
        rs.add("cleanPrice", bond.cleanPrice());
        rs.add("dirtyPrice", bond.dirtyPrice());
        rs.add("accruedCoupon", bond.accruedAmount());
        rs.add("yield", bond.yield(Actual360(), Compounded, Annual));
        rs.add("cashFlow", frame);
        rl = rs.getReturnList();

    }
    catch(std::exception& ex) {
        exceptionMesg = copyMessageToR(ex.what());
    } catch(...) {
        exceptionMesg = copyMessageToR("unknown reason");
    }
    
    if(exceptionMesg != NULL)
        error(exceptionMesg);
    return rl;
}

RcppExport SEXP QL_FixedRateBond1(SEXP bondparam, SEXP ratesVec,
                                  SEXP discountCurve, SEXP dateparams){
    SEXP rl = R_NilValue;
    char *exceptionMesg = NULL;
    try{
        RcppParams curve(discountCurve);
        Rate riskFreeRate = curve.getDoubleValue("riskFreeRate");
        RcppDate today_Date = curve.getDateValue("todayDate");       
        QuantLib::Date today(dateFromR(today_Date));
        
        boost::shared_ptr<SimpleQuote> rRate(new SimpleQuote(riskFreeRate));
        Settings::instance().evaluationDate() = today;
        Handle<YieldTermStructure> discountCurve(flatRate(today,rRate,Actual360()));

        rl = FixedBond(bondparam, ratesVec, discountCurve, dateparams);
    } catch(std::exception& ex) {
        exceptionMesg = copyMessageToR(ex.what());
    } catch(...) {
        exceptionMesg = copyMessageToR("unknown reason");
    }    
    if(exceptionMesg != NULL)
        error(exceptionMesg);
    
    return rl;
}

RcppExport SEXP QL_FixedRateBond2(SEXP bondparam, SEXP ratesVec, 
                                  SEXP params, SEXP tsQuotes, 
                                  SEXP times, SEXP dateparams){
    SEXP rl = R_NilValue;
    char *exceptionMesg = NULL;
    try{
        
        Handle<YieldTermStructure> discountCurve(
                                                 buildTermStructure(params, tsQuotes, times));
        
        rl = FixedBond(bondparam, ratesVec, discountCurve, dateparams);
    } catch(std::exception& ex) {
        exceptionMesg = copyMessageToR(ex.what());
    } catch(...) {
        exceptionMesg = copyMessageToR("unknown reason");
    }    
    if(exceptionMesg != NULL)
        error(exceptionMesg);   
    return rl;
}
    

RcppExport  SEXP QL_FixedRateBondYield(SEXP optionParameters, SEXP ratesVec) {
  
    SEXP rl=R_NilValue;
    char* exceptionMesg=NULL;
    try{
        RcppParams rparam(optionParameters);
        double settlementDays = rparam.getDoubleValue("settlementDays");
        std::string cal = rparam.getStringValue("calendar");
        double price = rparam.getDoubleValue("price");
        double faceAmount = rparam.getDoubleValue("faceAmount");
        double businessDayConvention = rparam.getDoubleValue("businessDayConvention");
        double compound = rparam.getDoubleValue("compound");
        double redemption = rparam.getDoubleValue("redemption");
        double dayCounter = rparam.getDoubleValue("dayCounter");
        double frequency = rparam.getDoubleValue("period");
        
        RcppDate mDate = rparam.getDateValue("maturityDate");
        RcppDate eDate = rparam.getDateValue("effectiveDate");
        RcppDate iDate = rparam.getDateValue("issueDate");
        QuantLib::Date maturityDate(dateFromR(mDate));
        QuantLib::Date effectiveDate(dateFromR(eDate));
        QuantLib::Date issueDate(dateFromR(iDate));
        
        //extract coupon rates vector
        RcppVector<double> RcppVec(ratesVec); 
        std::vector<double> rates(RcppVec.stlVector());
        
        //set up BusinessDayConvetion
        BusinessDayConvention bdc = getBusinessDayConvention(businessDayConvention);
        DayCounter dc = getDayCounter(dayCounter);
        Frequency freq = getFrequency(frequency);
        Compounding cp = getCompounding(compound);
 
        //set up calendar
        Calendar calendar = UnitedStates(UnitedStates::GovernmentBond);
        if (cal == "us"){
            calendar = UnitedStates(UnitedStates::GovernmentBond);
        }
        else if (cal == "uk"){
            calendar = UnitedKingdom(UnitedKingdom::Exchange);
        }
        
        //build the bond
        Schedule sch(effectiveDate, maturityDate,
                     Period(freq), calendar,
                     bdc, bdc, DateGeneration::Backward, false);
        
        FixedRateBond bond(settlementDays, faceAmount, sch,
                           rates,dc, bdc, redemption, issueDate);
        
        
        
        RcppResultSet rs;
        rs.add("yield", bond.yield(price, dc, cp, freq));
        rl = rs.getReturnList();
        
    } catch(std::exception& ex) {
        exceptionMesg = copyMessageToR(ex.what());
    } catch(...) {
        exceptionMesg = copyMessageToR("unknown reason");
    }
    
    if(exceptionMesg != NULL)
        error(exceptionMesg);
    
    return rl;
}
 
RcppExport  SEXP QL_FixedRateBondPriceByYield(SEXP optionParameters, SEXP ratesVec) {
  
    SEXP rl=R_NilValue;
    char* exceptionMesg=NULL;
    try{
        RcppParams rparam(optionParameters);
        double settlementDays = rparam.getDoubleValue("settlementDays");
        std::string cal = rparam.getStringValue("calendar");
        double yield = rparam.getDoubleValue("yield");
        double faceAmount = rparam.getDoubleValue("faceAmount");
        double businessDayConvention = rparam.getDoubleValue("businessDayConvention");
        double compound = rparam.getDoubleValue("compound");
        double redemption = rparam.getDoubleValue("redemption");
        double dayCounter = rparam.getDoubleValue("dayCounter");
        double frequency = rparam.getDoubleValue("period");
        
        RcppDate mDate = rparam.getDateValue("maturityDate");
        RcppDate eDate = rparam.getDateValue("effectiveDate");
        RcppDate iDate = rparam.getDateValue("issueDate");
        QuantLib::Date maturityDate(dateFromR(mDate));
        QuantLib::Date effectiveDate(dateFromR(eDate));
        QuantLib::Date issueDate(dateFromR(iDate));
        
        //extract coupon rates vector
        RcppVector<double> RcppVec(ratesVec); 
        std::vector<double> rates(RcppVec.stlVector());
        
        //set up BusinessDayConvetion
        BusinessDayConvention bdc = getBusinessDayConvention(businessDayConvention);
        DayCounter dc = getDayCounter(dayCounter);
        Frequency freq = getFrequency(frequency);
        Compounding cp = getCompounding(compound);
 
        //set up calendar
        Calendar calendar = UnitedStates(UnitedStates::GovernmentBond);
        if (cal == "us"){
            calendar = UnitedStates(UnitedStates::GovernmentBond);
        }
        else if (cal == "uk"){
            calendar = UnitedKingdom(UnitedKingdom::Exchange);
        }
        
        //build the bond
        Schedule sch(effectiveDate, maturityDate,
                     Period(freq), calendar,
                     bdc, bdc, DateGeneration::Backward, false);
        
        FixedRateBond bond(settlementDays, faceAmount, sch,
                           rates,dc, bdc, redemption, issueDate);
        
        
        
        RcppResultSet rs;
        rs.add("cleanPrice", bond.cleanPrice(yield, dc, cp, freq));
        rl = rs.getReturnList();
        
    } catch(std::exception& ex) {
        exceptionMesg = copyMessageToR(ex.what());
    } catch(...) {
        exceptionMesg = copyMessageToR("unknown reason");
    }
    
    if(exceptionMesg != NULL)
        error(exceptionMesg);
    
    return rl;
}



SEXP FloatingBond(SEXP bondparam, SEXP gearingsVec, SEXP spreadsVec,
                  SEXP capsVec, SEXP floorsVec, 
                  Handle<YieldTermStructure> &index,
                  SEXP indexparams,
                  Handle<YieldTermStructure> &discountCurve,
                  SEXP dateparams) 
{
  
    SEXP rl=R_NilValue;
    char* exceptionMesg=NULL;
    try{
        RcppParams rparam(bondparam);        
        double faceAmount = rparam.getDoubleValue("faceAmount");     
        RcppDate mDate = rparam.getDateValue("maturityDate");
        RcppDate eDate = rparam.getDateValue("effectiveDate");
        RcppDate iDate = rparam.getDateValue("issueDate");
        QuantLib::Date maturityDate(dateFromR(mDate));
        QuantLib::Date effectiveDate(dateFromR(eDate));
        QuantLib::Date issueDate(dateFromR(iDate));
        double redemption = rparam.getDoubleValue("redemption");

        RcppParams misc(dateparams);      
        double settlementDays = misc.getDoubleValue("settlementDays");
        std::string cal = misc.getStringValue("calendar");
        double dayCounter = misc.getDoubleValue("dayCounter");
        double frequency = misc.getDoubleValue("period");
        double businessDayConvention = misc.getDoubleValue("businessDayConvention");
        double terminationDateConvention = misc.getDoubleValue("terminationDateConvention");
        double dateGeneration = misc.getDoubleValue("dateGeneration");
        double endOfMonthRule = misc.getDoubleValue("endOfMonth");
        double fixingDays = misc.getDoubleValue("fixingDays");


        //build schedule
        BusinessDayConvention bdc = getBusinessDayConvention(businessDayConvention);
        BusinessDayConvention tbdc = getBusinessDayConvention(terminationDateConvention);
        DayCounter dc = getDayCounter(dayCounter);
        Frequency freq = getFrequency(frequency);
        DateGeneration::Rule rule = getDateGenerationRule(dateGeneration);
        bool endOfMonth = (endOfMonthRule==1) ? true : false;

        //set up calendar
        Calendar calendar = UnitedStates(UnitedStates::GovernmentBond);
        if (cal == "us"){
            calendar = UnitedStates(UnitedStates::GovernmentBond);
        }
        else if (cal == "uk"){
            calendar = UnitedKingdom(UnitedKingdom::Exchange);
        }
        Schedule sch(effectiveDate, maturityDate,
                     Period(freq), calendar,
                     bdc, tbdc, rule, endOfMonth);

        //extract gearings, spreads, caps, and floors
        std::vector<double> gearings = getDoubleVector(gearingsVec);
        std::vector<double> spreads = getDoubleVector(spreadsVec);
        std::vector<double> caps = getDoubleVector(capsVec);
        std::vector<double> floors = getDoubleVector(floorsVec);

        RcppParams iborparams(indexparams);      
        std::string type = iborparams.getStringValue("type");
        double length = iborparams.getDoubleValue("length");
        std::string inTermOf = iborparams.getStringValue("inTermOf");


        boost::shared_ptr<IborIndex> iborindex(new USDLibor(6 * Months, index));
        if (type=="USDLibor"){
            if (inTermOf=="Months"){               
                boost::shared_ptr<IborIndex> temp(new USDLibor(length * Months, index));
                iborindex = temp;
            }
            
        }
        //build the bond
        FloatingRateBond bond(settlementDays, faceAmount, sch,
                              iborindex, dc, bdc, fixingDays,
                              gearings, spreads, caps, floors, false,
                              redemption, issueDate);        
        
        
        //bond price
        boost::shared_ptr<PricingEngine> bondEngine(
                                                    new DiscountingBondEngine(discountCurve));
        bond.setPricingEngine(bondEngine);

        
        //cashflow
        boost::shared_ptr<IborCouponPricer> pricer(new
                                                   BlackIborCouponPricer(Handle<OptionletVolatilityStructure>()));
        setCouponPricer(bond.cashflows(),pricer);

        int numCol = 2;
        std::vector<std::string> colNames(numCol);
        colNames[0] = "Date";
        colNames[1] = "Amount";
        RcppFrame frame(colNames);
        
        Leg bondCashFlow = bond.cashflows();
        for (unsigned int i = 0; i< bondCashFlow.size(); i++){
            std::vector<ColDatum> row(numCol);
            Date d = bondCashFlow[i]->date();
            row[0].setDateValue(RcppDate(d.month(), d.dayOfMonth(), d.year()));
            row[1].setDoubleValue(bondCashFlow[i]->amount());
            frame.addRow(row);
        }
        
        
        RcppResultSet rs;

        rs.add("NPV", bond.NPV());
        rs.add("cleanPrice", bond.cleanPrice());
        rs.add("dirtyPrice", bond.dirtyPrice());
        rs.add("accruedCoupon", bond.accruedAmount());
        rs.add("yield", bond.yield(Actual360(), Compounded, Annual));
        rs.add("cashFlow", frame);
        rl = rs.getReturnList();
        
    } catch(std::exception& ex) {
        exceptionMesg = copyMessageToR(ex.what());
    } catch(...) {
        exceptionMesg = copyMessageToR("unknown reason");
    }
    
    if(exceptionMesg != NULL)
        error(exceptionMesg);
    
    return rl;
}

RcppExport SEXP QL_FloatBond1(SEXP bond, SEXP gearings, SEXP caps,
                              SEXP spreads,
                              SEXP floors, SEXP indexparams, SEXP index, 
                              SEXP discountCurve, SEXP dateparams)
{
    
    SEXP rl=R_NilValue;
    char* exceptionMesg=NULL;
    try{

        Handle<YieldTermStructure> discount_curve(getFlatCurve(discountCurve));
        Handle<YieldTermStructure> ibor_curve(getFlatCurve(index));
        rl = FloatingBond(bond, gearings, caps, spreads,
                          floors, ibor_curve, indexparams,
                          discount_curve, dateparams);       
        
    } catch(std::exception& ex) {
        exceptionMesg = copyMessageToR(ex.what());
    } catch(...) {
        exceptionMesg = copyMessageToR("unknown reason");
    }
    
    if(exceptionMesg != NULL)
        error(exceptionMesg);
    
    return rl;
}

RcppExport SEXP QL_FloatBond2(SEXP bond, SEXP gearings, SEXP caps,
                              SEXP spreads,
                              SEXP floors, SEXP indexparams, SEXP index_params, 
                              SEXP index_tsQuotes, SEXP index_times,
                              SEXP discountCurve, SEXP dateparams)
{
    
    SEXP rl=R_NilValue;
    char* exceptionMesg=NULL;
    try{

        Handle<YieldTermStructure> discount_curve(getFlatCurve(discountCurve));
        Handle<YieldTermStructure> ibor_curve(
                                              buildTermStructure(index_params,
                                                                 index_tsQuotes,
                                                                 index_times));
        rl = FloatingBond(bond, gearings, caps, spreads,
                          floors, ibor_curve, indexparams,
                          discount_curve, dateparams);       
        
    } catch(std::exception& ex) {
        exceptionMesg = copyMessageToR(ex.what());
    } catch(...) {
        exceptionMesg = copyMessageToR("unknown reason");
    }
    
    if(exceptionMesg != NULL)
        error(exceptionMesg);
    
    return rl;
}
RcppExport SEXP QL_FloatBond3(SEXP bond, SEXP gearings, SEXP caps,
                              SEXP spreads, SEXP floors, 
                              SEXP indexparams, SEXP index, 
                              SEXP discount_params, SEXP discount_tsQuotes,
                              SEXP discount_times, SEXP dateparams)
{
    
    SEXP rl=R_NilValue;
    char* exceptionMesg=NULL;
    try{

        Handle<YieldTermStructure> ibor_curve(getFlatCurve(index));
        Handle<YieldTermStructure> discount_curve(
                                                  buildTermStructure(discount_params,
                                                                 discount_tsQuotes,
                                                                 discount_times));
        rl = FloatingBond(bond, gearings, caps, spreads,
                          floors, ibor_curve, indexparams,
                          discount_curve, dateparams);       
        
    } catch(std::exception& ex) {
        exceptionMesg = copyMessageToR(ex.what());
    } catch(...) {
        exceptionMesg = copyMessageToR("unknown reason");
    }
    
    if(exceptionMesg != NULL)
        error(exceptionMesg);
    
    return rl;
}
RcppExport SEXP QL_FloatBond4(SEXP bond, SEXP gearings, SEXP caps,
                              SEXP spreads, SEXP floors, 
                              SEXP indexparams, SEXP index_params, 
                              SEXP index_tsQuotes, SEXP index_times,
                              SEXP discount_params, SEXP discount_tsQuotes,
                              SEXP discount_times, SEXP dateparams)
{
    
    SEXP rl=R_NilValue;
    char* exceptionMesg=NULL;
    try{

        Handle<YieldTermStructure> ibor_curve(
                                              buildTermStructure(index_params,
                                                                 index_tsQuotes,
                                                                 index_times));
      
        Handle<YieldTermStructure> discount_curve(
                                                  buildTermStructure(discount_params,
                                                                 discount_tsQuotes,
                                                                 discount_times));
        rl = FloatingBond(bond, gearings, caps, spreads,
                          floors, ibor_curve, indexparams,
                          discount_curve, dateparams);       
        
    } catch(std::exception& ex) {
        exceptionMesg = copyMessageToR(ex.what());
    } catch(...) {
        exceptionMesg = copyMessageToR("unknown reason");
    }
    
    if(exceptionMesg != NULL)
        error(exceptionMesg);
    
    return rl;
}

RcppExport SEXP QL_FloatingWithRebuiltCurve(SEXP bond, SEXP gearings,
                                            SEXP spreads, SEXP caps,
                                            SEXP floors, SEXP indexparams,
                                            SEXP iborDateSexp, SEXP iborzeroSexp,
                                            SEXP dateSexp, SEXP zeroSexp,
                                            SEXP dateparams){
   SEXP rl=R_NilValue;
   char* exceptionMesg=NULL;
   try {
       
       Handle<YieldTermStructure> ibor_curve(rebuildCurveFromZeroRates(iborDateSexp,
                                                                   iborzeroSexp));       
       Handle<YieldTermStructure> curve(rebuildCurveFromZeroRates(dateSexp,
                                                                   zeroSexp));       


       rl = FloatingBond(bond, gearings, caps, spreads,
                         floors, ibor_curve, indexparams,
                         curve, dateparams);
   } catch(std::exception& ex) {
       exceptionMesg = copyMessageToR(ex.what());
   } catch(...) {
       exceptionMesg = copyMessageToR("unknown reason");
   }
   
   if(exceptionMesg != NULL)
       error(exceptionMesg);
    
   return rl;
}

RcppExport SEXP QL_FixedRateWithRebuiltCurve(SEXP bondparam, SEXP ratesVec,
                                             SEXP dateSexp, SEXP zeroSexp,
                                             SEXP dateparams){
    SEXP rl=R_NilValue;
    char* exceptionMesg=NULL;
    try {
        Handle<YieldTermStructure> curve(rebuildCurveFromZeroRates(dateSexp,
                                                                   zeroSexp));
        rl = FixedBond(bondparam, ratesVec, curve, dateparams);

    } catch(std::exception& ex) {
        exceptionMesg = copyMessageToR(ex.what());
    } catch(...) {
        exceptionMesg = copyMessageToR("unknown reason");
    }
    
    if(exceptionMesg != NULL)
        error(exceptionMesg);
    
    return rl;
}

RcppExport SEXP QL_ZeroBondWithRebuiltCurve(SEXP bond,
                                       SEXP dateSexp, SEXP zeroSexp,
                                       SEXP dateparams){
    SEXP rl=R_NilValue;
    char* exceptionMesg=NULL;
    try{

        Handle<YieldTermStructure> curve(rebuildCurveFromZeroRates(dateSexp,
                                                                   zeroSexp));


        rl = ZeroBond(bond, curve, dateparams);
        
        
    } catch(std::exception& ex) {
        exceptionMesg = copyMessageToR(ex.what());
    } catch(...) {
        exceptionMesg = copyMessageToR("unknown reason");
    }
    
    if(exceptionMesg != NULL)
        error(exceptionMesg);
    
    return rl;
}
