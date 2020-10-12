DM ODSRESULTS "CLEAR;";
DM LOG "CLEAR;";
filename tmp url 'http://stats.idre.ucla.edu/stat/data/hdp.csv';
data hdp;
infile tmp dlm=',' firstobs=2;
input tumorsize co2 pain wound mobility ntumors nmorphine 
  remission lungcapacity Age Married $ FamilyHx $ SmokingHx $
  Sex $ CancerStage $ LengthofStay WBC RBC BMI IL6 CRP DID $
  Experience School $ Lawsuits HID $ Medicaid;
run;
data hdp;
  set hdp;
  if SmokingHx = "former" then SmokingHx2 = 1;
    else SmokingHx2 = 0;
  if SmokingHx = "never" then SmokingHx3 = 1;
    else SmokingHx3 = 0;
  if CancerStage = "II" then CancerStage2 = 1;
    else CancerStage2 = 0;
  if CancerStage = "III" then CancerStage3 = 1;
    else CancerStage3 = 0;
  if CancerStage = "IV" then CancerStage4 = 1;
    else CancerStage4 = 0;
run;

*Null Model;
proc genmod data = hdp;
  model nmorphine = / dist=poisson link=log;
run;

proc genmod data = hdp;
  model nmorphine = Age LengthofStay BMI CancerStage2 CancerStage3 CancerStage4 / dist=poisson link=log;
run;

/*using nlmixed*/
proc nlmixed data = hdp;
  parms b0=.839 b1=-.001 b2=.003 b3=.013 b4=.096 b5=.209 b6=.306;
  mu = exp(b0 + b1*Age + b2*LengthofStay + b3*BMI + 
    b4*CancerStage2 + b5*CancerStage3 + b6*CancerStage4);
  ll = nmorphine*log(mu) - mu - lgamma(nmorphine + 1);
  model nmorphine ~ general(ll);
run;	
