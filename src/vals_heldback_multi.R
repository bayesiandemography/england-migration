suppressPackageStartupMessages({
  library(command)
  library(dplyr)
  library(forcats)
  library(purrr)
  library(readr)
  library(rlang)
  library(tidyr)
  library(yaml)
})

cmd_assign_dots(.dots = c("out/vals_heldback_naive_2017-2019.rds",
                          "out/vals_heldback_0_2017-2019.rds",
                          "out/vals_heldback_1_2017-2019.rds",
                          "out/vals_heldback_2_2017-2019.rds",
                          "out/vals_heldback_naive_2024.rds",
                          "out/vals_heldback_0_2024.rds",
                          "out/vals_heldback_1_2024.rds",
                          "out/vals_heldback_2_2024.rds",
                          "config.yaml",
                          "out/vals_heldback_multi_main.rds"))

n <- length(.dots)
.vals <- .dots[1:(n-2)]
.config <- .dots[n-1]
.out <- .dots[n]

config <- read_yaml(.config)
width_inner <- config$heldback_width_inner
width_outer <- config$heldback_width_outer

names <- .vals |>
  sub("out/vals_heldback_(.*)\\.rds", "\\1", x = _)

pc_inner <- 100 * config$heldback_width_inner
pc_outer <- 100 * config$heldback_width_outer

out <- .vals |>
  map(read_rds) |>
  set_names(names) |>
  bind_rows(.id = "name") |>
  pivot_longer(cols = matches("^pc_in|^median|^rmse"),
               names_to = "statistic") |>
  mutate(statistic = factor(statistic,
                            levels = c("pc_in_inner",
                                       "pc_in_outer",
                                       "median_width_inner",
                                       "median_width_outer",
                                       "rmse"),
                            labels = c(sprintf("Percent in %2.0f%% CI", pc_inner),
                                       sprintf("Percent in %2.0f%% CI", pc_outer),
                                       sprintf("Median width %2.0f%% CI", pc_inner),
                                       sprintf("Median width %2.0f%% CI", pc_outer),
                                       "RMSE"))) |>
  separate_wider_delim(name, delim = "_", names = c("model", "period")) |>
  mutate(model = if_else(model == "naive", "Main effects", paste("Model", model)),
         model = fct_inorder(model),
         model = fct_rev(model))

write_rds(out, file = .out)
