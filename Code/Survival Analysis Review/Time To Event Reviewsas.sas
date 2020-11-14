*CHANGE LOG
*11-13-20: File Created;

PROC DATASETS NOPRINT LIB=WORK KILL;
RUN;
QUIT;

DM ODSRESULTS "CLEAR;";
DM LOG "CLEAR;";
proc format ;
value fmt_gender
	  0 = "Male"
	  1 = "Female";
run;
data whas500;
set "C:\Users\chacr\OneDrive\Documents\Coding\JHU Data\COVID-19\Code\Survival Analysis Review\whas500.sas7bdat";
format gender fmt_gender.;
run;

*/////////////////////////////////////// Descriptive Analysis & Checking Model Assumptions /////////////////////////////////////////////////////////;
proc means data =tte;
var ;
run;
*Examining the measures of central tendency;
proc means mean min max range var std data =cum1;
var ;
output out = mean_anal mean= _mean  _mean var= _var _var;
run;
*Evaluating Normality;
proc univariate data =  normal plots;
var ;
run;
*Examining Correlations;
proc corr data = whas500 plots(maxpoints=none)=matrix(histogram);
var lenfol gender age bmi hr;
run;
*///////////////////////////////////////Checking Model Assumptions/////////////////////////////////////////////////////////;
proc univariate data = whas500(where=(fstat=1));
var lenfol;
histogram lenfol / kernel;
run;
proc univariate data = whas500(where=(fstat=1));
var lenfol;
cdfplot lenfol;
run;

*///////////////////////////////////////Model Selection/////////////////////////////////////////////////////////;

*1. Obtaining and interpreting tables of Kaplan-Meier Estimates from proc lifetest;
	*Examing the probability curve;
		proc lifetest data=whas500(where=(fstat=1)) plots=survival(atrisk);
		time lenfol*fstat(0);
		run; 

		proc lifetest data=whas500(where=(fstat=1)) plots=hazard(bw=200);
		time lenfol*fstat(0);
		run;
	*Kaplan-Meier;
		proc lifetest data=whas500 atrisk outs=outwhas500;
		time lenfol*fstat(0);
		run;

ods output ProductLimitEstimates = ple;
proc lifetest data=whas500(where=(fstat=1))  nelson outs=outwhas500;
time lenfol*fstat(0);
run;
proc sgplot data = ple;
series x = lenfol y = CumHaz;
run;
*///////////////////////////////////////Final Model/////////////////////////////////////////////////////////;






