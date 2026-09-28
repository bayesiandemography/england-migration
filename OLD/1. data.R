#install.packages("command")

library(command)

setwd("D:/BayesianDemography/Data Analytics and Topology")

cmd_assign(.out = "out/data.rds")
data <- read.csv("data/england_region_mig.csv")

saveRDS(data, .out)
