#install.packages("bage")
#install.packages("poputils")

library(command)
library(bage)
library(poputils)
library(dplyr)
library(tidyr)
library(ggplot2)

setwd("D:/BayesianDemography/Data Analytics and Topology")

cmd_assign(.data = "out/data.rds",
           .out = "out/mod RW alt regregage alt regtime alt.rds")

data <- readRDS(.data) 

mod <- mod_pois(mig ~ reg_orig + reg_dest + age + sex + time +
                  reg_orig:reg_dest +
                  reg_orig:age +
                  reg_dest:age +
                  age:sex +
                  age:time + 
                  reg_orig:time +
                  reg_dest:time +
                  reg_orig:reg_dest:age,
                data = data,
                exposure = popn_orig) |>
  set_prior(age ~ RW2()) |>
  set_prior(time ~ Lin_AR()) |>
  set_prior(reg_orig:age ~ RW2()) |>
  set_prior(reg_dest:age ~ RW2()) |>
  set_prior(age:sex ~ RW2()) |>
  set_prior(age:time ~ RW2()) |>
  set_prior(reg_orig:time ~ RW2()) |>
  set_prior(reg_dest:time ~ RW2()) |>
  set_prior(reg_orig:reg_dest:age ~ RW2()) |>
  fit()

saveRDS(mod, file = .out)


