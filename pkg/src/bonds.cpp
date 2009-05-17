/* RQuantLib -- R interface to the QuantLib libraries
##
## Copyright (C) 2002 - 2009 Dirk Eddelbuettel <edd@debian.org>
## Copyright (C) 2009        Khanh Nguyen <knguyen@cs.umb.edu>
##
## $Id: asian.R 58 2009-03-31 03:50:44Z edd $
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



RcppExport  SEXP QL_ZeroCouponBond(SEXP optionParameters) {
  
  SEXP rl=R_NilValue;
  char* exceptionMesg=NULL;
  try {
    RcppParams rparam(optionParameters);
    double settlementDays = rparam.getDoubleValue("settlementDays");
    std::string cal = rparam.getStringValue("calendar");
    double faceAmount = rparam.getDoubleValue("faceAmount");
    double businessDayConvention = rparam.getDoubleValue("businessDayConvention");
    double redemption = rparam.getDoubleValue("redemption");
    Rate riskFreeRate = rparam.getDoubleValue("riskFreeRate");
    
    RcppDate mDate = rparam.getDateValue("maturityDate");
    RcppDate iDate = rparam.getDateValue("issueDate");
    RcppDate today_Date = rparam.getDateValue("todayDate");       
    QuantLib::Date maturityDate(dateFromR(mDate));
    QuantLib::Date issueDate(dateFromR(iDate));
    QuantLib::Date today(dateFromR(today_Date));
    /*
      test-suite/bonds.cpp
    */

    /*
      std::vector<std::string> splitVector;
      //maturity date
      split(splitVector, maturityDate, is_any_of("-/"));
      Day maturity_d = boost::lexical_cast<int>(splitVector[0]);
      Month maturity_m = (Month)boost::lexical_cast<int>(splitVector[1]);
      Year maturity_y = boost::lexical_cast<int>(splitVector[2]);      
    */

    boost::shared_ptr<SimpleQuote> rRate(new SimpleQuote(riskFreeRate));
    Settings::instance().evaluationDate() = today;
    Handle<YieldTermStructure> discountCurve(flatRate(today,rRate,Actual360()));
    
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
    
    RcppResultSet rs;
    rs.add("cleanPrice", bond.cleanPrice());
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


