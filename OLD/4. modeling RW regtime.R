#install.packages("bage")
#install.packages("poputils")

library(command)
library(bage)
library(poputils)
library(dplyr)
library(tidyr)
library(ggplot2)

set.seed(12345)

setwd("D:/BayesianDemography/Data Analytics and Topology")

cmd_assign(.data = "out/data.rds",
           .out = "out/mod RW regtime.rds")

data <- readRDS(.data) 

start <- Sys.time() 

mod <- mod_pois(mig ~ reg_orig * reg_dest +
                  reg_orig * age +
                  reg_dest * age +
                  sex * age +
                  age * time +
                  reg_orig * time +
                  reg_dest * time,
                data = data,
                exposure = popn_orig) |>
  set_prior(age ~ RW2()) |>
  set_prior(sex:age ~ RW()) |>
  set_prior(reg_orig:age ~ RW()) |>
  set_prior(reg_dest:age ~ RW()) |>
  set_prior(time ~ Lin_AR()) |>
  fit()

end <- Sys.time()

difftime(end, start, units = "secs")

#Time difference of 549.8476 secs

saveRDS(mod, file = .out)


