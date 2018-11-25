
libname library 'C:\MyGithub\N736Fall2017_HELPdataset\' ;

proc format library = library ;
   value TREAT
      0 = 'usual care'  
      1 = 'HELP clinic' ;
   value FEMALE
      0 = 'Male'  
      1 = 'Female' ;
   value HOMELESS
      0 = 'no'  
      1 = 'yes' ;
   value G1B
      0 = 'no'  
      1 = 'yes' ;
   value F1A
      0 = 'Not at all or less than 1 day'  
      1 = '1-2 days'  
      2 = '3-4 days'  
      3 = '5-7 days or nearly every day for 2 weeks' ;
   value F1B
      0 = 'Not at all or less than 1 day'  
      1 = '1-2 days'  
      2 = '3-4 days'  
      3 = '5-7 days or nearly every day for 2 weeks' ;
   value F1C
      0 = 'Not at all or less than 1 day'  
      1 = '1-2 days'  
      2 = '3-4 days'  
      3 = '5-7 days or nearly every day for 2 weeks' ;
   value F1D
      0 = 'Not at all or less than 1 day'  
      1 = '1-2 days'  
      2 = '3-4 days'  
      3 = '5-7 days or nearly every day for 2 weeks' ;
   value F1E
      0 = 'Not at all or less than 1 day'  
      1 = '1-2 days'  
      2 = '3-4 days'  
      3 = '5-7 days or nearly every day for 2 weeks' ;
   value F1F
      0 = 'Not at all or less than 1 day'  
      1 = '1-2 days'  
      2 = '3-4 days'  
      3 = '5-7 days or nearly every day for 2 weeks' ;
   value F1G
      0 = 'Not at all or less than 1 day'  
      1 = '1-2 days'  
      2 = '3-4 days'  
      3 = '5-7 days or nearly every day for 2 weeks' ;
   value F1H
      0 = 'Not at all or less than 1 day'  
      1 = '1-2 days'  
      2 = '3-4 days'  
      3 = '5-7 days or nearly every day for 2 weeks' ;
   value F1I
      0 = 'Not at all or less than 1 day'  
      1 = '1-2 days'  
      2 = '3-4 days'  
      3 = '5-7 days or nearly every day for 2 weeks' ;
   value F1J
      0 = 'Not at all or less than 1 day'  
      1 = '1-2 days'  
      2 = '3-4 days'  
      3 = '5-7 days or nearly every day for 2 weeks' ;
   value F1K
      0 = 'Not at all or less than 1 day'  
      1 = '1-2 days'  
      2 = '3-4 days'  
      3 = '5-7 days or nearly every day for 2 weeks' ;
   value F1L
      0 = 'Not at all or less than 1 day'  
      1 = '1-2 days'  
      2 = '3-4 days'  
      3 = '5-7 days or nearly every day for 2 weeks' ;
   value F1M
      0 = 'Not at all or less than 1 day'  
      1 = '1-2 days'  
      2 = '3-4 days'  
      3 = '5-7 days or nearly every day for 2 weeks' ;
   value F1N
      0 = 'Not at all or less than 1 day'  
      1 = '1-2 days'  
      2 = '3-4 days'  
      3 = '5-7 days or nearly every day for 2 weeks' ;
   value F1O
      0 = 'Not at all or less than 1 day'  
      1 = '1-2 days'  
      2 = '3-4 days'  
      3 = '5-7 days or nearly every day for 2 weeks' ;
   value F1P
      0 = 'Not at all or less than 1 day'  
      1 = '1-2 days'  
      2 = '3-4 days'  
      3 = '5-7 days or nearly every day for 2 weeks' ;
   value F1Q
      0 = 'Not at all or less than 1 day'  
      1 = '1-2 days'  
      2 = '3-4 days'  
      3 = '5-7 days or nearly every day for 2 weeks' ;
   value F1R
      0 = 'Not at all or less than 1 day'  
      1 = '1-2 days'  
      2 = '3-4 days'  
      3 = '5-7 days or nearly every day for 2 weeks' ;
   value F1S
      0 = 'Not at all or less than 1 day'  
      1 = '1-2 days'  
      2 = '3-4 days'  
      3 = '5-7 days or nearly every day for 2 weeks' ;
   value F1T
      0 = 'Not at all or less than 1 day'  
      1 = '1-2 days'  
      2 = '3-4 days'  
      3 = '5-7 days or nearly every day for 2 weeks' ;
   value SATREAT
      0 = 'no'  
      1 = 'yes' ;
   value DRINKSTATUS
      0 = 'no'  
      1 = 'yes' ;
   value ANYSUBSTATUS
      0 = 'no'  
      1 = 'yes' ;
   value LINKSTATUS
      0 = 'no'  
      1 = 'yes' ;

