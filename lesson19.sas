
* make a copy to WORK;

data helpmkh;
  set library.helpmkh;
  run;

* Encoding: UTF-8.
* ============================================.
* LESSON 19 - Logistic Regression
*
* Melinda Higgins, PhD
* dated 10/31/2017
* ============================================.

* ============================================.
* For this lesson we'll use the helpmkh dataset
*
* Let's focus on homeless as the main outcome variable
* which is dichotomous coded 0 and 1. We'll use
* logistic regression to look at predicting whether someone
* was homeless or not using these variables
* age, gender, pss_fr, pcs, mcs, cesd and indtot
* ============================================.

* ============================================.
* let's look at the correlations between these variables
* ============================================;

proc corr data=helpmkh;
  var homeless age female pss_fr pcs mcs cesd indtot;
  run;

* ============================================.
* Given the stronger correlation between indtot
* and homeless, let's run a t-test to see the comparison
* ============================================;

proc ttest data=helpmkh;
  class homeless;
  var indtot;
  run;

* ============================================.
* Let's run a logistic regression of indtot to predict
* the probability of being homeless
* we'll also SAVE the predicted probabilities
* and the predicted group membership
*
* let's look at different thresholds pprob
* ctable gives us the classification table
*
* use the plots=roc to get the ROC curve
* ============================================;

proc logistic data=helpmkh plots=roc;
  model homeless = indtot / ctable pprob=(0.2 to 0.8 by 0.1);
  output out=m1 p=prob;
  run;

* ============================================
  using the saved probabilities
  make a plot against the indtot predictor
* ============================================;

proc gplot data = m1;
  plot prob*indtot;
run;

* ============================================.
* Given the correlation matrix above, it looks like
* gender, pss_fr, pcs, and indtot are all significantly
* associated with being homeless
*
* let's put all of these together into 1
* model
* ============================================;

proc logistic data=helpmkh;
  model homeless = female pss_fr pcs indtot;
  run;

* ============================================
  let's also run using variable selection
* ============================================;

proc logistic data=helpmkh;
  model homeless = female pss_fr pcs indtot / selection=forward;
  run;
