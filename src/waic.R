
suppressPackageStartupMessages({
  library(command)
  library(dplyr)
  library(readr)
  library(rvec)
  library(yaml)
})

cmd_assign(.aug = "out/aug_0.rds",
           .config = "config.yaml",
           .out = "out/waic_0.rds")

aug <- read_rds(.aug)
config <- read_yaml(.config)

set.seed(config$seed)

llpd <- function(log_dens) {
  log_dens_max <- draws_max(log_dens)
  log_dens_scaled <- log_dens - log_dens_max
  dens_scaled <- exp(log_dens_scaled)
  mean_dens_scaled <- draws_mean(dens_scaled)
  log_mean_dens_scaled <- log(mean_dens_scaled)
  log_mean_dens <- log_mean_dens_scaled + log_dens_max
  sum(log_mean_dens)
}

pwaic <- function(log_dens) {
  sum(draws_var(log_dens))
}

waic <- function(log_dens) {
  llpd <- llpd(log_dens)
  pwaic <- pwaic(log_dens)
  -2 * (llpd - pwaic)
}

out <- aug |>
  mutate(log_dens = dpois_rvec(
           x = mig,
           lambda = .fitted * exposure,
           log = TRUE
         )
         ) |>
  pull(log_dens) |>
  waic()

write_rds(out, file = .out)
