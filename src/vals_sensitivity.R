
suppressPackageStartupMessages({
  library(command)
  library(bage)
  library(dplyr)
  library(readr)
  library(yaml)
})

cmd_assign(.fit = "out/sensitivity_0.1.rds",
           .config = "config.yaml",
           .out = "out/vals_sensitivity_0.1.rds")

fit <- read_rds(.fit)
config <- read_yaml(.config)

reg_orig <- "London"
reg_dest <- "South East"

set.seed(config$seed)

labels <- seq.int(from = config$forecast_label_from,
                  to = config$forecast_label_to)

aug <- fit |>
  augment(rows = reg_orig == !!reg_orig & reg_dest == !!reg_dest)

forecast <- fit |>
  forecast(labels = labels,
           rows = reg_orig == !!reg_orig & reg_dest == !!reg_dest)

out <- bind_rows(aug, forecast) |>
  mutate(draws_ci(.fitted)) |>
  select(-.fitted, -.expected)

write_rds(out, file = .out)
