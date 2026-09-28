
suppressPackageStartupMessages({
  library(command)
  library(dplyr)
  library(forcats)
  library(readr)
})

command::cmd_assign(.data = "data/england-region-migration-2026-09-25.zip",
                    .out = "out/data.rds")

data <- read_csv(.data, col_types = "cccciid")

region_levels <- data |>
  pull(reg_orig) |>
  unique()

out <- data |>
  mutate(reg_orig = factor(reg_orig, levels = region_levels),
         reg_dest = factor(reg_dest, levels = region_levels))

write_rds(out, file = .out)
