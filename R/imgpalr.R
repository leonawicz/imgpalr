globalVariables(c(".data"))

#' imgpalr: Create color palettes from images
#'
#' The \code{imgpalr} package is used for generating color palettes from image files.
#' It offers control over the type of color palette to derive from an image (qualitative, sequential or divergent) and other palette properties.
#' Quantiles of an image color distribution can be trimmed.
#' Near-black or near-white colors can be trimmed in RGB color space independent of trimming brightness or saturation distributions in HSV color space.
#' Creating sequential palettes also offers control over the order of HSV color dimensions to sort by.
#'
#' @docType package
#' @name imgpalr
NULL

#' @importFrom tibble tibble
#' @importFrom magrittr %>%
#' @importFrom graphics par plot rect text rasterImage
#' @importFrom grDevices colorRampPalette
#' @importFrom stats dist kmeans quantile
NULL
