*CHANGE LOG
*11-9-20: File Created

;

PROC DATASETS NOPRINT LIB=WORK KILL;
RUN;
QUIT;
proc import out = tte_c datafile="C:\Users\chacr\OneDrive\Documents\Coding\JHU Data\COVID-19\Modified Data Sets\COVID Time to Peak Case (Through 2020-11-06).xlsx"
dbms=xlsx replace;
getnames=Yes;
datarow=2;
run;
proc import out = tte_d datafile="C:\Users\chacr\OneDrive\Documents\Coding\JHU Data\COVID-19\Modified Data Sets\COVID Time to Peak Death (Through 2020-11-06) (ver2).xlsx"
dbms=xlsx replace;
getnames=Yes;
datarow=2;
run;


DM ODSRESULTS "CLEAR;";
DM LOG "CLEAR;";



*/////////////////////////////////////// Descriptive Analysis & Checking Model Assumptions /////////////////////////////////////////////////////////;
proc means data =tte;
var ;
run;
*Examining the measures of central tendency;
proc means mean min max range var std data =cum1;
var ;
output out = mean_anal mean= _mean  _mean var= _var _var;
run;

*Checking for overdispersion;

	*Variance Much Larger Than Mean;
		*For Cases: Variance is X times larger than the mean;
		*For Deaths: Variance is X times larger than the mean;
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
*///////////////////////////////////////Model Selection/////////////////////////////////////////////////////////;
*///////////////////////////////////////Final Model/////////////////////////////////////////////////////////;










/**/
/*/*PCA*/*/
/*	proc sort data = covid;*/
/*	by country;*/
/*	run;*/
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
/**/
/**/
/*data covid;*/
/**/
/*set covid;*/
/*sas_date = date - 21916;*/
/*format sas_date mmddyy10.;*/
/*run;*/
/**/
/**Random Country fixed effect of time only;*/
/*proc mixed data = covid1;*/
/*class  country;*/
/*model case_count = date/s;*/
/*random int /subject = country type=UN;*/
/*run;*/
/**/
/**/
/**/
/**/
/**/
/**/
/**/
/**/
/**/
/**/

/*
/*PROC MIXED DATA = TOE COVTEST;*/
/*CLASS ID GENDER TX CLUB;*/
/*MODEL LEN = MON GENDER TX CLUB TX*MON / S;*/
/*RANDOM INT MON/ SUBJECT = ID G V TYPE=ARH(1);*/
/*LSMEANS GENDER / AT MON = (0); */
/*	LSMEANS GENDER/ AT MON = (2.5) ; */
/*	LSMEANS GENDER/ AT MON = (5) ; */
/*	LSMEANS GENDER/ AT MON = (7.5) ; */
/*	LSMEANS GENDER/ AT MON = (10) ; */
/*	LSMEANS GENDER/ AT MON = (12.5) ;*/
/*ODS OUTPUT SOLUTIONF=FIXED SOLUTIONR=RANDOM1;*/
/*FORMAT TX FMTTX. CLUB FMTCLUB. GENDER FMTSEX.;*/
/*RUN;*/
		
