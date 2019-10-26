context("image palettes")

test_that("image_pal and image_quantmap returns as expected", {
  x <- system.file("blue-yellow.png", package = "imgpalr")

  if(require(png)){
    file <- file.path(tempdir(), "test-plot.png")
    png(file)

    y <- image_pal(x, seed = 1, plot = FALSE)
    expect_is(y, "character")
    expect_equal(length(y), 9)

    y <- image_pal(x, n = 5, type = "seq", plot = TRUE, keep_asp = FALSE)
    expect_is(y, "character")
    expect_equal(length(y), 5)

    y <- image_pal(x, type = "div", plot = TRUE, quantize = TRUE)
    expect_is(y, "character")
    expect_equal(length(y), 9)

    pal <- image_pal(x, type = "div")
    a <- image_quantmap(x, pal, plot = TRUE)
    expect_is(a, "array")
    a <- image_quantmap(x, pal, plot = TRUE, show_pal = FALSE)
    expect_is(a, "array")

    unlink(file, recursive = TRUE, force = TRUE)
  }
})
