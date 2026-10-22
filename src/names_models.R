
suppressPackageStartupMessages({
  library(command)
  library(readr)
})

cmd_assign( .out = "out/names_models.rds")

out <- c("Baseline model" = "0",
         "First expanded model" = "1",
         "Second expanded model" = "2")

write_rds(out, file = .out)
