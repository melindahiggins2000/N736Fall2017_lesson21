library(readxl)
smallExample <- read_excel("smallExample.xlsx", 
                           sheet = "rmanova1")

rm1 <- aov(measurements ~ factor(time) + 
             Error(factor(id)/factor(time)), 
           data = smallExample)

summary(rm1)

rm1a <- aov(measurements ~ factor(time) + 
             Error(factor(id)), 
           data = smallExample)

summary(rm1a)

library(dplyr)
smex <- smallExample %>% 
  filter(time<3)

rm2 <- aov(measurements ~ factor(time) + 
             Error(factor(id)/factor(time)), 
           data = smex)

summary(rm2)

