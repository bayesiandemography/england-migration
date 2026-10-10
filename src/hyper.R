
suppressPackageStartupMessages({
  library(command)
  library(bage)
  library(dplyr)
  library(readr)
  library(yaml)
})

cmd_assign(.fit = "out/fit_0.rds",
           .config = "config.yaml",
           .out = "out/hyper_0.rds")

fit <- read_rds(.fit)
config <- read_yaml(.config)

set.seed(config$seed)

out <- fit |>
  components() |>
  filter(component == "hyper") |>
  select(term, level, .fitted)

write_rds(out, file = .out)
