
suppressPackageStartupMessages({
  library(command)
  library(bage)
  library(dplyr)
  library(purrr)
  library(readr)
  library(tidyr)
  library(yaml)
})

cmd_assign(.fit = "out/fit.rds",
           .config = "config.yaml",
           .out = "out/aug.rds")

fit <- read_rds(.fit)
config <- read_yaml(.config)

set.seed(config$seed)

out <- fit |>
  mutate(aug = map(fit, augment)) |>
  select(name, aug)

write_rds(out, file = .out)
