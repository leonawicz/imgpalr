context("image palettes")

test_that("image_pal and image_quantmap returns as expected", {
  x <- system.file("blue-yellow.png", package = "imgpalr")

  if(require(png)){
    y <- image_pal(x, seed = 1, plot = FALSE)
    expect_is(y, "character")
    expect_equal(length(y), 9)

    y <- image_pal(x, n = 5, type = "seq", plot = TRUE, keep_asp = FALSE)
    dev.off()
    expect_is(y, "character")
    expect_equal(length(y), 5)

    y <- image_pal(x, type = "div", plot = TRUE, quantize = TRUE)
    dev.off()
    expect_is(y, "character")
    expect_equal(length(y), 9)

    pal <- image_pal(x, type = "div")
    a <- image_quantmap(x, pal, plot = TRUE)
    dev.off()
    expect_is(a, "array")
    a <- image_quantmap(x, pal, plot = TRUE, show_pal = FALSE)
    dev.off()
    expect_is(a, "array")
    unlink("Rplots.pdf", recursive = TRUE, force = TRUE)
  }
})
