mf.cbprice <- function(RiskFreeRate, StaticSpread,
                       Sigma, Price,
                       ConvRatio, NumSteps,
                       IssueDate, Settle,
                       Maturity, CouponRate,
                       Period=2, Basis=6,
                       EndMonthRule=0, DividendType=0,
                       DividendInfo=data.frame(Date=as.Date(character(0)), Amount=numeric(0)),
                       CallType = 0,
                       CallInfo=data.frame(Date=as.Date(character(0)), Amount=numeric(0)),
                       TreeType = 0){
  val <- 0
  val <- .Call("cbprice",
               list(rff = as.double(RiskFreeRate),
                    spread = as.double(StaticSpread),
                    sigma = as.double(Sigma),
                    price = as.double(Price),
		    convRatio = as.double(ConvRatio),
		    numSteps = as.double(NumSteps),
                    issue = IssueDate,
                    settle = Settle,
                    maturity = Maturity,
                    couponRate = as.double(CouponRate),
                    period = as.double(Period),
                    basis = as.double(Basis),
                    emr = as.double(EndMonthRule),
                    calltype = as.double(CallType),
                    dividendtype = as.double(DividendType),
                    treeType = as.double(TreeType)),
               DividendInfo, CallInfo,
               PACKAGE='RQuantLib'
               )
  val 

}
