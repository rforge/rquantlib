
#GUI for building discount curve
discountBuilder <- function(){
    dstBuilder <- aDialog(items=list(
                          tradeDate=dateItem(Sys.Date()),
                          settleDate=dateItem(Sys.Date()),
                          interpWhat=choiceItem("discount",
                          values=c("discount", "zero", "forward")),
                          interpHow=choiceItem("loglinear",
                          values=c("linear", "loglinear", "spline")),

                          assign.to=stringItem("dcc", label="Assign to:"),

                          flatCurve=trueFalseItem(TRUE),
                          flatValue=numericItem(),
                          d1w=numericItem(0),
                          d1m=numericItem(0),
                          d3m=numericItem(0),
                          d6m=numericItem(0),
                          d9m=numericItem(0),
                          d1y=numericItem(0),
                          fut1=numericItem(0),
                          fut2=numericItem(0),
                          fut3=numericItem(0),
                          fut4=numericItem(0),
                          fut5=numericItem(0),
                          fut6=numericItem(0),
                          fut7=numericItem(0),
                          fut8=numericItem(0),
                          s2y=numericItem(0),
                          s3y=numericItem(0),
                          s5y=numericItem(0),
                          s10y=numericItem(0),
                          s15y=numericItem(0),
                          visual=graphicDeviceItem()
                          ),

                          OK_handler=function(.){
                              lst <- .$to_R()

                              params <- list(tradeDate=as.Date(lst$tradeDate),
                                             settleDate=as.Date(lst$settleDate),
                                             dt=.25,
                                             interpWhat=lst$interpWhat,
                                             interpHow=lst$interpHow)
                              library(zoo)
                              if (lst$flatCurve){

                                  curve <- DiscountCurve(params,
                                                         list(flat=lst$flatValue),
                                                         times=seq(0,10,.1))
                                  assign(lst$assign.to, curve,
                                         envir=.GlobalEnv)
                                  plot(curve)
                              }
                              else {
                                  tsQuotes <- list(d1w =lst$d1w,
                                                   d1m =lst$d1m,
                                                   fut1=lst$fut1,
                                                   fut2=lst$fut2,
                                                   fut3=lst$fut3,
                                                   fut4=lst$fut4,
                                                   fut5=lst$fut5,
                                                   fut6=lst$fut6,
                                                   fut7=lst$fut7,
                                                   fut8=lst$fut8,
                                                   s3y =lst$s3y,
                                                   s5y =lst$s5y,
                                                   s10y =lst$s10y,
                                                   s15y =lst$s15y)
                                  curve <- DiscountCurve(params, tsQuotes, times=seq(0, 10, .01))
                                  assign(lst$assign.to, curve, envir=.GlobalEnv)
                                  plot(curve)
                              }
                              print("Done!")
                              print(paste("Done! The result is stored in object", lst$assign.to))

                          },
                          title='Discount Curve GUI'
                          )

    dstView <- aGroup(aContainer(aFrame(aContainer("tradeDate", "settleDate",
                                                   "interpWhat", "interpHow"),
                                        label="Curve Parameters"),
                                 aFrame(aContainer("flatCurve","flatValue"),
                                        label="Flat Curve"),
                                 aFrame(aTableLayout(aContainer("d1w","d1m","d3m","d6m","d9m","d1y"),
                                                     aContainer("fut1","fut2","fut3","fut4","fut5","fut6", "fut7","fut8"),
                                                     aContainer("s2y","s3y","s5y","s10y","s15y"),
                                                     no_cols=3
                                                     ),
                                        label="Input Quotes")
                                 ),
                      aContainer("assign.to", "visual"),
                      horizontal=TRUE)
    dstBuilder$make_gui(gui_layout=dstView)
}


