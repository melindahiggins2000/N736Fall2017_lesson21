# ==================================
# Lesson 19 - logistic regression
# 
# Melinda Higgins, PhD
# dated 10/31/2017
# ==================================

# ==================================
# we're be working with the 
# helpmkh dataset
# ==================================

library(tidyverse)
library(haven)

helpdat <- haven::read_spss("helpmkh.sav")

# ============================================.
# For this lesson we'll use the helpmkh dataset
#
# Let's focus on homeless as the main outcome variable
# which is dichotomous coded 0 and 1. We'll use
# logistic regression to look at predicting whether someone
# was homeless or not using these variables
# age, female, pss_fr, pcs, mcs, cesd and indtot
# ============================================.

h1 <- helpdat %>%
  select(homeless, age, female, pss_fr,
         pcs, mcs, cesd, indtot)

# ============================================.
# let's look at the correlations between these variables
# ============================================;

# look at the correlation matrix
library(psych)
psych::corr.test(h1, method="pearson")

# ============================================.
# Given the stronger correlation between indtot
# and homeless, let's run a t-test to see the comparison
# ============================================;

# Bartlett Test of Homogeneity of Variances
bartlett.test(indtot~homeless, data=h1)

# t-tests, unequal variance and then equal variance
t.test(indtot ~ homeless, h1)
t.test(indtot ~ homeless, h1,
       var.equal=TRUE)

# ============================================.
# Let's run a logistic regression of indtot to predict
# the probability of being homeless
# we'll also SAVE the predicted probabilities
# and the predicted group membership
#
# let's look at different thresholds pprob
# ctable gives us the classification table
#
# use the plots=roc to get the ROC curve
# ============================================;

m1 <- glm(homeless ~ indtot, data=h1,
          family=binomial)

m1
summary(m1)
coef(m1)
exp(coef(m1))

m1.predict <- predict(m1, newdata=h1,
                      type="response")

plot(h1$indtot, m1.predict)

library(Rcmdr)

#debug(utils:::unpackPkgZip)
#install.packages("rattle")
# install.packages("RGtk2")
#library(RGtk2)
#library(rattle)
#rattle()

# see https://www.r-bloggers.com/how-to-perform-a-logistic-regression-in-r/

# make an ROC curve

library(ROCR)
p <- predict(m1, newdata=h1, 
             type="response")
pr <- prediction(p, as.numeric(h1$homeless))
prf <- performance(pr, measure = "tpr", x.measure = "fpr")
plot(prf)

auc <- performance(pr, measure = "auc")
auc <- auc@y.values[[1]]
auc