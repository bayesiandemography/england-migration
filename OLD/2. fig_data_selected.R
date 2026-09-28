library(bage)
library(rvec, warn.conflicts = FALSE)
library(dplyr, warn.conflicts = FALSE)
library(poputils)
library(ggplot2)
library(command)

setwd("D:/BayesianDemography/Data Analytics and Topology")

cmd_assign(.data = "out/data.rds")

data <- readRDS(.data) |> 
  filter(reg_dest!=reg_orig) |> # reg_dest cannot be equal to reg_orig
  mutate(direct = mig/popn_orig)

for (time.cur in 2012:2024) {
  data.cur <- data |>
    filter(time == time.cur) |>
    mutate(reg_orig = 
             factor(reg_orig,
                    levels = c("London", "East of England",         
                               "North East", "North West", 
                               "South East", "South West", 
                               "East Midlands", "West Midlands",           
                               "Yorkshire and The Humber"),
                    labels = c("London",  "EE",         
                               "NE", "NW", 
                               "SE", "SW", 
                               "EM","WM",           
                               "YH")),
           reg_dest = 
             factor(reg_dest,
                    levels = c("London", "East of England",         
                               "North East", "North West", 
                               "South East", "South West", 
                               "East Midlands", "West Midlands",           
                               "Yorkshire and The Humber"),
                    labels = c("London",  "EE",         
                               "NE", "NW", 
                               "SE", "SW", 
                               "EM","WM",           
                               "YH"))) |>
    filter(reg_orig %in% c("London", "EE",
                           "SE", "YH")) |>
    filter(reg_dest %in% c("London", "EE",
                           "SE", "YH"))
  
  p <- ggplot(data.cur, aes(x = age_mid(age), y = direct, linetype = sex)) +
    facet_grid(vars(reg_orig), vars(reg_dest), switch = "y") +
    geom_line(size = 0.3) +
    xlab("Age") +
    ylab("Direct estimate of migration rate")  +
    scale_linetype_manual(values = c("Female" = "solid", "Male" = "dashed")) +
    scale_x_continuous(breaks = seq(0, 90, by = 20)) + 
    theme(legend.position = "bottom") + 
    theme(legend.title = element_blank())  
  
  graphics.off()
  file.name = paste0("out/fig_orig_dest_direct_selected_",time.cur,".pdf")
  pdf(file = file.name,
      width = 6,
      height = 6)
  plot(p)
  dev.off()
}

data_summary <- data |>
  group_by(reg_orig, reg_dest, sex, time) |>
  summarise(
    mig_total = sum(mig, na.rm = TRUE),
    popn_orig_total = sum(popn_orig, na.rm = TRUE),
    .groups = "drop"
  ) |>
  mutate(direct = mig_total/popn_orig_total) |>
  mutate(reg_orig = 
           factor(reg_orig,
                  levels = c("London", "East of England",         
                             "North East", "North West", 
                             "South East", "South West", 
                             "East Midlands", "West Midlands",           
                             "Yorkshire and The Humber"),
                  labels = c("London",  "EE",         
                             "NE", "NW", 
                             "SE", "SW", 
                             "EM","WM",           
                             "YH")),
         reg_dest = 
           factor(reg_dest,
                  levels = c("London", "East of England",         
                             "North East", "North West", 
                             "South East", "South West", 
                             "East Midlands", "West Midlands",           
                             "Yorkshire and The Humber"),
                  labels = c("London",  "EE",         
                             "NE", "NW", 
                             "SE", "SW", 
                             "EM","WM",           
                             "YH"))) |>
  filter(reg_orig %in% c("London", "EE",
                         "SE", "YH")) |>
  filter(reg_dest %in% c("London", "EE",
                         "SE", "YH"))

p <- ggplot(data_summary, aes(x = time, y = direct, linetype = sex)) +
  facet_grid(vars(reg_orig), vars(reg_dest), switch = "y") +
  geom_line(size = 0.3) +
  xlab("Year") +
  ylab("Direct estimate of migration rate")  +
  scale_linetype_manual(values = c("Female" = "solid", "Male" = "dashed")) +
  scale_x_continuous(breaks = seq(2014, 2024, by = 4)) + 
  theme(legend.position = "bottom") + 
  theme(legend.title = element_blank())

file.name = "out/fig_orig_dest_summary_direct_selected.pdf"
pdf(file = file.name,
    width = 6,
    height = 6)
plot(p)
dev.off()
