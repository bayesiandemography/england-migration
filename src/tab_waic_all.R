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

cmd_assign_dots(.dots = c("out/waic_0.rds",
                          "out/waic_1.rds",
                          "out/waic_2.rds",
                          "out/tab_waic_all.tex"))

n <- length(.dots)
.waic <- .dots[1:(n-1)]
.out <- .dots[n]

out <- .waic |>
  map(read_rds) |>
  set_names(paste("Model", seq_along(.waic))) |>
  bind_rows(.id = "model") |>
  xtable(caption = "WAIC",
         label = "tab:waic",
         align = "lccc",
         digits = 0)

print(out,
      file = .out,
      include.rownames = FALSE,
      caption.placement = "top")
