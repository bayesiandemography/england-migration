
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
  select(-.fitted) |>
  mutate(y_rep = rnbinom_rvec(
           n = n(),
           size = 1 / disp,
           mu = .expected * exposure
         )
         ) |>
  select(-.expected)
  
write_rds(out, file = .out)
