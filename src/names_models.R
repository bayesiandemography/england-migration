
suppressPackageStartupMessages({
  library(command)
  library(readr)
})

cmd_assign( .out = "out/names_models.rds")

out <- c("Initial" = "0",
         "First expanded" = "1",
         "Second expanded" = "2")

write_rds(out, file = .out)
