
suppressPackageStartupMessages({
  library(command)
  library(bage)
  library(dplyr)
  library(readr)
})

cmd_assign(.data = "out/data.rds",
           version = 0,
           .out = "out/mod_0.rds")

data <- read_rds(.data)


f0 <- mig ~ (reg_orig + reg_dest + age + time)^2 + age * sex

f1 <- update(f0, . ~ . + reg_orig:reg_dest:age)

f2 <- update(f1, . ~ . +  reg_orig:reg_dest:age:sex + reg_orig:reg_dest:age:time)

nm <- paste0("f", version)
formula <- get(nm)

out <- mod_pois(formula = formula,
                data = data,
                exposure = exposure) |>
  set_prior(age ~ RW2()) |>
  set_prior(time ~ Lin_AR())


write_rds(out, file = .out)
