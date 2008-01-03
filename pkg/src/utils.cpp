
// RQuantLib -- R interface to the QuantLib libraries
//
// Copyright 2002, 2003, 2004, 2005  Dirk Eddelbuettel <edd@debian.org>
//
// $Id: utils.cc,v 1.8 2005/08/07 02:01:23 edd Exp $
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

#include "rquantlib.hpp"

// Builds the return list based on string/value pairs, and appends the
// params argument if it is not null.
SEXP makeReturnList(list<pair<string,double> > values, SEXP params) {
    int nret = values.size();
    if(params != 0)
	nret++;
    SEXP rl = PROTECT(allocVector(VECSXP,nret));
    SEXP nm = PROTECT(allocVector(STRSXP,nret));
    list<pair<string,double> >::iterator iter = values.begin();
    for(int i = 0; iter != values.end(); iter++, i++) {
	insertListElement(rl, nm, i, iter->second, iter->first.c_str());
    }
    if(params != 0) {
	SET_VECTOR_ELT(rl, nret-1, params);
	SET_STRING_ELT(nm, nret-1, mkChar("params"));
    }	
    setAttrib(rl, R_NamesSymbol, nm);
    UNPROTECT(2);
    return rl;
}

// Builds the return list based on string/value pairs, and appends the
// params argument if it is not null.
SEXP makeReturnList(list<pair<string,SEXP> > values, SEXP params) {
    int nret = values.size();
    if(params != 0)
	nret++;
    SEXP rl = PROTECT(allocVector(VECSXP,nret));
    SEXP nm = PROTECT(allocVector(STRSXP,nret));
    list<pair<string,SEXP> >::iterator iter = values.begin();
    for(int i = 0; iter != values.end(); iter++, i++) {
	SET_VECTOR_ELT(rl, i, iter->second);
	SET_STRING_ELT(nm, i, mkChar(iter->first.c_str()));
    }
    if(params != 0) {
	SET_VECTOR_ELT(rl, nret-1, params);
	SET_STRING_ELT(nm, nret-1, mkChar("params"));
    }	
    setAttrib(rl, R_NamesSymbol, nm);
    UNPROTECT(2);
    return rl;
}

// If we get a vector of double, cast.
int *allocIntVector(SEXP a, int *size) {
    int i, dim1;
    dim1 = length(a);
    if(dim1 == 0)
	error("null vector in unpackIntVector\n");
    int isInt = isInteger(a);
    int *vec = (int *)malloc(sizeof(int)*dim1);
    if(isInt) {
	for(i = 0; i < dim1; i++)
	    vec[i] = (int)(INTEGER(a)[i]);
    }	
    else {
	for(i = 0; i < dim1; i++)
	    vec[i] = (int)(REAL(a)[i]);
    }
    *size = dim1;
    return vec;
}

void freeIntVector(int *vec) {
    free(vec);
}

// Cannot be sure that R will hand us a vector of doubles, so we
// have to check for integer type and cast.
double *allocDoubleVector(SEXP a, int *size) {
    int i, dim1;
    dim1 = length(a);
    if(dim1 == 0)
	error("null vector in unpackDoubleVector\n");
    int isInt = isInteger(a);
    double *vec = (double *)malloc(sizeof(double)*dim1);
    if(isInt) {
	for(i = 0; i < dim1; i++)
	    vec[i] = (double)(INTEGER(a)[i]);
    }	
    else {
	for(i = 0; i < dim1; i++)
	    vec[i] = (double)(REAL(a)[i]);
    }	
    *size = dim1;
    return vec;
}

void freeDoubleVector(double *vec) {
    free(vec);
}

// Cannot be sure that R will hand us a matrix of doubles, so we
// have to check for integer type and cast.
// By default R stores a matrix by columns. For compatibility with C/C++
// we need to override this by specifying byrow=T (otherwise, you will
// get the transpose).
double **allocDoubleMatrix(SEXP a, int *dim1, int *dim2) {
    int i,j, d1,d2;
    SEXP dimAttr = getAttrib(a, R_DimSymbol);
    d1 = INTEGER(dimAttr)[0];
    d2 = INTEGER(dimAttr)[1];
    int isInt = isInteger(a);
    double *m = (double *)malloc(sizeof(double)*d1*d2);
    double **p = (double **)malloc(sizeof(double *)*d1);
    for(i = 0; i < d1; i++)
	p[i] = m + i*d2;
    if(isInt) {
	for(i=0; i < d1; i++)
	    for(j=0; j < d2; j++)
		p[i][j] = (double)(INTEGER(a)[i+d1*j]);
    }	
    else {
	for(i=0; i < d1; i++)
	    for(j=0; j < d2; j++)
		p[i][j] = (double)(REAL(a)[i+d1*j]);
    }	
    *dim1 = d1;
    *dim2 = d2;
    return p;
}

void freeDoubleMatrix(double **a) {
    free(*a);
    free(a);
}

char *getNameAt(SEXP list, int posn) {
    SEXP names = getAttrib(list, R_NamesSymbol);
    return CHAR(STRING_ELT(names,posn));
}

