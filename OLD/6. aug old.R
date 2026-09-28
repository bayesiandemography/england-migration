#install.packages("rvec")

library(bage)
library(rvec, warn.conflicts = FALSE)
library(dplyr, warn.conflicts = FALSE)
library(command)

setwd("D:/BayesianDemography/Data Analytics and Topology")

cmd_assign(.mod = "out/mod.rds",
           .out = "out/aug.rds")

mod <- readRDS(.mod)

aug <- mod |>
  forecast(labels = 2025:2030,
           include_estimates = TRUE) |>
  select(-.expected) |>
  mutate(draws_ci(.fitted))

saveRDS(aug, file = .out)
