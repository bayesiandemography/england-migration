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

for (sex.cur in c("Female","Male"))
  for (time.cur in 2012:2024) {
    data.cur <- data |>
      filter(time == time.cur,
             sex == sex.cur) |>
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
    
    p <- ggplot(data.cur, aes(x = age_mid(age))) +
      facet_grid(vars(reg_orig), vars(reg_dest), switch = "y") +
      geom_line(aes(y = direct),
                color = "red",
                size = 0.1) +
      xlab("Age") +
      ylab("Moves per year")
    
    
    graphics.off()
    if (sex.cur == "Female")
      file.name = paste0("out/fig_orig_dest_direct_female_",time.cur,".pdf")
    else file.name = paste0("out/fig_orig_dest_direct_male_",time.cur,".pdf")
    pdf(file = file.name,
        width = 6,
        height = 6)
    plot(p)
    dev.off()
  }


