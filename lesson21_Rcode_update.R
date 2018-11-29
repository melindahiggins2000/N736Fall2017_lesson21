# ==================================
# N736 Lesson 21 - dependent/paired data
#
# dated 11/27/2018
# Melinda Higgins, PhD
# 
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
# In the HELP dataset there are 5 time points
# baseline and 4 follow-up time points 
# at 6m, 12m, 18m and 24m
#
# for today's lesson we will be working with the PCS
# physical component score for the SF36 quality of life tool
# let's look at how these 5 PCS measurements are
# correlated across time
#
# and we'll also look at the treat group.
# ============================================.

h1 <- helpdat %>%
  select(treat, pcs, pcs1, pcs2, pcs3, pcs4)

# ============================================.
# let's look at the correlations between 
# these variables
# ============================================;

# look at the correlation matrix between
# the 5 pcs measurements over time
library(psych)
psych::corr.test(h1[,2:6], method="pearson")

# notice the varying sample sizes
# across these paired tests
# this is due to attrition over time

# =================================================.
# notice that most of these correlations have r>0.4 indicating
# moderate to large correlation across time
# this makes sense since particpants scores probably
# do not change a lot every 6 months and will tend to be 
# similar to each other WITHIN each particpant
# more so than pcs scores BETWEEN participants
# =================================================.

# let's look at the first 2 time points and run a PAIRED t-test
# to see if the scores are significantly changing across time
# WITHIN individuals.

t.test(h1$pcs, h1$pcs1, paired=TRUE)

# another way to approach this is to compute
# the change scores and compare the difference
# scores to 0.

h1 <- h1 %>%
  mutate(diff_pcs_bl_1=pcs - pcs1)

t.test(h1$diff_pcs_bl_1, mu=0)

# when we run a paired t-test, one of the assumptions
# is that the difference or change scores have a normal
# distribution - not the original scores but the difference scores
# these are good here.

qqnorm(h1$diff_pcs_bl_1)

# we can also run a paired t-test using RM-ANOVA
# repeated measures ANOVA
# compare this F-test wth the 
# t-test from the paired t-test
# for 2 groups when df=1
# a t(df=1)^2 = F-test

# to do these analyses in R, we first
# have to reshape the data from WIDE
# to long

# add rowid to h1
h1 <- h1 %>%
  mutate(rowid=as.numeric(rownames(h1)))

# trick - compute sum of pcs and pcs1
# which will be NA if either pcs or pcs1 is NA
h1 <- h1 %>%
  mutate(pcs12 = pcs + pcs1)

# filter the cases which are NOT ! missing NA for pcs12 sum
# there should be 246 cases
h12c <- h1 %>%
  filter(!is.na(pcs12))

# select just pcs and pcs1 and rowid
h12c <- h12c %>%
  select(rowid, pcs, pcs1, treat, diff_pcs_bl_1)

# restructure the data from WIDE to LONG format
# there should now be 492 rows = 246 subjects * 2 times
h12c_long <- h12c %>%
  gather(key=pcslabel,
         value=pcs,
         -c(rowid, treat, diff_pcs_bl_1))

# add a time variable to long format
h12c_long <- h12c_long %>%
  mutate(time=c(rep(0,246),
                rep(1,246)))

# use this dataset to run RM-ANOVA

# change rowid and time and treat to factor class type
h12c_long$rowid <- factor(h12c_long$rowid)
h12c_long$time <- factor(h12c_long$time)
h12c_long$treat <- factor(h12c_long$treat)

# METHOD 1 using aov() function from stats (base) package
# time is "nested" within subject - this is defined in
# Error(rowid/time) to indicate dependent measures within id
rm1 <- aov(pcs ~ time + Error(rowid/time), 
           data=h12c_long)

rm1
summary(rm1)

# METHOD 2 using lme() function from nlme package
library(nlme)
rm2 <- nlme::lme(pcs ~ time, 
                 random = ~1 | rowid/time, 
                 data = h12c_long)

rm2
summary(rm2)

# METHOD 3 - using ezANOVA from ez package
library(ez)
rm3 <- ez::ezANOVA(data = h12c_long,
                   dv = pcs,
                   wid = rowid,
                   within = time,
                   detailed = TRUE,
                   type = 3)
rm3
summary(rm3)

# compare the 2 changes from BL to 6m
# for pcs and pcs1 between the 2 treat groups
bartlett.test(h1$diff_pcs_bl_1 ~ h1$treat)
t.test(h1$diff_pcs_bl_1 ~ h1$treat, var.equal=TRUE)

# now let's run a RM-ANOVA
# for the changes from BL to 6m
# BETWEEN the 2 treat groups
# compare the time*treat effect to
# the t-test above for the difference scores
# look at the 2nd part of the table
# terms in the model, 2 main effects, 1 interaction effect
# - time (within)
# - treat (between)
# - time-by-treat (within-by-between)

rm4 <- aov(pcs ~ time * treat + Error(rowid/time), 
           data = h12c_long)
summary(rm4)

