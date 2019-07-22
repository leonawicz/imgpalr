#' Create a color palette from an image
#'
#' Derive qualitative, sequential and divergent color palettes from an image on disk or at a URL.
#'
#' @details
#' Ordering colors is a challenging problem. There are many ways to do it; none are perfect.
#' Color is a multi-dimensional property; any reduction to a a one dimensional color spectrum necessarily removes information.
#'
#' Creating a sequential palette from an arbitrary image that contains several hues, at different saturation and brightness levels, and making a palette that looks sequential is particularly problematic.
#' This function does a decent job of creating qualitative, sequential and divergent palettes from images, but additional tweaking of function arguments is needed on a case by case basis.
#' This can include trimming the extreme values of the color distribution in terms of brightness, saturation and presence of near-black/white colors as pre-processing steps.
#' There is also variation in possible palettes from a given image, depending on the image complexity and other properties, though you can set the random seed for reproducibility.
#'
#' @section Trimming color distribution:
#' Some pre-processing can be done to limit undesirable colors from ending up in a palette.
#' \code{bw} specifically drops near-black and near-white colors as soon as the image is loaded by looking at the average values in RGB space.
#' \code{brightness} and \code{saturation} trimming are applied subsequently to trim lower and upper quantiles of the HSV value and saturation, respectively.
#' If you have already trimmed black and white, keep in mind these two arguments will trim further from what remains of the color distribution.
#'
#' @section Choosing appropriate palette type:
#' Keep in mind that many images simple do not make sense to try to derive sensible color palettes from.
#' For images that do lend themselves to a useful color palette derivation, some may only make sense to consider for a divergent palette, or an increasing/decreasing sequential palette,
#' or only a qualitative palette if there are too many colors that are difficult to order.
#' For divergent palettes in particular, it is recommended to trim white, e.g. \code{bw = c(0, 0.9)}, depending on the white space of a given image, since the divergent palettes are centered on white.
#'
#' @section Sorting sequential palettes:
#' \code{seq_by = "hsv"} orders the final palette by hue, then saturation, then value (brightness). This default is not meant to be ideal for all images.
#' It work better in cases where sequential palettes may contain several distinct hues, but not much variation in saturation or brightness.
#' However, for example, palettes derived from an image with relatively little variation in hue may appear more sorted to the human eye if ordered by hue last using \code{"svh"} or \code{"vsh"},
#' depending on whether you want the palette to appear to transition more from lower saturation or lower brightness to the predominant hue.
#'
#' @param file character, file path or URL to an image.
#' @param n integer, number of colors.
#' @param type character, type of palette: qualitative, sequential or divergent (\code{"qual"}, \code{"seq"}, or \code{"div"}).
#' @param bw a numeric vector of length two giving the lower and upper quantiles to trim trim near-black and near-white colors in RGB space.
#' @param brightness as above, trim possible colors based on brightness in HSV space.
#' @param saturation as above, trim possible colors based on saturation in HSV space.
#' @param seq_by character, sort sequential palette by HSV dimensions in a specific order, e.g., \code{"hsv"}, \code{"svh"}. See details.
#' @param seed numeric, set the seed for reproducible results.
#' @param plot logical, plot the palette.
#' @param labels logical, show hex color values in plot.
#' @param label_size numeric, label size in plot.
#' @param label_color text label color.
#' @param keep_asp logical, adjust rectangles in plot to use the image aspect ratio.
#' @param quantize logical, quantize the reference thumbnail image in the plot using the derived color palette. See \code{image_quantmap}.
#'
#' @return character vector of hex colors, optionally draws a plot
#' @export
#' @seealso \code{\link{image_quantmap}}
#'
#' @examples
#' set.seed(1)
#' x <- "blue-yellow.jpg", system.file(package = "imgpalr")
#'
#' # Focus on bright, saturated colors for divergent palette:
#' image_pal(x, n = 3, type = "div",
#'   saturation = c(0.75, 1), brightness = c(0.75, 1), plot = TRUE)
#'
#' \donttest{
#' # A challenging sequential mapping
#' image_pal(x, n = 3, type = "seq", saturation = c(0.2, 1),
#'   brightness = c(0.5, 1), seq_by = "hsv", plot = FALSE)
#' }
image_pal <- function(file, n = 9, type = c("qual", "seq", "div"), bw = c(0, 1),
                      brightness = c(0, 1), saturation = c(0, 1), seq_by = "hsv", seed = NULL,
                      plot = FALSE, labels = TRUE, label_size = 1, label_color = "#000000",
                      keep_asp = TRUE, quantize = FALSE){
  if(is.numeric(seed)) set.seed(seed)
  type <- match.arg(type)
  a <- image_load(file)
  d <- .filter_colors(a, bw, brightness, saturation)
  if(type == "div"){
    x <- .to_div_pal(d[, c("h", "s", "v")], n)
  } else {
    nmax <- nrow(dplyr::distinct_at(d, c("h", "s", "v")))
    x <- km(d[, c("h", "s", "v")], min(10 * n, nmax)) %>% tibble::as_tibble() %>%
      dplyr::mutate(hex = hsv(.data[["h"]], .data[["s"]], .data[["v"]]))
    if(n > nrow(x)) n <- nrow(x)
    if(type == "qual"){
      x <- .to_qual_pal(x, n)
    } else {
      x <- .to_seq_pal(x, strsplit(seq_by, "")[[1]], n)
    }
  }
  if(plot){
    if(quantize) image_quantmap(a, x, TRUE, TRUE, labels, label_size, label_color, keep_asp) else
      .view_image_pal(a, x, labels, label_size, label_color, keep_asp)
  }
  x
}

