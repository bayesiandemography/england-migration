
suppressPackageStartupMessages({
  library(agetime)
  library(command)
  library(dplyr)
  library(ggplot2)
  library(readr)
})

cmd_assign(.data = "out/data.rds",
           .out = "fig_direct_time.pdf")

data <- read_rds(.data)

regions_show <- c("London",
                  "East of England",         
                  "South East",
                  "Yorkshire and The Humber")

vals <- data |>
  filter(region %in% regions_show) |>
  summarise(mig = sum(mig),
            exposure = sum(exposure),
            .by = c(reg_orig, reg_dest, sex, time)) |>
  mutate(direct = mig / exposure)

p <- ggplot(vals, aes(x = time, y = direct, color = sex)) +
  facet_grid(vars(reg_orig), vars(reg_dest), switch = "y") +
  geom_line(size = 0.3) +
  xlab("Year") +
  ylab("Rate")  +
  scale_color_manual(values = c("Female" = "darkorange", "Male" = "darkblue")) +
  scale_x_continuous(breaks = seq(2014, 2024, by = 4)) + 
  theme(legend.position = "bottom",
        legend.title = element_blank(),
        strip.text = element_text(size = 7))

pdf(file = .out,
    width = 6,
    height = 6.5)
print(p)
dev.off()
