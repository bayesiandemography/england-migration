suppressPackageStartupMessages({
  library(command)
  library(dplyr)
  library(purrr)
  library(readr)
  library(rlang)
  library(rvec)
  library(tidyr)
  library(xtable)
  library(yaml)
})

cmd_assign_dots(.dots = c("out/hyper_0.rds",
                          "out/hyper_1.rds",
                          "out/hyper_2.rds",
                          "config.yaml",
                          "out/tab_hyper_all.tex"))

n <- length(.dots)
.hyper <- .dots[1:(n-2)]
.config <- .dots[n-1]
.out <- .dots[n]

config <- read_yaml(.config)

names <- .hyper |>
  sub("out/hyper_(.*)\\.rds", "Model \\1", x = _)

out <- .hyper |>
  map(read_rds) |>
  set_names(names) |>
  bind_rows(.id = "model") |>
  mutate(draws_ci(.fitted, width = config$heldback_width_outer)) |>
  mutate(value = sprintf("%s, (%s, %s)",
                         .fitted.mid = formatC(.fitted.mid, digits = 2, format = "fg"),
                         .fitted.lower = formatC(.fitted.lower, digits = 2, format = "fg"),
                         .fitted.upper = formatC(.fitted.upper, digits = 2, format = "fg"))) |>
  select(model, term, level, value) |>
  pivot_wider(names_from = model,
              values_from = value) |>
  mutate(level = case_when(level == "sd" ~ "$\\sigma$",
                           level == "coef1" ~ "$\\phi_1$",
                           level == "coef2" ~ "$\\phi_2$",
                           level == "slope" ~ "$\\eta$")) |>
  mutate(term = sub("reg_orig", "Origin", term),
         term = sub("reg_dest", "Destination", term),
         term = sub("age", "Age", term),
         term = sub("sex", "Sex", term),
         term = sub("sex", "Sex", term),
         term = sub("time", "Time", term),
         term = gsub(":", "-", term)) |>
  rename(Term = term,
         "Hyper-parameter" = level) |>
  xtable(caption = "Estimates for hyper-parameters",
         label = "tab:hyper") |>
  print(file = .out,
        sanitize.colnames.function = identity,
        sanitize.text.function = identity,
        include.rownames = FALSE,
        caption.placement = "top")
