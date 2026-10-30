
suppressPackageStartupMessages({
  library(command)
  library(dplyr)
  library(ggh4x)
  library(ggplot2)
  library(patchwork)
  library(readr)
  library(yaml)
})

cmd_assign(.vals = "out/vals_heldback_all.rds",
           .config = "config.yaml",
           .out = "out/fig_heldback.pdf")

vals <- read_rds(.vals)
config <- read_yaml(.config)

xlims <- list(
  c(0, 100),
  c(0, 100),
  c(0, NA),
  c(0, NA),
  c(0, NA)
)

reference_lines <- tibble(
  statistic = unique(vals$statistic)[1:2],
  reference = c(50, 95)
)

p <- ggplot(vals, aes(x = value, y = model)) +
  facet_grid(vars(period), vars(statistic), scales = "free_x") +
  facetted_pos_scales(
    x = lapply(xlims, \(lim) scale_x_continuous(limits = lim))
  ) +
  geom_vline(
    data = reference_lines,
    aes(xintercept = reference),
    colour = "grey40",
    linewidth = 0.2,
    ) +
  geom_point(size = 0.6) +
  xlab("") +
  ylab("") +
  theme_bw() +
  theme(
    text = element_text(size = 8),
    axis.text.x = element_text(
      angle = 90,
      hjust = 1,
      vjust = 0.5
    )
  )


pdf(file = .out,
    width = 6,
    height = 4)
print(p)
dev.off()
