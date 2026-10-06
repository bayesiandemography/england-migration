
suppressPackageStartupMessages({
  library(command)
  library(bage)
  library(dplyr)
  library(readr)
  library(yaml)
})

cmd_assign(.fit = "out/fit_0.rds",
           .config = "config.yaml",
           .out = "out/disp0.rds")

fit <- read_rds(.fit)
config <- read_yaml(.config)

set.seed(config$seed)

out <- fit |>
  dispersion()

write_rds(out, file = .out)
