
suppressPackageStartupMessages({
  library(agetime)
  library(command)
  library(dplyr)
  library(forcats)
  library(ggplot2)
  library(readr)
  library(yaml)
})

cmd_assign(.vals = "out/vals_forecast.rds",
           sex = "Female",
           .out = "out/fig_forecast_female_2030.rds")

time <- 2030

vals <- read_rds(.vals)

reg_recode <- list("Yorkshire Humber" = "Yorkshire and The Humber")

data <- vals |>
  filter(sex == !!sex) |>
  filter(time == !!time) |>
  mutate(reg_orig = fct_recode(reg_orig, !!!reg_recode),
         reg_dest = fct_recode(reg_dest, !!!reg_recode))

p <- ggplot(data, aes(x = age_mid(age))) +
  facet_grid(vars(reg_orig), vars(reg_dest), switch = "y") +
  geom_ribbon(aes(ymin = .fitted.lower,
                  ymax = .fitted.upper),
              fill = "lightblue") +
  geom_line(aes(y = .fitted.mid),
            color = "darkblue",
            linewidth = 0.25) +
  geom_point(aes(y = .observed),
             na.rm = TRUE,
             color = "red",
             alpha = 0.5,
             size = 0.2) +
  xlab("Age") +
  ylab("Migration Rate") +
  theme_bw() +
  theme(text = element_text(size = 7))
      
pdf(file = .out,
    width = 6,
    height = 6)
print(p)
dev.off()
