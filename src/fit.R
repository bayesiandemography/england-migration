
suppressPackageStartupMessages({
  library(command)
  library(bage)
  library(dplyr)
  library(readr)
  library(yaml)
})

cmd_assign(.mod = "out/mod0.rds",
           .config = "config.yaml",
           .out = "out/fit0.rds")

mod <- read_rds(.mod)
config <- read_yaml(.config)

set.seed(config$seed)

out <- mod |>
  fit(method = config$fit_method)

print(out)

write_rds(out, file = .out)
