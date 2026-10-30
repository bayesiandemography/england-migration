suppressPackageStartupMessages({
  library(command)
  library(dplyr)
  library(forcats)
  library(purrr)
  library(readr)
  library(rlang)
  library(tibble)
  library(xtable)
})

cmd_assign_collect(.files = c("out/waic_0.rds",
                              "out/waic_1.rds",
                              "out/waic_2.rds",
                              "out/names_models.rds",
                              "out/tab_waic_all.tex"))

n <- length(.files)
.waic <- .files[1:(n-2)]
.names_models <- .files[n-1]
.out <- .files[n]

names_models <- read_rds(.names_models)
names_models <- c(
  list("Main effects" = "naive"),
  names_models
)

names <- .waic |>
  sub("out/waic_(.*)\\.rds", "\\1", x = _) |>
  fct_recode(!!!names_models)

out <- .waic |>
  map_dbl(read_rds) |>
  set_names(names) |>
  enframe() |>
  set_names(c("Model", "Value")) |>
  xtable(caption = "WAIC",
         label = "tab:waic",
         align = "llc",
         digits = 0)

print(out,
      file = .out,
      include.rownames = FALSE,
      caption.placement = "top")
