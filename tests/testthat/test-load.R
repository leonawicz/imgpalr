context("file load")

test_that("image_load loads file", {
  x <- paste0(system.file(package = "imgpalr"), "/blue-yellow.", # nolint
    c("png", "jpg", "bmp", "gif"))
  if(require(png)) expect_is(image_load(x[1]), "array")
  if(require(jpeg)) expect_is(image_load(x[1]), "array")
  if(require(bmp)) expect_is(image_load(x[1]), "array")
  if(require(magick)) expect_is(image_load(x[1]), "array")
})
