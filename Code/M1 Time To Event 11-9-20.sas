*CHANGE LOG
*11-9-20: File Created
*11-14-20: Hazard Models Added;
;

PROC DATASETS NOPRINT LIB=WORK KILL;
RUN;
QUIT;
proc import out = tte_c datafile="C:\Users\chacr\OneDrive\Documents\Coding\JHU Data\COVID-19\Modified Data Sets\COVID Time to Peak Case (Through 2020-11-12).xlsx"
dbms=xlsx replace;
getnames=Yes;
datarow=2;
run;
proc import out = tte_d datafile="C:\Users\chacr\OneDrive\Documents\Coding\JHU Data\COVID-19\Modified Data Sets\COVID Time to Peak Death (Through 2020-11-12) (ver2).xlsx"
dbms=xlsx replace;
getnames=Yes;
datarow=2;
run;


DM ODSRESULTS "CLEAR;";
DM LOG "CLEAR;";
data tte_c;
set tte_c;
nl_pop = log(pop_2020);
nl_pop_den = log(pop_den_per_sqkm);
run;


*/////////////////////////////////////// Descriptive Analysis & Checking Model Assumptions /////////////////////////////////////////////////////////;
proc corr data = tte_c plots(maxpoints=none)=matrix(histogram);
var day_num sdi nl_pop nl_pop_den un_population_division_median_ag ages_65_and_above_of_total_popul diabetes_prev_ages_20_to_79 total_score mers_sars_quart;
run;

proc corr data = tte_c plots(maxpoints=none)=matrix(histogram) spearman;
var day_num ages_65_and_above_of_total_popul diabetes_prev_ages_20_to_79 total_score mers_sars_quart;
run;

proc corr data = tte_d plots(maxpoints=none)=matrix(histogram) spearman;
var day_num sdi pop_2020 pop_den_per_sqkm un_population_division_median_ag ages_65_and_above_of_total_popul prevalence_hivaids_sex_both_age_ htn_prevalence deaths_smoking_sex_both_age_age_ cancer_prevalence diabetes_prev_ages_20_to_79 total_score mers_sars_quart;
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
proc corr data = cum1;
var ;
run;
proc sgscatter data = ;
matrix ;
run;
*///////////////////////////////////////Checking Model Assumptions/////////////////////////////////////////////////////////;
DM ODSRESULTS "CLEAR;";
DM LOG "CLEAR;";
* Case;
	proc univariate data = tte_c(where=(peak_case=1));
	var day_num;
	histogram day_num / kernel;
	title'Probability Density Function of Peak Case by Day';
	run;

	proc univariate data = tte_c(where=(peak_case=1));
	var day_num;
	cdfplot day_num;
	title'Cumulative Density Function of Peak Case by Day';
	run;

	proc lifetest data=tte_c(where=(peak_case=1)) plots=survival(atrisk);
	time day_num*peak_case(0);
	title'Suvival Plot of Peak Case by Day';
	run; 
	proc lifetest data=tte_c(where=(peak_case=1)) plots=hazard(bw=200);
	time day_num*peak_case(0);
	title'Hazard Function Plot of Peak Case by Day';
	run; 
	*Cumulative Hazard function;
		ods output ProductLimitEstimates = ple_c;
		proc lifetest data=tte_c(where=(peak_case=1)) nelson outs=outtte_c;
		time day_num*peak_case(0);
		title'Cumulative Hazard Function Plot of Peak Case by Day';
		run;
		proc sgplot data = ple_c;
		series x = day_num y = CumHaz;
		run;

