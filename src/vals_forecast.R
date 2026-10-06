
suppressPackageStartupMessages({
  library(bage)
  library(command)
  library(dplyr)
  library(readr)
  library(rvec)
  library(yaml)
})

cmd_assign(.fit = "out/fit_2.rds",
           .aug = "out/aug_2.rds",
           .config = "config.yaml",
           .out = "out/vals_forecast.rds")

fit <- read_rds(.fit)
aug <- read_rds(.aug)
config <- read_yaml(.config)

set.seed(config$seed)

labels <- seq.int(from = config$forecast_label_from,
                  to = config$forecast_label_to)

forecast  <- fit |>
  forecast(labels = labels)

out <- bind_rows(aug, forecast) |>
  mutate(draws_ci(.fitted)) |>
  select(-.fitted, -.expected)

write_rds(out, file = .out)
