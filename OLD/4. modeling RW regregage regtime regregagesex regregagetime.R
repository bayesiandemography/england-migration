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
           .out = "out/mod RW regregage regtime regregagesex regregagetime.rds")

data <- readRDS(.data) 

start <- Sys.time() 

mod <- mod_pois(mig ~ reg_orig + reg_dest + age + sex + time +
                  reg_orig:reg_dest +
                  reg_orig:age +
                  reg_dest:age +
                  age:sex +
                  age:time + 
                  reg_orig:time +
                  reg_dest:time +
                  reg_orig:reg_dest:age +
                  reg_orig:reg_dest:age:sex +
                  reg_orig:reg_dest:age:time,
                data = data,
                exposure = popn_orig) |>
  set_prior(age ~ RW2()) |>
  set_prior(time ~ Lin_AR()) |>
  set_prior(reg_orig:age ~ RW()) |>
  set_prior(reg_dest:age ~ RW()) |>
  set_prior(age:sex ~ RW()) |>
  set_prior(age:time ~ RW()) |>
  set_prior(reg_orig:time ~ RW()) |>
  set_prior(reg_dest:time ~ RW()) |>
  set_prior(reg_orig:reg_dest:age ~ RW()) |>
  set_prior(reg_orig:reg_dest:age:sex ~ RW()) |>
  set_prior(reg_orig:reg_dest:age:time ~ RW()) |>
  fit()

end <- Sys.time()

difftime(end, start, units = "secs")

#Time difference of 3575.731 secs

saveRDS(mod, file = .out)


