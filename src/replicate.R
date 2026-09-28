
suppressPackageStartupMessages({
  library(command)
  library(dplyr)
  library(purrr)
  library(readr)
  library(rvec)
})

cmd_assign(.aug = "out/aug.rds",
           .disp = "out/disp.rds",
           .out = "out/replicate.rds")

aug <- read_rds(.aug)
disp <- read_rds(.disp)

make_y_rep <- function(.x, .y) {
  n <- nrow(.x)
  rnbinom_rvec(
    n = nrow(.x),
    size = 1 / .y,
    mu = .x$.expected * .x$exposure
  )
}

out <- aug |>
  inner_join(disp, by = "name") |>
  mutate(.expected = map2(aug, disp, make_y_rep)) |>
  mutate(aug = map(aug, ~select(.x, -.fitted, -.expected)))
  
write_rds(out, file = .out)
