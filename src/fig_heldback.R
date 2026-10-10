
suppressPackageStartupMessages({
  library(command)
  library(dplyr)
  library(ggplot2)
  library(patchwork)
  library(readr)
  library(yaml)
})

cmd_assign(.vals = "out/vals_heldback_multi_main.rds",
           .config = "config.yaml",
           .out = "out/fig_heldback_main.pdf")

vals <- read_rds(.vals)
config <- read_yaml(.config)

statistics <- vals |>
  pull(statistic) |>
  unique()

width_max <- vals |>
  filter(grepl("width", statistic)) |>
  pull(value) |>
  max()

point_size <- 0.6

p1 <- vals |>
  filter(statistic == statistics[[1]]) |>
  ggplot(aes(x = value, y = model)) +
  facet_wrap(vars(period), nrow = 1) +
  geom_vline(xintercept = 100 * config$heldback_width_inner,
             color = "gray") +
  geom_point(size = point_size) +
  xlim(0, 100) +
  xlab("") +
  ylab("") +
  ggtitle(statistics[[1]])

p2 <- vals |>
  filter(statistic == statistics[[2]]) |>
  ggplot(aes(x = value, y = model)) +
  facet_wrap(vars(period), nrow = 1) +
  geom_vline(xintercept = 100 * config$heldback_width_outer,
             color = "gray") +
  geom_point(size = point_size) +
  xlim(0, 100) +
  xlab("") +
  ylab("") +
  ggtitle(statistics[[2]])

p3 <- vals |>
  filter(statistic == statistics[[3]]) |>
  ggplot(aes(x = value, y = model)) +
  facet_wrap(vars(period), nrow = 1) +
  geom_point(size = point_size) +
  xlab("") +
  ylab("") +
  xlim(0, width_max) +
  ggtitle(statistics[[3]])

p4 <- vals |>
  filter(statistic == statistics[[4]]) |>
  ggplot(aes(x = value, y = model)) +
  facet_wrap(vars(period), nrow = 1) +
  geom_point(size = point_size) +
  xlab("") +
  ylab("") +
  xlim(0, width_max) +
  ggtitle(statistics[[4]])

p5 <- vals |>
  filter(statistic == statistics[[5]]) |>
  ggplot(aes(x = value, y = model)) +
  facet_wrap(vars(period), nrow = 1) +
  geom_point(size = point_size) +
  xlab("") +
  ylab("") +
  xlim(0, NA) +
  ggtitle(statistics[[5]])

p <- wrap_plots(
  p1, p2,
  p3, p4,
  p5, plot_spacer(),
  ncol = 2,
  widths = c(1, 1)
)

p <- p &
  theme(text = element_text(size = 7),
        strip.text.x = element_text(margin = margin(t = 2, b = 2)))

pdf(file = .out,
    width = 6,
    height = 4)
print(p)
dev.off()