*/
/*proc mixed data = covid;*/
/*class  country;*/
/*model case_count = date/s;*/
/*random int /subject = country type=UN;*/
/*run;*/
/**/
/*proc mixed data = covid;*/
/*class  country;*/
/*model stay_home = case_count case1-case21/s;*/
/*random int /subject = country type=UN;*/
/*run;*/
/**/
/**Proc Mixed Case Count SARS & MERS Exp Sensitivity Analysis;*/
/*%macro sarsexp(dset ,exp_level);*/
/**/
/*DM ODSRESULTS "CLEAR;";*/
/*DM LOG "CLEAR;";*/
/**/
/**/
/**SARS & MERS Exp Sensitivity Analysis;*/
/*%macro sarsexp(exp_level); */
/*proc mixed data = covid1;*/
/*class mers_sars_exp1 country;*/
/*model case_count = date pop_2020 total_score school_close domestic_travel internat_travel large_gather public_events stay_home &exp_level/s;*/
/**/
/**Proc Mixed Case Count SARS & MERS Exp Sensitivity Analysis (With Lagged 7 case count);*/
/*%macro sarsexp7(dset ,exp_level);*/
/*DM ODSRESULTS "CLEAR;";*/
/*DM LOG "CLEAR;";*/
/*proc mixed data = &dset;*/
/*class &exp_level country;*/
/*model case7 = pop_2020 gdp_in_mil_us total_score stay_home &exp_level/s;*/
/*random int /subject = country s  type=UN G ;*/
/*/*repeated date/subject=country;*/*/
/*run;*/
/*%mend;*/
/**Daily;*/
/**/
/**/
/*%sarsexp(covid,mers_sars_exp1);*/
/*%sarsexp(covid,mers_sars_exp5);*/
/*%sarsexp(covid,mers_sars_exp10);*/
/*%sarsexp(covid,mers_sars_exp20);*/
/*%sarsexp(covid,mers_sars_exp100);*/
/*%sarsexp(covid,mers_sars_exp200);*/
/*%sarsexp(covid,mers_sars_exp300);*/
/*%sarsexp(covid,mers_sars_exp400);*/
/*%sarsexp(covid,mers_sars_exp500);*/
/*%sarsexp(covid,mers_sars_exp1000);*/
/**Weekly;*/
/*%sarsexp(covid_week,mers_sars_exp1);*/
/*%sarsexp(covid_week,mers_sars_exp5);*/
/*%sarsexp(covid_week,mers_sars_exp10);*/
/*%sarsexp(covid_week,mers_sars_exp20);*/
/*%sarsexp(covid_week,mers_sars_exp100);*/
/*%sarsexp(covid_week,mers_sars_exp200);*/
/*%sarsexp(covid_week,mers_sars_exp300);*/
/*%sarsexp(covid_week,mers_sars_exp400);*/
/*%sarsexp(covid_week,mers_sars_exp500);*/
/*%sarsexp(covid_week,mers_sars_exp1000);*/
/**/
/**Proc Mixed Case Count SARS & MERS Exp Sensitivity Analysis (With Lagged 7 case count);*/
/*%macro sarsexp7(dset ,exp_level);*/
/*DM ODSRESULTS "CLEAR;";*/
/*DM LOG "CLEAR;";*/
/*proc mixed data = &dset;*/
/*class &exp_level country;*/
/*model case7 = pop_2020 gdp_in_mil_us total_score stay_home &exp_level/s;*/
/*random int /subject = country s  type=UN G ;*/
/*/*repeated date/subject=country;*/*/
/*run;*/
/*%mend;*/
/**Daily;*/
/**/
/**/
/**/
/**/
/*%sarsexp7(covid,mers_sars_exp1);*/
/*%sarsexp7(covid,mers_sars_exp5);*/
/*%sarsexp7(covid,mers_sars_exp10);*/
/*%sarsexp7(covid,mers_sars_exp20);*/
/*%sarsexp7(covid,mers_sars_exp100);*/
/*%sarsexp7(covid,mers_sars_exp200);*/
/*%sarsexp7(covid,mers_sars_exp300);*/
/*%sarsexp7(covid,mers_sars_exp400);*/
/*%sarsexp7(covid,mers_sars_exp500);*/
/*%sarsexp7(covid,mers_sars_exp1000);*/
/**Proc Mixed Death Counts SARS & MERS Exp Sensitivity Analysis;*/
/*%macro sarsexp(dset ,exp_level);*/
/*DM ODSRESULTS "CLEAR;";*/
/*DM LOG "CLEAR;";*/
/*proc mixed data = &dset;*/
/*class &exp_level country;*/
/*model death_count = pop_2020 gdp_in_mil_us total_score school_close domestic_travel internat_travel large_gather public_events stay_home ages_65_and_above_of_total_popul prevalence_hivaids_sex_both_age_ obesity_ihme_2019 diabetes_prev_ages_20_to_79 deaths_smoking_sex_both_age_age_ copd_dalys_per_100000 &exp_level/s;*/
/**/
/*random int /subject = country  type=UN G ;*/
/*run;*/
/*%mend;*/
/*%sarsexp(mers_sars_exp1);*/
/*%sarsexp(mers_sars_exp5);*/
/*%sarsexp(mers_sars_exp10);*/
/*%sarsexp(mers_sars_exp20);*/
/*%sarsexp(mers_sars_exp100);*/
/*%sarsexp(mers_sars_exp200);*/
/**/
/*proc mixed data = covid1;*/
/*class mers_sars_exp1 country;*/
/*model case_count = date gdp_rank pop_2020 total_score mers_sars_exp1/s;*/
/*random int /subject = country type=UN;*/
/*run;*/
/**/
/*proc mixed data = covid1;*/
/*class mers_sars_exp5 country;*/
/*model case_count = date gdp_rank pop_2020 un_population_division_median_ag copd_dalys_per_100000 total_score cancer_prevalence mers_sars_exp5/s;*/
/*random int /subject = country type=UN;*/
/*run;*/
/*        */
/**/
/*proc mixed data = covid1;*/
/*class mers_sars_exp5 country;*/
/*model death_count = date gdp_rank pop_2020 obesity_ihme_2019 smoking_ihme_2019 un_population_division_median_ag total_score cancer_prevalence prevalence_hivaids_sex_both_age_ /s;*/
/*random int /subject = country type=UN;*/
/*run;*/
/**/
/**/
/*proc glimmix data = covid method= quad(fastquad qpoint=1) empirical =classical;*/
/*class country stay_home(ref='0') ;*/
/*model case7=  pop_2020 gdp_in_mil_us total_score stay_home  / link= log dist = poisson s;*/
/*random int / subject = country type=cs;*/
/*run;*/




