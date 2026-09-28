#install.packages("bage")
#install.packages("poputils")

library(command)
library(bage)
library(poputils)
library(dplyr)
library(tidyr)
library(ggplot2)

setwd("D:/research/Data Analytics and Topology")

cmd_assign(.data = "out/data.rds",
           .out = "out/mod.rds")

data <- readRDS(.data) 

mod <- mod_pois(mig ~ reg_orig * reg_dest +
                  reg_orig * age +
                  reg_dest * age +
                  sex * age +
                  age * time + 
                  reg_orig * sex +
                  reg_dest * sex,
                data = data,
                exposure = popn_orig) |>
  set_prior(age ~ RW2()) |>
  set_prior(sex:age ~ RW()) |>
  set_prior(reg_orig:age ~ RW()) |>
  set_prior(reg_dest:age ~ RW()) |>
  set_prior(time ~ Lin_AR()) |>
  fit()

saveRDS(mod, file = .out)


