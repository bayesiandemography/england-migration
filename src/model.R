
suppressPackageStartupMessages({
  library(command)
  library(bage)
  library(dplyr)
  library(readr)
})

cmd_assign(.data = "out/data.rds",
           .out = "out/model.rds")

data <- read_rds(.data)

f0 <- mig ~ (reg_orig + reg_dest + age + time)^2 + age * sex

f1 <- update(f0, . ~ . + reg_orig:reg_dest:age)

f2 <- update(f1, . ~ . +  reg_orig:reg_dest:age:sex + reg_orig:reg_dest:age:time)
  
mod0 <- mod_pois(formula = f0,
                 data = data,
                 exposure = exposure) |>
  set_prior(age ~ RW2()) |>
  set_prior(time ~ Lin_AR())

mod1 <- mod_pois(formula = f1,
                 data = data,
                 exposure = exposure) |>
  set_prior(age ~ RW2()) |>
  set_prior(time ~ Lin_AR())

mod2 <- mod_pois(formula = f2,
                 data = data,
                 exposure = exposure) |>
  set_prior(age ~ RW2()) |>
  set_prior(time ~ Lin_AR())

out <- tibble(
  name = c("mod0", "mod1", "mod2"),
  model = list(mod0, mod1, mod2)
)

write_rds(out, file = .out)