/**Proc Glimmix SARS & MERS Exp Sensitivity Analysis;*/
/*%macro sarsexpglim(exp_level); */
/*/*proc glimmix data = covid1;*/*/
/*/*class mers_sars_exp1 country;*/*/
/*/*model case_count =  pop_2020 total_score school_close domestic_travel internat_travel large_gather public_events stay_home &exp_level/s dist=negbin link=log;*/*/
/*/*random int /subject = country  type=cs;*/*/
/*/*/*repeated date/subject=country;*/*/*/
/*/*run;*/*/
/*/*quit;*/;*/
/**/
/*proc glimmix data = covid1;*/
/*class country;*/
/*model case_count =  pop_2020  &exp_level/s dist=negbin link=log;*/
/*random int /subject = country  type=cs;*/
/*/*repeated date/subject=country;*/*/
/*run;*/
/*quit;*/
/*%mend;*/
/**/
/*%sarsexpglim(mers_sars_exp1);*/
/*%sarsexpglim(mers_sars_exp5);*/
/*%sarsexpglim(mers_sars_exp10);*/
/*%sarsexpglim(mers_sars_exp20);*/
/*%sarsexpglim(mers_sars_exp100);*/
/*%sarsexpglim(mers_sars_exp200);*/;


/*proc mixed data = covid1;*/
/*class mers_sars_exp1 country;*/
/*model case_count = date gdp_rank pop_2020 total_score mers_sars_exp1/s ;*/
/*random int /subject = country type=UN;*/
/*run;*/
/**/
/*proc mixed data = covid1;*/
/*class mers_sars_exp5 country;*/
/*model case_count = date gdp_rank pop_2020 un_population_division_median_ag copd_dalys_per_100000 total_score cancer_prevalence mers_sars_exp5/s;*/
/*random int /subject = country type=UN;*/
/*run;*/
/**/
/*proc mixed data = covid1;*/
/*class mers_sars_exp5 country;*/
/*model death_count = date gdp_rank pop_2020 obesity_ihme_2019 smoking_ihme_2019 un_population_division_median_ag total_score cancer_prevalence prevalence_hivaids_sex_both_age_ /s;*/
/*random int /subject = country type=UN;*/
/*run;*/