km <- function(x, centers) suppressWarnings(kmeans(x, centers, 30)$centers)

.to_div_pal <- function(d, n){
  x <- km(d, 2)
  x <- c(do.call(hsv, as.list(x[1, ])), do.call(hsv, as.list(x[2, ])))
  colorRampPalette(rev(c(x[1], "#FFFFFF", x[2])))(n)
}

.to_qual_pal <- function(x, n){
  get_idx <- function(y) y[[which.max(sapply(y, "[[", 2))]][[1]]
  y <- lapply(1:10000, function(z){
    i <- sample(1:nrow(x), n)
    list(i, min(dist(x[i, c("h", "s", "v")])))
  })
  x <- x[get_idx(y), ]
  y <- lapply(1:10000, function(z){
    i <- sample(1:n)
    list(i, mean(diff(x$h[i]) ^ 2))
  })
  x$hex[get_idx(y)]
}

.to_seq_pal <- function(x, seq_by, n){
  x <- dplyr::arrange_at(x, seq_by) %>%
    dplyr::mutate(grp = cut(1:nrow(x), min(10, nrow(x)), FALSE)) %>% dplyr::arrange_at("grp") %>%
    dplyr::group_by(.data[["grp"]]) %>% dplyr::summarise_at(c("h", "s", "v"), mean) %>%
    dplyr::mutate(hex = hsv(.data[["h"]], .data[["s"]], .data[["v"]])) %>%
    dplyr::arrange_at(seq_by)
  colorRampPalette(x$hex)(n)
}

.filter_colors <- function(a, bw, brightness, saturation){
  d <- expand.grid(1:dim(a)[2], dim(a)[1]:1) %>%
    dplyr::mutate(r = as.numeric(a[, , 1]), g = as.numeric(a[, , 2]), b = as.numeric(a[, , 3]),
                  mn = pmin(.data[["r"]], .data[["g"]], .data[["b"]]),
                  mx = pmax(.data[["r"]], .data[["g"]], .data[["b"]])) %>%
    dplyr::filter(.data[["mx"]] >= bw[1] & .data[["mn"]] <= bw[2]) %>%
    dplyr::mutate(hex = rgb(.data[["r"]], .data[["g"]], .data[["b"]]))
  d <- data.frame(t(rgb2hsv(t(d[, c("r", "g", "b")]), maxColorValue = 1)))
  brt <- quantile(d$v, probs = brightness)
  sat <- quantile(d$s, probs = saturation)
  dplyr::filter(d, .data[["v"]] >= brt[1] & .data[["v"]] <= brt[2] &
                .data[["s"]] >= sat[1] & .data[["s"]] <= sat[2])
}
