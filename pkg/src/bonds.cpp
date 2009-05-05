#include "rquantlib.hpp"
using namespace boost;
RcppExport  SEXP QL_ZeroCouponBond(SEXP optionParameters) {

    SEXP rl=R_NilValue;
    char* exceptionMesg=NULL;
    try {
      RcppParams rparam(optionParameters); 
      double settlementDays = rparam.getDoubleValue("settlementDays");
      std::string cal = rparam.getStringValue("calendar");
      double faceAmount = rparam.getDoubleValue("faceAmount");
      std::string maturityDate = rparam.getStringValue("maturityDate");
      std::string businessDayConvention = rparam.getStringValue("businessDayConvention");
      double redemption = rparam.getDoubleValue("redemption");
      std::string issueDate = rparam.getStringValue("issueDate");
      std::string todayDate = rparam.getStringValue("todayDate");
      Rate riskFreeRate = rparam.getDoubleValue("riskFreeRate");
      
      /*
	 test-suite/bonds.cpp
      */
      std::vector<std::string> splitVector;
      //maturity date
      split(splitVector, maturityDate, is_any_of("-/"));
      Day maturity_d = boost::lexical_cast<int>(splitVector[0]);
      Month maturity_m = (Month)boost::lexical_cast<int>(splitVector[1]);
      Year maturity_y = boost::lexical_cast<int>(splitVector[2]);
      
      //issue date;
      split(splitVector, issueDate, is_any_of("-/"));
      Day issue_d = boost::lexical_cast<int>(splitVector[0]);
      Month issue_m = (Month)boost::lexical_cast<int>(splitVector[1]);
      Year issue_y = boost::lexical_cast<int>(splitVector[2]);
      
      //today date - needed to build a correct yield curve
      split(splitVector, todayDate, is_any_of("-/"));
      Day today_d = boost::lexical_cast<int>(splitVector[0]);
      Month today_m = (Month)boost::lexical_cast<int>(splitVector[1]);
      Year today_y = boost::lexical_cast<int>(splitVector[2]);
      Date today(today_d, today_m, today_y);

        boost::shared_ptr<SimpleQuote> rRate(new SimpleQuote(riskFreeRate));
      Settings::instance().evaluationDate() = today;
      Handle<YieldTermStructure> discountCurve(flatRate(today,rRate,Actual360()));
      
      //set up BusinessDayConvetion
      BusinessDayConvention bdc = ModifiedFollowing;
      if (businessDayConvention == "Following"){
	bdc = Following;
      }else if (businessDayConvention == "Preceding"){
	bdc = Preceding;
      }else if (businessDayConvention == "ModifiedPreceding"){
	bdc = ModifiedPreceding;
      }else if (businessDayConvention == "Unadjusted"){
	bdc = Unadjusted;
      }
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
			  Date(maturity_d,maturity_m,maturity_y),
			  bdc,
			  redemption, Date(issue_d,issue_m,issue_y));
      boost::shared_ptr<PricingEngine> bondEngine(
						  new DiscountingBondEngine(discountCurve));
      bond.setPricingEngine(bondEngine);

      RcppResultSet rs;
      rs.add("clean price", bond.cleanPrice());
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

    
