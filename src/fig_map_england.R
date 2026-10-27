
suppressPackageStartupMessages({
  library(command)
  library(ggplot2)
  library(ggrepel)
  library(readr)
  library(sf)
})

cmd_assign(
  .regions = file.path(
    "data",
    "Regions_December_2024_Boundaries_EN_BUC_1864665699622012197",
    "RGN_DEC_24_EN_BUC.shp"
  ),
  .out = "out/fig_map_england.pdf"
)

regions <- st_read(.regions)

labels <- st_point_on_surface(regions)
coords <- st_coordinates(labels)
labels$x <- coords[, 1]
labels$y <- coords[, 2]

p <- ggplot(regions) +
  geom_sf(fill = "grey90", colour = "grey30") +
  geom_label_repel(
    data = labels,
    aes(x = x, y = y, label = RGN24NM),
    fill = NA,
    segment.color = NA,
    linewidth = 0,
    size = 3,
    max.overlaps = Inf,
    min.segment.length = 0
  ) +
  theme_void()

pdf(file = .out,
    width = 5,
    height = 6)
print(p)
dev.off()
    
