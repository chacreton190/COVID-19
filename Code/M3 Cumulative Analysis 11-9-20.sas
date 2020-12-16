*CHANGE LOG
*11-9-20: File Created Descriptive Analysis Completed


;

PROC DATASETS NOPRINT LIB=WORK KILL;
RUN;
QUIT;
DM ODSRESULTS "CLEAR;";
DM LOG "CLEAR;";

proc import out = cum datafile="C:\Users\chacr\OneDrive\Documents\Coding\JHU Data\COVID-19\Modified Data Sets\COVID Cumulative Incidence (Through 2020-11-20) (ver2).xlsx"
dbms=xlsx replace;
getnames=Yes;
datarow=2;
run;

data cum1;
set cum;
if case_incid_100k = 0 then case_incid_100k =.;
if death_incid_100k = 0 then death_incid_100k =.;
if sdi = 0 then sdi = .;
nl_death_in = log(death_incid_100k);
nl_case_in = log(case_incid_100k);
run;

DM ODSRESULTS "CLEAR;";
DM LOG "CLEAR;";

*/////////////////////////////////////// Descriptive Analysis & Checking Model Assumptions /////////////////////////////////////////////////////////;
*Examining the measures of central tendency;
proc means mean min max range var std data =cum1;
var case_incid_100k death_incid_100k;
title'Measures of Central Tendency For Cumulative Incidence Data';
output out = mean_anal mean=casein_mean deathin_mean var=casein_var deathin_var;
run;

*Checking for overdispersion;
data mean_anal1;
set mean_anal;
casein_var0mean = casein_var/casein_mean;
deathin_var0mean = deathin_var/deathin_mean;
run;
	*Variance Much Larger Than Mean;
		*For Cases: Variance is 1447 times larger than the mean;
		*For Deaths: Variance is 35 times larger than the mean;
*Evaluating Normality;
proc univariate data = cum1 normal plots;
var case_incid_100k death_incid_100k nl_death_in nl_case_in;
run;
*Examining Correlations;

proc corr data = cum1;
var case_incid_100k	death_incid_100k pop_2020 pop_den_per_sqkm us_dollars_in_mil un_population_division_median_ag;
title'Correlation Analysis Dependent Variables and Demographics'; 
run;


proc corr data = cum1;
var case_incid_100k	death_incid_100k deaths_smoking_sex_both_age_age_ obesity_ihme_2019 prevalence_hivaids_sex_both_age_ deaths_hivaids_sex_both_age_age_ diabetes_prevalence__of_populati;
title'Correlation Analysis Dependent Variables and Comorbities'; 
run;

proc corr data = cum1;
var case_incid_100k	death_incid_100k  healthcare_readiness quarantine_efficiency total_score;
title'Correlation Analysis Dependent Variables and Government Quality Part 1'; 
run;


proc corr data = cum1;
var case_incid_100k	death_incid_100k  mers_sars_quart gov_efficiency monitoring_and_detection emergency_preparedness country_vulnerability;
title'Correlation Analysis Dependent Variables and Government Quality Part 2'; 
run;

proc corr data = cum1;
var case_incid_100k	death_incid_100k SI_work_close SI_public_events SI_large_gather SI_domestic_travel SI_school_close SI_public_transpo SI_stay_home sdi;
title'Correlation Analysis Dependent Variables and Control Measures'; 
run;

proc sgscatter data = cum1;
matrix case_incid_100k	death_incid_100k pop_2020 pop_den_per_sqkm un_population_division_median_ag diabetes_prevalence__of_populati mers_sars_quart us_dollars_in_mil total_score SI_stay_home sdi;
run;

proc sgscatter data = cum1 ;
matrix case_incid_100k	death_incid_100k nl_case_in nl_death_in sdi day_num;
run;

proc corr data = cum1 plots(maxpoints=none)=matrix(histogram);
var case_incid_100k	death_incid_100k  sdi day_num;
title'Outcomes & SDI, Days to Peak';
run;

proc corr data = cum1 plots(maxpoints=none)=matrix(histogram);
var nl_case_in nl_death_in sdi day_num;
title'Natural Log of Outcomes & SDI, Days to Peak';
run;
	*the sdi seems to be a useless measure!!!!! but it is also bunched up around 100 way?????; 
	
*////////////////////////////////////////////////////////////////////////////////////////////////;
*///////////////////////////////////////Model Selection/////////////////////////////////////////////////////////;
*A negative binomial model seems to be the preference here;
proc genmod data =cum1;
class mers_sars_quart;
model case_incid_100k=/dist=negbin link=log;
run;

proc genmod data =cum1;
class sars_quart;
model case_incid_100k= pop_den_per_sqkm un_population_division_median_ag monitoring_and_detection sars_quart day_num sdi/dist=negbin link=log;
run;

proc genmod data =cum1;
class sars_quart;
model death_incid_100k= pop_den_per_sqkm un_population_division_median_ag monitoring_and_detection  sars_quart sdi day_num/dist=negbin link=log;
run;
*///////////////////////////////////////Final Model/////////////////////////////////////////////////////////;




/*/*PCA*/*/
/*	proc corr  data= covid SPEARMAN KENDALL;*/
/*	var school_close work_close large_gather public_events stay_home domestic_travel internat_travel;*/
/*	run;*/
/**/
/*	ODS GRAPHICS/ RESET WIDTH=15IN HEIGHT=9IN IMAGEMAP;*/
/*	proc corresp data = covid short norow=both;*/
/*	var stay_home work_close school_close  public_events  domestic_travel internat_travel large_gather;*/
/*	run;*/
/*	quit;*/
/*	ods graphics off;*/
/**/
/**/
/*	proc corresp data = covid ;*/
/*	var stay_home  school_close  public_events  domestic_travel internat_travel large_gather ;*/
/*	id country;*/
/*	run;*/
/*	quit;*/
/**/
/*	proc corresp data = covid ;*/
/*	var stay_home  school_close  public_events  domestic_travel internat_travel large_gather ;*/
/*	run;*/
/*	quit;*/
/**/
/*	proc princomp data = covid n=3;*/
/*	var stay_home  school_close  public_events  domestic_travel internat_travel large_gather ;*/
/*	run;*/
/*	quit;*/
/**/
/*	proc factor data = covid*/
/*	method=principal*/
/*	priors=one*/
/*	rotate=none*/
/*	scree;*/
/*	by country;*/
/*	var stay_home  school_close  public_events  domestic_travel internat_travel large_gather ;*/
/*	run;*/
/*	quit;*/
/**/
/**/
/**/
/*proc reg data = covid;*/
/*model case_count = mers_sars_exp100 pop_2020 gdp_in_mil_us total_score school_close domestic_travel internat_travel large_gather public_events stay_home ages_65_and_above_of_total_popul prevalence_hivaids_sex_both_age_ obesity_ihme_2019 diabetes_prev_ages_20_to_79 deaths_smoking_sex_both_age_age_ copd_dalys_per_100000/ selection= BACKWARD*/
/*;*/
/*run;*/
/*quit;*/
