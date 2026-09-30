
suppressPackageStartupMessages({
  library(command)
  library(dplyr)
  library(readr)
  library(rvec)
  library(tidyr)
  library(yaml)
})

cmd_assign(.replicate = "out/replicate0.rds",
           .config = "config.yaml",
           .out = "out/ppc0.rds")

replicate <- read_rds(.replicate)
config <- read_yaml(.config)

out <- replicate |>
  summarise(rep.Minimum = min(.replicate),
            rep.Maximum = max(.replicate),
            rep.Mean = mean(.replicate),
            rep.SD = sd(.replicate),
            obs.Minimum = min(.observed),
            obs.Maximum = max(.observed),
            obs.Mean = mean(.observed),
            obs.SD = sd(.observed),
            .by = c(reg_orig, reg_dest, sex, time)) |>
  pivot_longer(cols = matches("^rep|^obs"),
               names_to = c(".value", "Statistic"),
               names_sep = "\\.") |>
  mutate(pval = prob(rep > obs),
         is_pval_lower = pval < config$ppc_lower,
         is_pval_higher = pval > config$ppc_upper,
         is_pval_outside_interval = is_pval_lower | is_pval_higher) |>
  summarise(pc_pval_outside_interval = 100 * mean(is_pval_outside_interval),
            .by = Statistic)
  
write_rds(out, file = .out)
