context("image palettes")

test_that("image_pal and image_quantmap returns as expected", {
  x <- system.file("blue-yellow.png", package = "imgpalr")

  if(require(png)){
    y <- image_pal(x, plot = FALSE)
    expect_is(y, "character")
    expect_equal(length(y), 9)

    y <- image_pal(x, n = 5, type = "seq", plot = TRUE, keep_asp = FALSE)
    expect_is(y, "character")
    expect_equal(length(y), 5)
    dev.off()

    y <- image_pal(x, type = "div", plot = TRUE, quantize = TRUE)
    expect_is(y, "character")
    expect_equal(length(y), 9)
    dev.off()
    unlink("Rplots.pdf", recursive = TRUE, force = TRUE)
  }
})
