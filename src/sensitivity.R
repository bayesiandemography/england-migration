
suppressPackageStartupMessages({
  library(command)
  library(bage)
  library(readr)
})

cmd_assign(.data = "out/data.rds",
           val_s = 0.1,
           .out = "out/sensitivity_01.rds")

data <- read_rds(.data)

f <- mig ~ (reg_orig + reg_dest + age + time)^2 + age * sex +
  reg_orig:reg_dest:age +
  reg_orig:reg_dest:age:sex + reg_orig:reg_dest:age:time

mod <- mod_pois(formula = f,
                data = data,
                exposure = exposure) |>
  set_prior(reg_orig ~ N(s = val_s)) |>
  set_prior(reg_dest ~ N(s = val_s)) |>
  set_prior(age ~ RW2(s = val_s)) |>
  set_prior(time ~ Lin_AR(s = val_s)) |>
  set_prior(sex ~ NFix(sd = val_s)) |>
  set_prior(reg_orig:reg_dest ~ N(s = val_s)) |>
  set_prior(reg_orig:age ~ RW(s = val_s)) |>
  set_prior(reg_orig:time ~ RW(s = val_s)) |>
  set_prior(reg_dest:age ~ RW(s = val_s)) |>
  set_prior(reg_dest:time ~ RW(s = val_s)) |>
  set_prior(age:time ~ RW(s = val_s)) |>
  set_prior(age:sex ~ RW(s = val_s)) |>
  set_prior(reg_orig:reg_dest:age ~ RW(s = val_s)) |>
  set_prior(reg_orig:reg_dest:age:sex ~ RW(s = val_s)) |>
  set_prior(reg_orig:reg_dest:age:time ~ RW(s = val_s))

out <- mod |>
  fit()

print(out)

write_rds(out, file = .out)
