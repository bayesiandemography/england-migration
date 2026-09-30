
suppressPackageStartupMessages({
  library(command)
  library(dplyr)
  library(readr)
  library(rvec)
})

cmd_assign(.aug = "out/aug0.rds",
           .disp = "out/disp0.rds",
           .out = "out/replicate0.rds")

aug <- read_rds(.aug)
disp <- read_rds(.disp)

out <- aug |>
  mutate(y_rep = rnbinom_rvec(
           n = n(),
           size = 1 / disp,
           mu = .expected * exposure
         )
         ) |>
  mutate(.replicate = y_rep / exposure) |>
  select(-.fitted, -.expected, -y_rep)
  
write_rds(out, file = .out)
