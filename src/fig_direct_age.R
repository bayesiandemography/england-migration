
suppressPackageStartupMessages({
  library(agetime)
  library(command)
  library(dplyr)
  library(ggplot2)
  library(readr)
})

cmd_assign(.data = "out/data.rds",
           year = 2016,
           .out = "fig_direct_age_2016.pdf")

data <- read_rds(.data)

regions_show <- c("London",
                  "East of England",         
                  "South East",
                  "Yorkshire and The Humber")

vals <- data |>
  filter(time == year) |>
  filter(reg_orig %in% regions_show,
         reg_dest %in% regions_show) |>
  mutate(direct = mig / exposure)

p <- ggplot(vals, aes(x = age_mid(age), y = direct, color = sex)) +
  facet_grid(vars(reg_orig), vars(reg_dest), switch = "y") +
  geom_line(linewidth = 0.3) +
  xlab("Age") +
  ylab("Rate")  +
  scale_color_manual(values = c(Female = "darkorange", Male = "darkblue")) +
  scale_x_continuous(breaks = seq(0, 90, by = 20)) + 
  theme(legend.position = "bottom",
        legend.title = element_blank(),
        strip.text = element_text(size = 7))
  
pdf(file = .out,
    width = 6,
    height = 6.5)
print(p)
dev.off()

