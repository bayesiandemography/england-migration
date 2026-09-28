#install.packages("rvec")

library(bage)
library(dplyr, warn.conflicts = FALSE)
library(ggplot2)
library(poputils)
library(command)

setwd("D:/research/Data Analytics and Topology")

cmd_assign(.mod = "out/mod.rds")

mod <- readRDS(.mod)

set.seed(0)

data <- mod |>
  replicate_data(n = 9) |>
  filter(reg_dest!=reg_orig) |> # reg_dest cannot be equal to reg_orig
  group_by(.replicate, age, sex, time) |>
  summarise(
    mig = sum(mig, na.rm = TRUE),
    popn_orig = sum(popn_orig, na.rm = TRUE),
    .groups = "drop"
  ) |> 
  mutate(direct = mig / popn_orig)

for (time.cur in 2012:2024) {
  data.cur <- data |>
    filter(time == time.cur)
  
  p <- ggplot(data.cur, aes(x = age_mid(age), y = direct)) +
    facet_grid(vars(sex), vars(.replicate)) +
    geom_point(size = 0.5) +
    xlab("Age") +
    ylab("") +
    theme(legend.position = "top",
          legend.title = element_blank(),
          text = element_text(size = 9))
  
  graphics.off()
  pdf(file = paste0("out/fig_diag_replicate_agetime_",time.cur,".pdf"),
      w = 8,
      h = 8)
  plot(p)
  dev.off()
}

