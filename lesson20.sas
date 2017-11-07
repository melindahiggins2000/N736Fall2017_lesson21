
* make a copy to WORK;

data helpmkh;
  set library.helpmkh;
  run;

* ============================================.
* LESSON 20 - Poisson and
* Negative Binomial Regression
* for count data
*
* Melinda Higgins, PhD
* dated 11/5/2017
* ============================================.

* ============================================.
* For this lesson we'll use the helpmkh dataset
*
* Let's focus on d1
  How many times hositalized for 
  medical problems (lifetime)
* ============================================;

* ============================================
  let's look at the distribution of d1
  pay attention to the mean and standard deviation

  Poisson distributed variables should have
  a mean that is equal to the standard deviation

  If the standard deviation is larger than then mean
  then the variable has overdisperson

  Often in the presence of overdispersion you should
  also try fitting a negative binomial model

  and there are also zero-inflated versions of both
  of these distributions
  ============================================;

proc univariate data=helpmkh plots;
  var d1;
  histogram d1 / normal kernel;
  run;

* Fit a poisson generalized linear model
  for the pcs associated with number of times
  hospitalized for medical problems;

proc genmod data = helpmkh;
  model d1 = pcs / type3 dist=poisson;
  output out = poisson_pred predicted = pred1;
run;

proc sort data = poisson_pred;
  by pred1;
run;

proc sgplot data = poisson_pred;
  series x=pcs y=pred1;
run;

proc sgplot data=helpmkh;
  scatter x=pcs y=d1;
  loess x=pcs y=d1;
  yaxis values=(0 to 14 by 2);
run;

* Fit a negative binomial generalized linear model
  for the pcs associated with number of times
  hospitalized for medical problems;

proc genmod data = helpmkh;
  model d1 = pcs / type3 dist=nb;
  output out = nb_pred predicted = pred1;
run;

proc sort data = nb_pred;
  by pred1;
run;

proc sgplot data = nb_pred;
  series x=pcs y=pred1;
run;

proc sgplot data=helpmkh;
  scatter x=pcs y=d1;
  loess x=pcs y=d1;
  yaxis values=(0 to 14 by 2);
run;

* ===================================================
  see http://sasnrd.com/fit-discrete-distribution/
  ===================================================
  Code adapted from the SAS code provided here
* ===================================================;

/*****************************************************************************************************************

SAS file name: Discrete_Dist_Fit.sas
File location: 
_________________________________________________________________________________________________________________

Purpose: Fit discrete distributions to univariate data using PROC GENMOD
Author: Peter Clemmensen
Creation Date: 12/07/2017

This program supports the blog post "Fit Discrete Distributions to Univariate Data" on SASnrd.com

*****************************************************************************************************************/

/* Tabulate counts and plot data */
proc freq data=helpmkh noprint;
   tables d1 / out=CountMinMax;
run;
data _null_;
   set CountMinMax end=eof;
   if _N_=1 then call symputx('minCount', count);
   if eof then call symputx('maxCount', count);
run;
%put min=&minCount max=&maxCount;

/* Visualize the data */
title 'Frequency Plot of Count Dataset';
proc sgplot data=helpmkh;
   vbar d1;
   xaxis display=(nolabel);
   yaxis display=(nolabel);
run;
title;

/* Fit Poisson distribution to data */
proc genmod data=helpmkh;
   model d1= /dist=Poisson;       /* No variables are specified, only mean is estimated */
   output out=PoissonFit p=lambda;
run;

/* Save Poisson parameter lambda in macro variables */
data _null_;
   set PoissonFit(obs=1);
   call symputx('lambda', lambda);
run;

/* Use Min/Max values and the fitted Lambda to create theoretical Poisson Data */
data TheoreticalPoisson;
   do d1=0 to 15;
      po=pdf('Poisson', d1, &lambda);
      output;
   end;
run;


/* Negative Binomial Example */

/* Fit Negative Binomial distribution to data */
proc genmod data=helpmkh;
   model d1= /dist=NegBin;       /* No variables are specified, only mean is estimated */
   ods output parameterestimates=NegBinParameters;
run;

/* Transpose Data */
proc transpose data=NegBinParameters out=NegBinParameters;
   var estimate;
   id parameter;
run;

/* Calculate k and p from intercept and dispersion parameters */
data NegBinParameters;
   set NegBinParameters;
   k = 1/dispersion;
   p = 1/(1+exp(intercept)*dispersion);
run;

/* Save k and p in macro variables */
data _null_;
   set NegBinParameters;
   call symputx('k', k);
   call symputx('p', p);
run;

/* Calculate theoretical Negative Binomial PMF based on fitted k and p */
data TheoreticalNegBin;
   do d1=0 to 15;
      NegBin=pdf('NegBinomial', d1, &p, &k);
      output;
   end;
run;

/* Merge The datasets for plotting */
data PlotData(keep=d1 freq po negbin);
   merge TheoreticalPoisson TheoreticalNegBin CountMinMax;
   by d1;
   freq = PERCENT/100;
run;

/* Overlay fitted Poisson density with original data */
title 'Count data overlaid with fitted distributions';
proc sgplot data=PlotData noautolegend;
   vbarparm category=d1 response=freq / legendlabel='Count Data';
   series x=d1 y=po / markers markerattrs=(symbol=circlefilled color=red) 
                         lineattrs=(color=red)legendlabel='Fitted Poisson PMF';
   series x=d1 y=NegBin / markers markerattrs=(symbol=squarefilled color=green) 
                             lineattrs=(color=green)legendlabel='Fitted Negative Binomial PMF';
   xaxis display=(nolabel);
   yaxis display=(nolabel);
   keylegend / location=inside position=NE across=1;
run;
title;