proc datasets library = library;
modify helpmkh / correctencoding="WLATIN1";
   format     treat TREAT.;
   format    female FEMALE.;
   format  homeless HOMELESS.;
   format       g1b G1B.;
   format       f1a F1A.;
   format       f1b F1B.;
   format       f1c F1C.;
   format       f1d F1D.;
   format       f1e F1E.;
   format       f1f F1F.;
   format       f1g F1G.;
   format       f1h F1H.;
   format       f1i F1I.;
   format       f1j F1J.;
   format       f1k F1K.;
   format       f1l F1L.;
   format       f1m F1M.;
   format       f1n F1N.;
   format       f1o F1O.;
   format       f1p F1P.;
   format       f1q F1Q.;
   format       f1r F1R.;
   format       f1s F1S.;
   format       f1t F1T.;
   format   satreat SATREAT.;
   format drinkstatus DRINKSTATUS.;
   format anysubstatus ANYSUBSTATUS.;
   format linkstatus LINKSTATUS.;
quit;


* make a copy to WORK;

data helpmkh;
  set library.helpmkh;
  run;

* Encoding: UTF-8.
* =================================================.
* N736 Lesson 21 - dependent/paired data
*
* dated 11/8/2017
* Melinda Higgins, PhD
* =================================================.

* =================================================.
* In the HELP dataset there are 5 time points
* baseline and 4 follow-up time points at 6m, 12m, 18m and 24m
*
* for today's lesson we will be working with the PCS
* physical component score for the SF36 quality of life tool
* let's look at how these 5 PCS measurements are
* correlated across time.
* =================================================;

proc corr data=helpmkh;
  var pcs pcs1 pcs2 pcs3 pcs4;
  run;

* =================================================.
* notice that most of these correlations have r>0.4 indicating
* moderate to large correlation across time
* this makes sense since particpants scores probably
* do not change a lot every 6 months and will tend to be 
* similar to each other WITHIN each particpant
* more so than pcs scores BETWEEN participants
* =================================================.

* let's look at the first 2 time points and run a PAIRED t-test
* to see if the scores are significantly changing across time
* WITHIN individuals.
* pay attention to the different
  plots that SAS paired t-test provides;

proc ttest data=helpmkh;
  paired pcs*pcs1;
  run;

* another way to approach this is to compute
* the change scores and compare the difference
* scores to 0;

data help2;
  set helpmkh;
  diff_pcs_bl_1=pcs - pcs1;
  run;

proc ttest data=help2 h0=0 plots(showh0) sides=2 alpha=0.05;
   var diff_pcs_bl_1;
run;

* when we run a paired t-test, one of the assumptions
* is that the difference or change scores have a normal
* distribution - not the original scores but the difference scores
* these are good here;

proc univariate data=help2 plots;
  var diff_pcs_bl_1;
  histogram diff_pcs_bl_1 / normal;
  run;

* we can also run a paired t-test using RM-ANOVA
* repeated measures ANOVA
* compare this F-test wth the 
* t-test from the paired t-test
* for 2 groups when df=1
* a t(df=1)^2 = F-test;

proc glm data=help2;
  model pcs pcs1 = ;
  repeated time 2;
  run;

* compare the 2 changes from BL to 6m
* for pcs and pcs1 between the 2 treat groups;

proc ttest data=help2;
  class treat;
  var diff_pcs_bl_1;
  run;

* now let's run a RM-ANOVA
* for the changes from BL to 6m
* BETWEEN the 2 treat groups
* compare the time*treat effect to
* the t-test above for the difference scores;

proc glm data=help2;
  class treat;
  model pcs pcs1 = treat;
  repeated time 2;
  lsmeans treat;
  run;

* we can make a plot of
* pcs and pcs1 scores by group
* to get an idea of trend across time
* but this plot is cross sectional not paired;

* in SAS we need to restructure the data to get this
  plot - we'll do this in the next lesson;
