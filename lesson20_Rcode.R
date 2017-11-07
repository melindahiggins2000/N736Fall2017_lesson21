# ==================================
# Lesson 20 - Poisson 
# and Negative Binomial regression
# 
# Melinda Higgins, PhD
# dated 11/5/2017
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
# Let's focus on d1 which is the number of
# times hospitalized for medical problems
# (lifetime)
# ============================================.

h1 <- helpdat %>%
  select(d1, age, female, pss_fr,
         pcs, mcs, cesd, indtot)

# ============================================.
# let's look at the correlations between 
# these variables
# ============================================;

# look at the correlation matrix
library(psych)
psych::corr.test(h1, method="pearson")

# ============================================
# Make a histogram - using proportions
# instead of frequency counts
# overlay expected counts for Poisson and NB
# ============================================

# get frequencies of each count
tdf <- as.data.frame(table(h1$d1))
tdf$Var1 <- as.numeric(tdf$Var1)

# compute proportions from frequencies
tdf$Nmod <- tdf$Freq / sum(tdf$Freq)

# add expected probability for poisson and NB
tdf$pois <- dpois(tdf$Var1, lambda = mean(h1$d1))
tdf$nbinom <- dnbinom(tdf$Var1, mu = mean(h1$d1), size = 1)

ggplot(tdf, aes(x=Var1, y=Nmod)) +
  geom_histogram(stat="identity",
                 colour="black",
                 fill="lightblue") +
  geom_line(aes(y = pois), col = "red", size=1.5) + 
  geom_point(aes(y = pois), col = "red", size=3) + 
  geom_line(aes(y = nbinom), col = "blue", size=1.5,
            linetype=2) +
  geom_point(aes(y = nbinom), col = "blue", size=3) +
  xlab("d1 is Number of Times Hospitalized") +
  ylab("Probability of Count") +
  ggtitle("Red is Poisson and Blue is NB")

# ============================================.
# Given the stronger correlation between pcs
# and d1, let's use these in a model
# ============================================;

# null model - intercept only
pm1 <- glm(d1 ~ 1, data=h1, family=poisson)
summary(pm1)
exp(coef(pm1))

pm2 <- glm(d1 ~ pcs, data=h1, family=poisson)
summary(pm2)
exp(coef(pm2))

# load MASS library to get glm.nb
# for negative binomial models
library(MASS) 
nbm1 <- glm.nb(d1 ~ 1, data=h1)
summary(nbm1)
exp(coef(nbm1))

nbm2 <- glm.nb(d1 ~ pcs, data=h1)
summary(nbm2)
exp(coef(nbm2))

# compared AIC
# models with predictors have lower AIC
# NB lower than Poisson
AIC(pm1,pm2,nbm1,nbm2)

# compared BIC - useful between models - not nested
# models with predictors have lower AIC
# NB lower than Poisson
BIC(pm1,pm2,nbm1,nbm2)

# compare pm1 and pm2 - nested models
anova(pm1,pm2,test="Chisq")

# compare nbm1 and nbm2 - nested models
anova(nbm1,nbm2,test="Chisq")

