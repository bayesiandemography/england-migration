suppressPackageStartupMessages({
  library(agetime)
  library(command)
  library(dplyr)
  library(ggplot2)
  library(purrr)
  library(readr)
  library(rlang)
  library(tidyr)
})

cmd_assign_collect(.files = c("out/vals_sensitivity_0.1.rds",
                              "out/vals_sensitivity_0.5.rds",
                              "out/vals_sensitivity_1.rds",
                              "out/fig_sensitivity_all_female.pdf"),
                   sex = "Female")

n <- length(.files)
.sens <- .files[1:(n-1)]
.out <- .files[n]

names <- .sens |>
  sub("out/vals_sensitivity_(.*)\\.rds", "\\1", x = _) |>
  map_chr(\(x) paste("Scale =", x))

vals <- .sens |>
  map(read_rds) |>
  set_names(names) |>
  bind_rows(.id = "model")

times_all <- vals |>
  pull(time) |>
  unique()

times_plot <- seq(from = max(times_all),
                  to = min(times_all),
                  by = -4) |>
  sort()

data <- vals |>
  filter(time %in% times_plot) |>
  filter(sex == !!sex)

p <- ggplot(data, aes(x = age_mid(age))) +
  facet_grid(vars(model), vars(time)) +
  geom_ribbon(aes(ymin = .fitted.lower,
                  ymax = .fitted.upper),
              fill = "lightblue") +
  geom_line(aes(y = .fitted.mid),
            color = "darkblue",
            linewidth = 0.25) +
  geom_point(aes(y = .observed),
             na.rm = TRUE,
             color = "red",
             alpha = 0.5,
             size = 0.2) +
  xlab("Age") +
  ylab("Migration Rate") +
  theme_bw()
      
pdf(file = .out,
    width = 6,
    height = 4.5)
print(p)
dev.off()
