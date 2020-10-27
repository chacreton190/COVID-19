PROC DATASETS NOPRINT LIB=WORK KILL;
RUN;
QUIT;
DM ODSRESULTS "CLEAR;";
DM LOG "CLEAR;";
/*
PROC MIXED DATA = TOE COVTEST;
CLASS ID GENDER TX CLUB;
MODEL LEN = MON GENDER TX CLUB TX*MON / S;
RANDOM INT MON/ SUBJECT = ID G V TYPE=ARH(1);
LSMEANS GENDER / AT MON = (0); 
	LSMEANS GENDER/ AT MON = (2.5) ; 
	LSMEANS GENDER/ AT MON = (5) ; 
	LSMEANS GENDER/ AT MON = (7.5) ; 
	LSMEANS GENDER/ AT MON = (10) ; 
	LSMEANS GENDER/ AT MON = (12.5) ;
ODS OUTPUT SOLUTIONF=FIXED SOLUTIONR=RANDOM1;
FORMAT TX FMTTX. CLUB FMTCLUB. GENDER FMTSEX.;
RUN;
		
*/

proc import out = covid datafile="C:\Users\chacr\OneDrive\Documents\Coding\JHU Data\COVID-19\Modified Data Sets\Final COVID Data Set (Through 2020-10-10) (ver2).xlsx"
dbms=xlsx replace;
getnames=Yes;
datarow=2;
run;

data covid1;
set covid;
sas_date = date - 21916;
format sas_date mmddyy10.;
run;

*Random Country fixed effect of time only;
proc mixed data = covid1;
class  country;
model case_count = date/s;
random int /subject = country type=UN;
run;


DM ODSRESULTS "CLEAR;";
DM LOG "CLEAR;";

*SARS & MERS Exp Sensitivity Analysis;
%macro sarsexp(exp_level); 
proc mixed data = covid1;
class mers_sars_exp1 country;
model case_count = date pop_2020 total_score school_close domestic_travel internat_travel large_gather public_events stay_home &exp_level/s;
random int /subject = country  type=UN G ;
run;
%mend;
%sarsexp(mers_sars_exp1);
%sarsexp(mers_sars_exp5);
%sarsexp(mers_sars_exp10);
%sarsexp(mers_sars_exp20);
%sarsexp(mers_sars_exp100);
%sarsexp(mers_sars_exp200);

proc mixed data = covid1;
class mers_sars_exp1 country;
model case_count = date gdp_rank pop_2020 total_score mers_sars_exp1/s;
random int /subject = country type=UN;
run;

proc mixed data = covid1;
class mers_sars_exp5 country;
model case_count = date gdp_rank pop_2020 un_population_division_median_ag copd_dalys_per_100000 total_score cancer_prevalence mers_sars_exp5/s;
random int /subject = country type=UN;
run;

proc mixed data = covid1;
class mers_sars_exp5 country;
model death_count = date gdp_rank pop_2020 obesity_ihme_2019 smoking_ihme_2019 un_population_division_median_ag total_score cancer_prevalence prevalence_hivaids_sex_both_age_ /s;
random int /subject = country type=UN;
run;
