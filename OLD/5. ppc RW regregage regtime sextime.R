#install.packages("rvec")

library(bage)
library(dplyr, warn.conflicts = FALSE)
library(ggplot2)
library(poputils)
library(command)

setwd("D:/BayesianDemography/Data Analytics and Topology")

cmd_assign(.mod = "out/mod RW regregage regtime sextime.rds")

mod <- readRDS(.mod)

set.seed(0)

##### aggregate over reg_orig and reg_dest
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
  pdf(file = paste0("out/model RW regregage regtime sextime/fig_ppc1_",time.cur,".pdf"),
      w = 8,
      h = 8)
  plot(p)
  dev.off()
}

##### aggregate over age
data <- mod |>
  replicate_data(n = 9) |>
  filter(reg_dest!=reg_orig) |> # reg_dest cannot be equal to reg_orig
  group_by(.replicate, reg_orig, reg_dest, sex, time) |>
  summarise(
    mig = sum(mig, na.rm = TRUE),
    popn_orig = sum(popn_orig, na.rm = TRUE),
    .groups = "drop"
  ) |> 
  mutate(direct = mig / popn_orig) |>
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
                           "YH")))
  
for (reg_orig.cur in c("London",  "EE",         
                       "NE", "NW", 
                       "SE", "SW", 
                       "EM","WM",           
                       "YH")) 
  for (reg_dest.cur in c("London",  "EE",         
                         "NE", "NW", 
                         "SE", "SW", 
                         "EM","WM",           
                         "YH")) {
    if (reg_dest.cur != reg_orig.cur) {
      
      data.cur <- data |>
        filter(reg_orig == reg_orig.cur & reg_dest == reg_dest.cur)
      
      p <- ggplot(data.cur, aes(x = age_mid(time), y = direct)) +
        facet_grid(vars(sex), vars(.replicate)) +
        geom_point(size = 0.5) +
        xlab("Year") +
        ylab("") +
        theme(legend.position = "top",
              legend.title = element_blank(),
              text = element_text(size = 9))
      
      graphics.off()
      pdf(file = paste0("out/model RW regregage regtime sextime/fig_ppc2_",reg_orig.cur,"_",reg_dest.cur,".pdf"),
          w = 8,
          h = 8)
      plot(p)
      dev.off()
      
    }
  }

