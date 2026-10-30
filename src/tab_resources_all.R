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

cmd_assign_collect(.files = c("out/resources_0.rds",
                              "out/resources_1.rds",
                              "out/resources_2.rds",
                              "out/names_models.rds",
                              "out/tab_resources_all.tex"))

n <- length(.files)
.resources <- .files[1:(n-2)]
.names_models <- .files[n-1]
.out <- .files[n]

names_models <- read_rds(.names_models)

names <- .resources |>
  sub("out/resources_(.*)\\.rds", "\\1", x = _) |>
  fct_recode(!!!names_models)

out <- .resources |>
  map(read_rds) |>
  set_names(names) |>
  bind_rows(.id = "Model") |>
  xtable(caption = "Resources used for model fitting",
         label = "tab:resources",
         align = "llcc",
         digits = c(0, 0, 0, 1))

print(out,
      file = .out,
      include.rownames = FALSE,
      caption.placement = "top")