#GUI for FittedBondCurve
fittedBondBuilder <- function(){

    fittedDlg <- aDialog(items=list(
                         lengths=expressionItem(name="lengths",
                             label="lengths as an R expression"),
                         coupons=expressionItem(name="coupons",
                             label="coupons as an R expression"),
                         marketQuotes=expressionItem(name="marketQuotes",
                             label="market prices as an R expression"),

                         settlementDays=numericItem(3),
                         period=choiceItem("Semiannual",
                         values=c("NoFrequency", "Once", "Annual",
                         "Semiannual", "EveryFourthMonth",
                         "Quarterly", "BiMonthtly",
                         "Monthly", "EveryFourthWeek",
                         "BiWeekly", "Weekly", "Daily"
                         )),
                         dayCounter=choiceItem("Thirty360",
                         values=c("Actual360","Actual360FixEd","ActualActual",
                         "ActualBusiness252","OneDayCounter",
                         "SimpleDayCounter","Thirty360" )),
                         businessDayConvention=choiceItem("Following",
                         values=c("Following", "Unadjusted", "ModifiedFollowing", "Preceding",
                         "ModifiedPreceding")),

                         method=choiceItem("NelsonSiegelFitting",
                         values=c("ExponentialSplinesFitting",
                         "SimplePolynomialFitting",
                         "NelsonSiegelFitting")),
                         origDate=dateItem(Sys.Date()),

                         assign.to=stringItem("fbc", label="Assign to:"),

                         visual=graphicDeviceItem()

                         ),
                         title='Fitted Bond Curve GUI',
                         OK_handler=function(.){
                             lst <- .$to_R()
                             dateparams <- list(settlementDays=lst$settlementDays,
                                                period=lst$period,
                                                dayCounter=lst$dayCounter,
                                                businessDayConvention=lst$businessDayConvention)

                             curveparams <- list(method=lst$method,
                                                 origDate=as.Date(lst$origDate))

                             curve <- FittedBondCurve(curveparams,
                                                      as.numeric(lst$lengths),
                                                      as.numeric(lst$coupons),
                                                      as.numeric(lst$marketQuotes),
                                                      dateparams)
                             assign(lst$assign.to, curve, envir=.GlobalEnv)

                             library(zoo)
                             z <- zoo(curve$table$zeroRates,
                                      order.by=curve$table$date)
                             plot(z, xlab='Date', ylab='Zero Rates')
                             print(paste("Done! The result is stored in object", lst$assign.to))
                         }
                         )

    fittedView <- aGroup(aContainer(aFrame(aContainer("lengths",
                                                      "coupons","marketQuotes"),
                                           label="Input"),
                                    aFrame(aContainer("method", "origDate"),
                                           label="Curve Parameters"),
                                    aFrame(aContainer("settlementDays",
                                                      "period","dayCounter",
                                                      "businessDayConvention"),
                                           label="Date Paramters")
                                    ),
                         aContainer("assign.to", "visual"),
                         horizontal=TRUE
                       )
    fittedDlg$make_gui(gui_layout=fittedView)

}

