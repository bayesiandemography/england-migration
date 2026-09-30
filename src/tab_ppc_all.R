suppressPackageStartupMessages({
  library(command)
  library(dplyr)
  library(purrr)
  library(readr)
  library(rlang)
  library(tidyr)
  library(xtable)
  library(yaml)
})

cmd_assign_dots(.dots = c("out/ppc0.rds",
                          "out/ppc1.rds",
                          "out/ppc2.rds",
                          "config.yaml",
                          "out/tab_ppc_all.tex"))

n <- length(.dots)
.ppc <- .dots[1:(n-2)]
.config <- .dots[n-1]
.out <- .dots[n]

config <- read_yaml(.config)

out <- .ppc |>
  map(read_rds) |>
  set_names(paste("Model", seq_along(.ppc))) |>
  bind_rows(.id = "model") |>
  pivot_wider(names_from = model,
              values_from = pc_pval_outside_interval) |>
  xtable(caption = paste0("Percent of statistics from replicate data tests ",
                          "outside the ", config$ppc_lower, "-",
                          config$ppc_upper, " range"),
         label = "tab:ppc",
         align = "llrrr",
         digits = 1)

print(out,
      file = .out,
      include.rownames = FALSE,
      caption.placement = "top")
