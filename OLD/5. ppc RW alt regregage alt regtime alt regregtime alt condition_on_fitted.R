#install.packages("rvec")

library(bage)
library(dplyr, warn.conflicts = FALSE)
library(ggplot2)
library(poputils)
library(command)

setwd("D:/BayesianDemography/Data Analytics and Topology")

cmd_assign(.mod = "out/mod RW alt regregage alt regtime alt regregtime alt.rds")

mod <- readRDS(.mod)

set.seed(0)

##### aggregate over reg_orig and reg_dest
data <- mod |>
  replicate_data(n = 1000, condition_on = "fitted") |>
  filter(reg_dest!=reg_orig) |> # reg_dest cannot be equal to reg_orig
  mutate(direct = mig / popn_orig)

summary <- data |>
  group_by(.replicate, reg_orig, reg_dest, sex, time) |>
  summarise(min = min(direct),
            max = max(direct),
            mean = mean(direct),
            sd = sd(direct),
            .groups = "drop"
  )  

result <- summary %>%
  group_by(reg_orig, reg_dest, sex, time) %>%
  summarise(
    original_min = `min`[`.replicate` == "Original"],
    n_greater_min = sum(`min`[`.replicate` != "Original"] > original_min, na.rm = TRUE),
    proportion_min = n_greater_min / 1000,
    original_max = `max`[`.replicate` == "Original"],
    n_greater_max = sum(`max`[`.replicate` != "Original"] > original_max, na.rm = TRUE),
    proportion_max = n_greater_max / 1000,
    original_mean = `mean`[`.replicate` == "Original"],
    n_greater_mean = sum(`mean`[`.replicate` != "Original"] > original_mean, na.rm = TRUE),
    proportion_mean = n_greater_mean / 1000,
    original_sd = `sd`[`.replicate` == "Original"],
    n_greater_sd = sum(`sd`[`.replicate` != "Original"] > original_sd, na.rm = TRUE),
    proportion_sd = n_greater_sd / 1000,
    .groups = "drop"
  )

c((length(which(result$proportion_min<0.05))+length(which(result$proportion_min>0.95)))/1872,
(length(which(result$proportion_max<0.05))+length(which(result$proportion_max>0.95)))/1872,
(length(which(result$proportion_mean<0.05))+length(which(result$proportion_mean>0.95)))/1872,
(length(which(result$proportion_sd<0.05))+length(which(result$proportion_sd>0.95)))/1872)

#0.13621795 0.00267094 0.01816239 0.01014957
