
suppressPackageStartupMessages({
  library(command)
  library(dplyr)
  library(ggplot2)
  library(readr)
})

cmd_assign(.vals = "out/vals_heldback_all.rds",
           .out = "out/fig_heldback_all.rds")

vals <- read_rds(.vals)

p <- ggplot(vals, aes(x = time, y = value)) +
  facet_grid(vars(statistic), vars(model), scale = "free_y") +
  geom_line() +
  geom_point() +
  xlab("Year") +
  ylab("")
      
pdf(file = .out,
    width = 6,
    height = 6)
print(p)
dev.off()
