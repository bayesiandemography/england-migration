
suppressPackageStartupMessages({
  library(command)
  library(bage)
  library(dplyr)
  library(purrr)
  library(readr)
  library(yaml)
})

cmd_assign(.models = "out/models.rds",
           .config = "config.yaml",
           .out = "out/fit.rds")

models <- read_rds(.models)
config <- read_yaml(.config)

set.seed(config$seed)

fit_mod <- function(unfitted) {
  print(unfitted)
  fitted <- fit(unfitted, method = config$fit_method)
  print(fitted)
  fitted
}

out <- models |>
  mutate(fit = map(model, fit_mod))

write_rds(out, file = .out)
