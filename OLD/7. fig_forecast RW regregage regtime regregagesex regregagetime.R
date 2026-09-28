library(bage, quietly = TRUE)
library(dplyr, quietly = TRUE)
library(poputils)
library(ggplot2)
library(command)

setwd("D:/BayesianDemography/Data Analytics and Topology")

cmd_assign(.aug = "out/aug RW regregage regtime regregagesex regregagetime.rds")

reg.names <- c("London", "East of England",         
               "North East", "North West", 
               "South East", "South West", 
               "East Midlands", "West Midlands",           
               "Yorkshire and The Humber")
reg.labels <- c("London",  "EE",         
                "NE", "NW", 
                "SE", "SW", 
                "EM","WM",           
                "YH")

aug <- readRDS(.aug)

times <- seq(2014, 2030, 4)

for (i.reg.orig in 1:length(reg.names))
  for (i.reg.dest in 1:length(reg.names)) {
    reg.orig.cur <- reg.names[i.reg.orig]
    reg.dest.cur <- reg.names[i.reg.dest]
   
    if (reg.orig.cur != reg.dest.cur) {
      data <- aug |>
        filter(reg_orig == reg.orig.cur) |>
        filter(reg_dest == reg.dest.cur) |>
        filter(time %in% times)
      
      p <- ggplot(data, aes(x = age_mid(age))) +
        facet_grid(vars(sex), vars(time)) +
        geom_ribbon(aes(ymin = .fitted.lower,
                        ymax = .fitted.upper),
                    fill = "lightblue") +
        geom_line(aes(y = .fitted.mid),
                  color = "darkblue",
                  linewidth = 0.25) +
        geom_point(aes(y = .observed),
                   color = "red",
                   size = 0.1) +
        xlab("Age") +
        ylab("Migration Rate") +
        scale_x_continuous(breaks = seq(0, 90, by = 20)) + 
        
      
      graphics.off()
      pdf(file = paste0("out/model RW regregage regtime regregagesex regregagetime/fig_forecast_", reg.labels[i.reg.orig], "_",
                        reg.labels[i.reg.dest], ".pdf"),
          width = 6,
          height = 4.5)
      plot(p)
      dev.off()
      
    }
  }