#Main GUI for bond pricing
bondGUI <- function(){
    dlg <- aDialog(items=list(
                                        #date params
                   settlementDays=numericItem(1),
                   calendar=choiceItem("us",values=c("us", "uk")),
                   businessDayConvention=choiceItem("Following",
                   values=c("Following", "Unadjusted", "ModifiedFollowing", "Preceding",
                   "ModifiedPreceding")),
                   terminationDateConvention=choiceItem("Following",
                   values=c("Following", "Unadjusted", "ModifiedFollowing", "Preceding",
                   "ModifiedPreceding")),

                   dayCounter=choiceItem("Thirty360",
                   values=c("Actual360","Actual360FixEd","ActualActual",
                   "ActualBusiness252","OneDayCounter",
                   "SimpleDayCounter","Thirty360" )),

                   period=choiceItem("Semiannual",
                   values=c("NoFrequency", "Once", "Annual",
                   "Semiannual", "EveryFourthMonth",
                   "Quarterly", "BiMonthtly",
                   "Monthly", "EveryFourthWeek",
                   "BiWeekly", "Weekly", "Daily"
                   )),
                   dateGeneration=choiceItem("Backward",
                   values=c("Backward", "Forward",
                   "Zero","ThirdWednesday",
                   "Twentieth","TwentiethIMM")),

                                        #zero bond params
                   issueDate=dateItem(),
                   maturityDate=dateItem(),
                   faceAmount=numericItem(100),
                   redemption=numericItem(100),
                   discountCurveObj=stringItem(show_label=FALSE),


                                        #fixed rate bond params
                   fixedBond.issueDate=dateItem(Sys.Date()),
                   fixedBond.maturityDate=dateItem(Sys.Date()),
                   fixedBond.faceAmount=numericItem(100),
                   fixedBond.redemption=numericItem(100),
                   fixedBond.rates=numericItem(),

                                        #output values
                   NPV=numericItem("", label='NPV'),
                   cleanPrice=numericItem("", label='Clean price'),
                   dirtyPrice=numericItem("", label='Dirty price'),
                   yield=numericItem("", label='Yield'),
                   cf=graphicDeviceItem()
                   ),

                   title="RQuantLib common bonds pricing GUI",
                   buttons=c("OK", "Build curve", "FittedBondCurve"),

                   OK_handler=function(.){
                       lst <- .$to_R()


                       bond <- list(faceAmount=lst$faceAmount,
                                    issueDate=as.Date(lst$issueDate),
                                    maturityDate=as.Date(lst$maturityDate),
                                    redemption=lst$redemption)
                       dateparams <-list(settlementDays=lst$settlementDays,
                                         calendar=lst$calendar,
                                         businessDayConvention=lst$businessDayConvention)
                       discountCurve <- get(lst$discountCurveObj)
                       ret <- ZeroCouponBond(bond, discountCurve, dateparams)
                       .$set_NPV(ret$NPV)
                       .$set_cleanPrice(ret$cleanPrice)
                       .$set_dirtyPrice(ret$dirtyPrice)
                       .$set_yield(ret$yield)
                       plot(x=ret$cashFlow$Date, y=ret$cashFlow$Amount,
                            xlab='Date', ylab='Amount')
                   },

                   Buildcurve_handler=function(.){
                       discountBuilder()
                   },

                   FittedBondCurve_handler=function(.){
                       fittedBondBuilder()
                   }
                   )
    view <- aGroup(aContainer(
                              aFrame(aContainer("settlementDays", "calendar",
                                                "dayCounter", "period",
                                                "businessDayConvention",
                                                "terminationDateConvention",
                                                "dateGeneration"),
                                     label="DateParameters"),
                              aFrame(aContainer("issueDate", "maturityDate", "faceAmount", "redemption"),
                                     label="BondParam"),
                              aFrame(aContainer("discountCurveObj"),label="Discount Curve")),
                   aContainer(aFrame(aContainer("NPV","cleanPrice",
                                                "dirtyPrice","yield","cf"),label="Result")),
                   horizontal=TRUE
                   )

    view2  <- aGroup(aContainer(
                                aNotebook(
                                          aNotebookPage(
                                                        aFrame(aContainer("issueDate",
                                                                          "maturityDate",
                                                                          "faceAmount",
                                                                          "redemption"),
                                                               label="Zero Bond Parameters"
                                                               ),
                                                        label="Zero Coupon Bond"),
                                          aNotebookPage(
                                                        aFrame(aContainer("fixedBond.issueDate",
                                                                          "fixedBond.maturityDate",
                                                                          "fixedBond.rates",
                                                                          "fixedBond.faceAmount",
                                                                          "fixedBond.redemption"),
                                                               label="Fixed Rate Bond Parameters"
                                                               ),
                                                        label="Fixed Rate Bond"),
                                          aNotebookPage(
                                                        label="Floating Rate Bond")
                                          ),
                                aFrame(aContainer("settlementDays", "calendar",
                                                  "dayCounter", "period",
                                                  "businessDayConvention",
                                                  "terminationDateConvention",
                                                  "dateGeneration"
                                                  ),
                                       label="DateParameters"
                                       ),
                                aFrame(aContainer("discountCurveObj"),
                                       label="Discount Curve"
                                       )
                                ),
                     aContainer(aFrame(aContainer("NPV","cleanPrice",
                                                  "dirtyPrice","yield","cf"),
                                       label="Result"
                                       )
                                ),
                     horizontal=TRUE
                     )

    dlg$make_gui(gui_layout=view2)
}

