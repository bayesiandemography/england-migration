
suppressPackageStartupMessages({
  library(command)
  library(bage)
  library(readr)
  library(yaml)
})

cmd_assign(.fit = "out/fit0.rds",
           .config = "config.yaml",
           .out = "out/aug0.rds")

fit <- read_rds(.fit)
config <- read_yaml(.config)

set.seed(config$seed)

out <- fit |>
  augment()

write_rds(out, file = .out)