# we can make a plot of
# pcs and pcs1 scores by group
# to get an idea of trend across time
# but this plot is cross sectional not paired

ggplot(h12c_long, aes(x=time, y=pcs)) + 
  geom_boxplot() +
  stat_summary(fun.y=mean, geom="point", shape=5, size=4) + 
  xlab("Time: Baseline (0) and 6m (1)") +
  ylab("PCs Scores") +
  facet_wrap(~treat) +
  ggtitle("Usual Care = 0; HELP Clinic = 1")

# another plot approach
with(h12c_long, 
     interaction.plot(time, treat, pcs,
       type="b", col=c("red","blue"), pch=c(16,18),
       main="Interaction Plot for Treatment Group and Time"))

# plot option using boxplots
boxplot(pcs ~ treat*time, 
        data=h12c_long, 
        col=(c("gold", "green")),
        main="Interaction Plot for Treatment Group and Time",
        ylab="Physical Component Quality of Life",
        xlab="Time (Baseline and 6mo)")

# ===================================
# look at more time points

# trick - compute sum of pcs and pcs1
# which will be NA if either pcs or pcs1 is NA
h1 <- h1 %>%
  mutate(pcs12345 = pcs + pcs1 + pcs2 + pcs3 + pcs4)

summary(h1$pcs12345)

# filter the cases which are NOT ! missing NA for 
# sum of pcs to pcs4
# there should be 98 cases
h12345c <- h1 %>%
  filter(!is.na(pcs12345))

# select just pcs to pcs4 and rowid, treat
h12345c <- h12345c %>%
  select(rowid, pcs, pcs1, pcs2, pcs3, pcs4, 
         treat)

# restructure the data from WIDE to LONG format
# there should now be 490 rows = 98 subjects * 5 times
h12345c_long <- h12345c %>%
  gather(key=pcslabel,
         value=pcs,
         -c(rowid, treat))

# add a time variable to long format
h12345c_long <- h12345c_long %>%
  mutate(time=c(rep(0,98),
                rep(1,98),
                rep(2,98),
                rep(3,98),
                rep(4,98)))

# use this dataset to run RM-ANOVA

# change rowid and time and treat to factor class type
h12345c_long$rowid <- factor(h12345c_long$rowid)
h12345c_long$time <- factor(h12345c_long$time)
h12345c_long$treat <- factor(h12345c_long$treat)

# METHOD 1 using aov() function from stats (base) package
# time is "nested" within subject - this is defined in
# Error(rowid/time) to indicate dependent measures within id
rm5 <- aov(pcs ~ time + Error(rowid/time), 
           data=h12345c_long)

rm5
summary(rm5)

# METHOD 3 - using ezANOVA from ez package
# now we get the sphericity test
library(ez)
rm6 <- ez::ezANOVA(data = h12345c_long,
                   dv = pcs,
                   wid = rowid,
                   within = time,
                   detailed = TRUE,
                   type = 3)
rm6
# summary(rm6)

# another plot approach
with(h12345c_long, 
     interaction.plot(time, treat, pcs,
       type="b", col=c("red","blue"), pch=c(16,18),
       main="Interaction Plot for Treatment Group and Time"))

# plot option using boxplots
boxplot(pcs ~ treat*time, 
        data=h12345c_long, 
        col=(c("gold", "green")),
        main="Interaction Plot for Treatment Group and Time",
        ylab="Physical Component Quality of Life",
        xlab="Time (Baseline to 24 mo)")

# look at treatment by time for 5 time points
# for 98 complete cases

rm7 <- aov(pcs ~ time * treat + Error(rowid/time), 
           data=h12345c_long)

rm7
summary(rm7)

# select just pcs to pcs4 and rowid, treat
h1c <- h1 %>%
  select(rowid, pcs, pcs1, pcs2, pcs3, pcs4, 
         treat)

summary(h1c)

Hmisc::describe(h1c)

# restructure the data from WIDE to LONG format
# there 
h1c_long <- h1c %>%
  gather(key=pcslabel,
         value=pcs,
         -c(rowid, treat))

# sample sizes at each time point
# pcs   n=453
# pcs1  n=246
# pcs2  n=211
# pcs3  n=248
# pcs4  n=266
# which is 1424
# but 453 * 5 = 2265, rows in h1c

# add a time variable to long format
h1c_long <- h1c_long %>%
  mutate(time=c(rep(0,453),
                rep(1,453),
                rep(2,453),
                rep(3,453),
                rep(4,453)))

# run rm-anova model for varying numbers over time
# look at treatment by time for 5 time points
# for all cases with a pcs measurement

rm8 <- aov(pcs ~ time * treat + Error(rowid/time), 
           data=h1c_long)

rm8
summary(rm8)

# remove any NAs
h1c_longnona <- h1c_long %>%
  filter(!is.na(pcs))

# another plot approach
with(h1c_longnona, 
     interaction.plot(time, treat, pcs,
       type="b", col=c("red","blue"), pch=c(16,18),
       main="Interaction Plot for Treatment Group and Time"))