*Death;
	proc univariate data = tte_d(where=(peak_death=1));
	var day_num;
	histogram day_num / kernel;
	title'Probability Density Function of Peak Death by Day';
	run;

	proc univariate data = tte_d(where=(peak_death=1));
	var day_num;
	cdfplot day_num;
	title'Cumulative Density Function of Peak Death by Day';
	run;

	proc lifetest data=tte_d(where=(peak_death=1)) plots=survival(atrisk);
	time day_num*peak_death(0);
	title'Suvival Plot of Peak Case by Day';
	run; 

	proc lifetest data=tte_d(where=(peak_death=1)) plots=hazard(bw=200);
	time day_num*peak_death(0);
	title'Hazard Function Plot of Peak Death by Day';
	run; 
	*Cumulative Hazard function;
		ods output ProductLimitEstimates = ple_d;
		proc lifetest data=tte_d(where=(peak_death=1)) nelson outs=outtte_d;
		time day_num*peak_death(0);
		title'Cumulative Hazard Function Plot of Peak Death by Day';
		run;
		proc sgplot data = ple_d;
		series x = day_num y = CumHaz;
		run;
*///////////////////////////////////////Simple Survival Analysis/////////////////////////////////////////////////////////;
DM ODSRESULTS "CLEAR;";
DM LOG "CLEAR;";
*Case;
	proc lifetest data=tte_c atrisk outs=outtte_c nelson plots=survival(cb);
	time day_num*peak_case(0);
	title'Kaplan-Meier of Peak Case by Day';
	run;
		proc lifetest data=tte_c atrisk outs=outtte_c nelson plots=survival(cb);
		strata mers_sars_quart;
		time day_num*peak_case(0);
		title'Kaplan-Meier of Peak Case by Day';
		run;
		proc lifetest data=tte_c atrisk outs=outtte_c nelson plots=survival(cb);
		strata mers_sars_quart(4);
		time day_num*peak_case(0);
		Title'Kaplan-Meier of Peak Case by Day Stratified by the Mer/Sars Quartile 4';
		run;

		proc lifetest data=tte_c atrisk outs=outtte_c nelson plots=survival(cb);
		strata pop_den_per_sqkm(36.25,87.18,214.24,20546.77);
		time day_num*peak_case(0);
		title'Kaplan-Meier of Peak Case by Day Stratified by the Population Density Quartiles';
		run;
		proc lifetest data=tte_c atrisk outs=outtte_c nelson plots=survival(cb);
		strata pop_den_per_sqkm(214.24);
		time day_num*peak_case(0);
		title'Kaplan-Meier of Peak Case by Day Stratified by the Median Country Population';
		run;
		proc lifetest data=tte_c atrisk outs=outtte_c nelson plots=survival(cb);
		strata pop_2020(8467000);
		time day_num*peak_case(0);
		title'Kaplan-Meier of Peak Case by Day Stratified by the Median Country Population';
		run;

*Death;
	proc lifetest data=tte_d atrisk outs=outtte_c nelson plots=survival(cb);
	time day_num*peak_death(0);
	title'Kaplan-Meier of Peak Death by Day';
	run;
		proc lifetest data=tte_d atrisk outs=outtte_d nelson plots=survival(cb);
		strata mers_sars_quart;
		time day_num*peak_death(0);
		title'Kaplan-Meier of Peak Death by Day';
		run;
		QUIT;

		proc lifetest data=tte_d atrisk outs=outtte_d nelson plots=survival(cb);
		strata mers_sars_quart(4);
		time day_num*peak_death(0);
		title'Kaplan-Meier of Peak Death by Day Stratified by the Mer/Sars Quartile';
		run;
		QUIT;

		proc lifetest data=tests atrisk nelson plots=survival(cb);
		strata bi_mer_sars;
		time day_num*peak_death(0);
		title'Kaplan-Meier of Peak Death by Day Stratified by the Mer/Sars Quartile 4';
		run;
		QUIT;

*///////////////////////////////////////Model Selection/////////////////////////////////////////////////////////;

*Case;
	proc phreg data = tte_c plots=survival ;
	class mers_sars_quart(ref='0');
	model day_num*peak_case(0) = pop_2020 pop_den_per_sqkm sdi mers_sars_quart un_population_division_median_ag total_score;
	run;
*Death;

*///////////////////////////////////////Final Model/////////////////////////////////////////////////////////;




 ages_65_and_above_of_total_popul diabetes_prev_ages_20_to_79 
