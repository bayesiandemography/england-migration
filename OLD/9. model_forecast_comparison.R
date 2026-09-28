library(bage)
library(rvec, warn.conflicts = FALSE)
library(dplyr, warn.conflicts = FALSE)
library(command)

setwd("D:/research/Data Analytics and Topology")

model1.name <- "RW regregage regtime"
model2.name <- "RW regregage regtime sextime"

aug1 <- readRDS(paste0("out/aug ",model1.name,".rds")) %>%
  filter(time > 2024)
aug2 <- readRDS(paste0("out/aug ",model2.name,".rds")) %>%
  filter(time > 2024)

summary(aug1$.fitted.mid - aug2$.fitted.mid)
#Min.    1st Qu.     Median       Mean    3rd Qu.       Max. 
#-5.165e-03 -5.731e-06  2.452e-06  1.873e-06  1.400e-05  4.245e-03 

summary(aug1$.fitted.lower - aug2$.fitted.lower)
#Min.    1st Qu.     Median       Mean    3rd Qu.       Max. 
#-2.814e-03 -9.564e-06  2.939e-06  9.103e-06  1.960e-05  2.794e-03 

summary(aug1$.fitted.upper - aug2$.fitted.upper)
#Min.    1st Qu.     Median       Mean    3rd Qu.       Max. 
#-7.034e-02 -3.509e-05 -1.960e-06  2.300e-05  2.989e-05  7.004e-02 
