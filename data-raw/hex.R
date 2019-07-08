library(hexSticker)
library(ggplot2)
library(png)
library(grid)
user <- "leonawicz"
account <- "github"
url <- "leonawicz.github.io/imgpalr"
out <- paste0("man/figures/logo.png")
p <- rasterGrob(readPNG("data-raw/imgpalr_bg.png"))

hex_plot <- function(out, mult = 1){
  sticker(p, package = "imgpalr", p_x = 1.025, p_y = 1, p_color = "#222222", p_size = 36,
          s_x = 0.98, s_y = 0.97, s_width = 3, s_height = 3,
          h_color = "#222222", h_fill = "#FFFFFF", h_size =  1.4,
          url = url, u_color = "#FFFFFF", u_size = 3, u_x = 1.03, u_y = 0.08, filename = out,
          p_family = "sans", u_family = "sans")
}

hex_plot(out)
