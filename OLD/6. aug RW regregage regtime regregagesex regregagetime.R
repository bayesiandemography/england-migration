#install.packages("rvec")

library(bage)
library(rvec, warn.conflicts = FALSE)
library(dplyr, warn.conflicts = FALSE)
library(command)

setwd("D:/BayesianDemography/Data Analytics and Topology")

cmd_assign(.mod = "out/mod RW regregage regtime regregagesex regregagetime.rds",
           .out = "out/aug RW regregage regtime regregagesex regregagetime.rds")

mod <- readRDS(.mod)

set.seed(12345)

aug <- mod |>
  forecast(labels = 2025:2030,
           include_estimates = TRUE) |>
  select(-.expected) |>
  mutate(draws_ci(.fitted))

saveRDS(aug, file = .out)
