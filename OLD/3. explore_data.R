library(bage)
library(rvec, warn.conflicts = FALSE)
library(dplyr, warn.conflicts = FALSE)
library(poputils)
library(ggplot2)
library(command)

setwd("D:/research/Data Analytics and Topology")

cmd_assign(.data = "out/data.rds")

data <- readRDS(.data) |> 
  filter(reg_dest!=reg_orig) |> # reg_dest cannot be equal to reg_orig
  group_by(age, sex, time) |>
  summarise(
    mig = sum(mig, na.rm = TRUE),
    popn_orig = sum(popn_orig, na.rm = TRUE),
    .groups = "drop"
  ) |> 
  mutate(direct = mig / popn_orig)

times <- 2012:2024
sexes <- c("Female", "Male")

direct.all <- c(data$age[data$time==2012 & data$sex=="Female"])

for (time in times)
  for (sex in sexes) {
    direct.all <- cbind(direct.all,
                        data$direct[data$time==time & data$sex==sex])
  }


table(apply(direct.all[,-1], 2, which.max))
#12 (age "19")
#26 
table(apply(direct.all[,-1], 2, function(x) order(x, decreasing=TRUE)[2]))
## 比较散乱
#14 (age "20") 16 (age "22") 
#1 25
