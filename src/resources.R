
suppressPackageStartupMessages({
  library(command)
  library(bage)
  library(dplyr)
  library(ps)
  library(readr)
  library(yaml)
})

cmd_assign(.mod = "out/mod_0.rds",
           .config = "config.yaml",
           .out = "out/resources_0.rds")

mod <- read_rds(.mod)
config <- read_yaml(.config)

set.seed(config$seed)

timing <- system.time(
  out <- mod |>
    fit(method = config$fit_method)
)

GiB <- 1024^3

out <- tibble(
  "Elapsed time (seconds)" = timing["elapsed"],
  "Peak memory usage (GiB)" = ps_memory_full_info()[["maxrss"]] / GiB
)

write_rds(out, file = .out)