Date getDateValueAt(SEXP list, int posn) {
    int day, month, year;
    SEXP dateSEXP = VECTOR_ELT(list, posn);
    if(isInteger(dateSEXP)) {
	day   = INTEGER(dateSEXP)[0];
	month = INTEGER(dateSEXP)[1];
	year  = INTEGER(dateSEXP)[2];
    }
    else {
	day   = (int)REAL(dateSEXP)[0];
	month = (int)REAL(dateSEXP)[1];
	year  = (int)REAL(dateSEXP)[2];
    }
    Date d(day, (Month)month, year);
    return d;
}

// R interface utils, with thanks to Doug Bates
// simple helper function to insert "labelled" element into list
void insertListElement(SEXP &list, SEXP &names,
		       const int pos, const double value, 
		       const char *label) {
    SEXP vec = PROTECT(allocVector(REALSXP, 1));
    REAL(vec)[0] = value; 
    SET_VECTOR_ELT(list, pos, vec);
    SET_STRING_ELT(names, pos, mkChar(label));
    UNPROTECT(1);
}

// get the list element named str, or return NULL 
// courtesy of the R Exts manual, and the nls package
SEXP getListElement(SEXP list, char *str) {
    SEXP elmt = R_NilValue, names = getAttrib(list, R_NamesSymbol);
    int i;

    for (i = 0; i < length(list); i++)
	if(strcmp(CHAR(STRING_ELT(names, i)), str) == 0) {
	    elmt = VECTOR_ELT(list, i);
	    break;
	}
    return elmt;
}

boost::shared_ptr<VanillaOption>
makeOption(const boost::shared_ptr<StrikedTypePayoff>& payoff,
	   const boost::shared_ptr<Exercise>& exercise,
	   const boost::shared_ptr<Quote>& u,
	   const boost::shared_ptr<YieldTermStructure>& q,
	   const boost::shared_ptr<YieldTermStructure>& r,
	   const boost::shared_ptr<BlackVolTermStructure>& vol,
	   EngineType engineType,
	   Size binomialSteps,
	   Size samples) {
  
    boost::shared_ptr<PricingEngine> engine;
    switch (engineType) {
    case Analytic:
	engine = boost::shared_ptr<PricingEngine>(new AnalyticEuropeanEngine);
	break;
    case JR:
      engine = boost::shared_ptr<PricingEngine>(
			new BinomialVanillaEngine<JarrowRudd>(binomialSteps));
      break;
    case CRR:
      engine = boost::shared_ptr<PricingEngine>(
		new BinomialVanillaEngine<CoxRossRubinstein>(binomialSteps));
    case EQP:
      engine = boost::shared_ptr<PricingEngine>(
		new BinomialVanillaEngine<AdditiveEQPBinomialTree>(
      						   binomialSteps));
      break;
    case TGEO:
      engine = boost::shared_ptr<PricingEngine>(
		new BinomialVanillaEngine<Trigeorgis>(binomialSteps));
      break;
    case TIAN:
      engine = boost::shared_ptr<PricingEngine>(
		new BinomialVanillaEngine<Tian>(binomialSteps));
      break;
    case LR:
      engine = boost::shared_ptr<PricingEngine>(
		new BinomialVanillaEngine<LeisenReimer>(binomialSteps));
      break;
    case FiniteDifferences:
      engine = boost::shared_ptr<PricingEngine>(
		new FDEuropeanEngine(binomialSteps,samples));
      break;
    case PseudoMonteCarlo:
      engine = MakeMCEuropeanEngine<PseudoRandom>().withStepsPerYear(1)
      .withSamples(samples)
      .withSeed(42);
      break;
    case QuasiMonteCarlo:
      engine = MakeMCEuropeanEngine<LowDiscrepancy>().withStepsPerYear(1)
	.withSamples(samples);
      break;
    default:
      QL_FAIL("Unknown engine type");
    }
    boost::shared_ptr<BlackScholesProcess> 
      stochProcess(new
		   BlackScholesProcess(
				       Handle<Quote>(u),
				       Handle<YieldTermStructure>(q),
				       Handle<YieldTermStructure>(r),
				       Handle<BlackVolTermStructure>(vol)));
    return boost::shared_ptr<VanillaOption>(new
	   EuropeanOption(stochProcess, payoff, exercise, engine));

}

// QuantLib option setup utils, copied from the test-suite sources

boost::shared_ptr<YieldTermStructure>
makeFlatCurve(const Date& today,
	      const boost::shared_ptr<Quote>& forward,
	      const DayCounter& dc) {
    return boost::shared_ptr<YieldTermStructure>(
	   new FlatForward(today, Handle<Quote>(forward), dc));
}
  
boost::shared_ptr<BlackVolTermStructure> 
makeFlatVolatility(const Date& today,
		   const boost::shared_ptr<Quote>& vol,
		   const DayCounter dc) {
    return boost::shared_ptr<BlackVolTermStructure>(
	new BlackConstantVol(today, Handle<Quote>(vol), dc));
}
