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

cmd_assign_collect(.files = c("out/vals_heldback_naive_2020-2024.rds",
                              "out/vals_heldback_0_2020-2024.rds",
                              "out/vals_heldback_1_2020-2024.rds",
                              "out/vals_heldback_2_2020-2024.rds",
                              "out/vals_heldback_naive_2017-2019.rds",
                              "out/vals_heldback_0_2017-2019.rds",
                              "out/vals_heldback_1_2017-2019.rds",
                              "out/vals_heldback_2_2017-2019.rds",
                              "out/vals_heldback_naive_2022-2024.rds",
                              "out/vals_heldback_0_2022-2024.rds",
                              "out/vals_heldback_1_2022-2024.rds",
                              "out/vals_heldback_2_2022-2024.rds",
                              "out/names_models.rds",
                              "config.yaml",
                              "out/vals_heldback_multi_main.rds"))

n <- length(.files)
.vals <- .files[1:(n-3)]
.names_models <- .files[n-2]
.config <- .files[n-1]
.out <- .files[n]

config <- read_yaml(.config)
width_inner <- config$heldback_width_inner
width_outer <- config$heldback_width_outer

names_models <- read_rds(.names_models)
names_models <- c(
  list("Main effects" = "naive"),
  names_models
)

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
  mutate(model = fct_recode(model, !!!names_models),
         model = fct_inorder(model),
         model = fct_rev(model)) |>
  mutate(period = fct_inorder(period))

write_rds(out, file = .out)
