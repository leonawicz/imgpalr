#' Quantize an image using an existing color palette
#'
#' Quantize image colors by mapping all pixels to the nearest color in RGB space, respectively, given an arbitrary palette.
#'
#' The palette \code{pal} does not need to be related to the image colors. Each pixel will be assigned to whichever color in \code{pal} that it is nearest to in RGB space.
#' This function returns the new RGB array. You can plot a preview just like with \code{image_pal} using \code{plot = TRUE}.
#' The number of k-means centers \code{k} is for binning image colors prior to mapping the palette \code{pal}.
#' It is limited by the number of unique colors in the image. Larger \code{k} provides more binned distances between image colors and palette colors,
#' but takes longer to run.
#'
#' @param file if character, file path or URL to an image. You can also provide an RGB array from an already loaded image file.
#' @param pal character, vector of hex colors, the color palette used to quantize the image colors.
#' @param k integer, the number of k-means cluster centers to consider in the image. See details.
#' @param plot logical, plot the palette with quantized image reference thumbnail. If \code{FALSE}, only return the RGB array.
#' @param show_pal logical, show the palette like with \code{image_pal}. If \code{FALSE}, plot only the image; all subsequent arguments ignored.
#' @param labels logical, show hex color values in plot.
#' @param label_size numeric, label size in plot.
#' @param label_color text label color.
#' @param keep_asp logical, adjust rectangles in plot to use the image aspect ratio.
#'
#' @return an RGB array with values ranging from 0 to 1
#' @export
#' @seealso \code{\link{image_pal}}
#'
#' @examples
#' x <- system.file("blue-yellow.jpg", package = "imgpalr")
#' pal <- c("#191970", "#63B8FF", "#FFFF00")
#' a <- image_quantmap(x, pal, k = 7, plot = TRUE)
#' str(a)
image_quantmap <- function(file, pal, k = 100, plot = FALSE, show_pal = TRUE,
                           labels = TRUE, label_size = 1, label_color = "#000000",
                           keep_asp = TRUE){
  a <- if(is.character(file)) image_load(file) else file
  dm <- dim(a)
  f <- function(x, i) as.numeric(x[, , i])
  d <- tibble::tibble(red = f(a, 1), green = f(a, 2), blue = f(a, 3))
  nmax <- nrow(dplyr::distinct(d))
  x <- suppressWarnings(kmeans(d, min(k, nmax), 30))
  d <- tibble::as_tibble(x$centers[x$cluster, ]) %>% dplyr::mutate(id = x$cluster)
  d2 <- dplyr::distinct(d)
  col_map <- tibble::as_tibble(t(grDevices::col2rgb(pal) / 255))
  f2 <- function(r, g, b){
    x <- matrix(c(r, g, b, as.numeric(t(col_map))), ncol = 3, byrow = TRUE)
    which.min(as.matrix(dist(x))[-1, 1])
  }
  d2 <- dplyr::rowwise(d2) %>%
    dplyr::mutate(idx = f2(.data[["red"]], .data[["green"]], .data[["blue"]]))
  idx <- dplyr::left_join(d, d2, by = c("red", "green", "blue", "id"))$idx
  d <- col_map[idx, ]
  a <- simplify2array(list(matrix(d$red, dm[1]), matrix(d$green, dm[1]), matrix(d$blue, dm[1])))
  if(plot){
    if(show_pal){
      .view_image_pal(a, pal, labels, label_size, label_color, keep_asp)
    } else {
      opar <- par(mar = rep(0, 4), xaxs = "i", yaxs = "i")
      on.exit(par(opar))
      print(dm)
      plot(0, 0, xlim = c(1, dm[2]), ylim = c(1, dm[1]), asp = 1, type = "n",
           xlab = "", ylab = "", axes = FALSE)
      rasterImage(a, 1, 1, dm[2], dm[1], interpolate = TRUE)
    }
  }
  a
}
