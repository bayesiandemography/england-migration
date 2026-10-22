suppressPackageStartupMessages({
  library(command)
  library(dplyr)
  library(forcats)
  library(purrr)
  library(readr)
  library(rlang)
  library(tidyr)
  library(xtable)
  library(yaml)
})

cmd_assign_collect(.files = c("out/ppc_0.rds",
                              "out/ppc_1.rds",
                              "out/ppc_2.rds",
                              "config.yaml",
                              "out/names_models.rds",
                              "out/tab_ppc_all.tex"))

n <- length(.files)
.ppc <- .files[1:(n-3)]
.config <- .files[n-2]
.names_models <- .files[n-1]
.out <- .files[n]

config <- read_yaml(.config)
names_models <- read_rds(.names_models)

names <- .ppc |>
  sub("out/ppc_(.*)\\.rds", "\\1", x = _) |>
  fct_recode(!!!names_models)
  
out <- .ppc |>
  map(read_rds) |>
  set_names(names) |>
  bind_rows(.id = "Model") |>
  pivot_wider(names_from = statistic,
              values_from = pc_pval_outside_interval) |>
  xtable(caption = paste0("Percent of statistics from replicate data tests ",
                          "outside the ", config$ppc_lower, "-",
                          config$ppc_upper, " range"),
         label = "tab:ppc",
         align = "llrrrr",
         digits = 1)

print(out,
      file = .out,
      include.rownames = FALSE,
      caption.placement = "top")
