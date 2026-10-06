
suppressPackageStartupMessages({
  library(bage)
  library(command)
  library(dplyr)
  library(purrr)
  library(readr)
  library(yaml)
})

cmd_assign(.data = "out/data.rds",
           .config = "config.yaml",
           version = "naive",
           heldback_forecast = "2017-2019",
           .out = "out/heldback_naive_2016-2019.rds")

data <- read_rds(.data)
config <- read_yaml(.config)

set.seed(config$random_seed)

fnaive <- mig ~ reg_orig + reg_dest + age + sex + time

f0 <- mig ~ (reg_orig + reg_dest + age + time)^2 + age * sex

f1 <- update(f0, . ~ . + reg_orig:reg_dest:age)

f2 <- update(f1, . ~ . +  reg_orig:reg_dest:age:sex + reg_orig:reg_dest:age:time)

nm <- paste0("f", version)
formula <- get(nm)

time_min <- data |>
  pull(time) |>
  min()

forecast_times <- heldback_forecast |>
  strsplit(split = "-") |>
  pluck(1) |>
  as.integer()

times_fit <- seq.int(
  from = time_min,
  to = forecast_times[[1]] - 1L
)
times_forecast <- seq.int(
  from = forecast_times[[1L]],
  to = forecast_times[[2L]]
)

data_fit <- data |>
  filter(time %in% times_fit)

data_forecast <- data |>
  filter(time %in% times_forecast)

vals_true <- data_forecast |>
  mutate(rate_true = mig / exposure) |>
  select(-mig, -exposure)

newdata <- data_forecast |>
  mutate(mig = NA)

mod <- mod_pois(formula = formula,
                data = data_fit,
                exposure = exposure) |>
  set_prior(age ~ RW2()) |>
  set_prior(time ~ Lin_AR())

fit <- mod |>
  fit(method = config$fit_method)

print(fit)

forecast <- fit |>
  forecast(newdata = newdata)

vals_forecast <- forecast |>
  mutate(rate_pred = mig / exposure) |>
  select(-mig, -.observed, -.fitted, -.expected)
  
out <- inner_join(vals_true,
                  vals_forecast,
                  by = c("reg_orig", "reg_dest", "age", "sex", "time"))
  
write_rds(out, file = .out)
