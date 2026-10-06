
suppressPackageStartupMessages({
  library(agetime)
  library(command)
  library(dplyr)
  library(ggplot2)
  library(readr)
  library(yaml)
})

cmd_assign(.vals = "out/vals_forecast.rds",
           orig = "London",
           dest = "South East",
           .out = "out/fig_forecast_london_se.rds")

vals <- read_rds(.vals)

times_all <- vals |>
  pull(time) |>
  unique()

times_plot <- seq(from = max(times_all),
                  to = min(times_all),
                  by = -4) |>
  sort()

data <- vals |>
  filter(reg_orig == orig) |>
  filter(reg_dest == dest) |>
  filter(time %in% times_plot)

p <- ggplot(data, aes(x = age_mid(age))) +
  facet_grid(vars(sex), vars(time)) +
  geom_ribbon(aes(ymin = .fitted.lower,
                  ymax = .fitted.upper),
              fill = "lightblue") +
  geom_line(aes(y = .fitted.mid),
            color = "darkblue",
            linewidth = 0.25) +
  geom_point(aes(y = .observed),
             na.rm = TRUE,
             color = "red",
             size = 0.3) +
  xlab("Age") +
  ylab("Migration Rate")
      
pdf(file = .out,
    width = 6,
    height = 4.5)
print(p)
dev.off()
