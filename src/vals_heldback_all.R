suppressPackageStartupMessages({
  library(command)
  library(dplyr)
  library(purrr)
  library(readr)
  library(rlang)
  library(tidyr)
  library(yaml)
})

cmd_assign_dots(.dots = c("out/vals_heldback_naive.rds",
                          "out/vals_heldback_0.rds",
                          "out/vals_heldback_1.rds",
                          "out/vals_heldback_2.rds",
                          "config.yaml",
                          "out/vals_heldback_all.rds"))

n <- length(.dots)
.vals <- .dots[1:(n-2)]
.config <- .dots[n-1]
.out <- .dots[n]

config <- read_yaml(.config)
width_inner <- config$heldback_width_inner
width_outer <- config$heldback_width_outer

out <- .vals |>
  map(read_rds) |>
  set_names(c("Main effects model", paste("Model", seq.int(0, n - 4L)))) |>
  bind_rows(.id = "model") |>
  pivot_longer(cols = matches("^pc_in|^median|^rmse"),
               names_to = "statistic") |>
  mutate(statistic = factor(statistic,
                            levels = c("pc_in_inner",
                                       "pc_in_outer",
                                       "median_width_inner",
                                       "median_width_outer",
                                       "rmse"),
                            labels = c(sprintf("Percent in %2.0f%% CI",
                                               100 * config$heldback_width_inner),
                                       sprintf("Percent in %2.0f%% CI",
                                               100 * config$heldback_width_outer),
                                       sprintf("Median width %2.0f%% CI",
                                               100 * config$heldback_width_inner),
                                       sprintf("Median width %2.0f%% CI",
                                               100 * config$heldback_width_outer),
                                       "RSME")))

write_rds(out, file = .out)
