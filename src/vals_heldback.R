
suppressPackageStartupMessages({
  library(command)
  library(dplyr)
  library(readr)
  library(rvec)
  library(yaml)
})

cmd_assign(.heldback = "out/heldback_naive_2016-2019.rds",
           .config = "config.yaml",
           .out = "out/vals_heldback_naive_2016-2019.rds")

heldback <- read_rds(.heldback)
config <- read_yaml(.config)

width <- c(config$heldback_width_inner,
           config$heldback_width_outer)

out <- heldback |>
  mutate(draws_ci(rate_pred, width = width)) |>
  mutate(is_in_inner = (rate_pred.lower1 <= rate_true & rate_true <= rate_pred.upper1),
         is_in_outer = (rate_pred.lower <= rate_true & rate_true <= rate_pred.upper),
         width_inner = rate_pred.upper1 - rate_pred.lower1,
         width_outer = rate_pred.upper - rate_pred.lower,
         error = rate_pred.mid - rate_true) |>
  summarise(pc_in_inner = 100 * mean(is_in_inner),
            pc_in_outer = 100 * mean(is_in_outer),
            median_width_inner = median(width_inner),
            median_width_outer = median(width_outer),
            rmse = sqrt(mean(error^2)))

write_rds(out, file = .out)
