context("file load")

test_that("image_load loads file", {
  x <- paste0(system.file(package = "imgpalr"), "/blue-yellow.", # nolint
    c("png", "jpg", "bmp", "gif"))
  url <- "https://raw.githubusercontent.com/leonawicz/imgpalr/master/inst/"

  expect_error(image_load("a"), "`file` must be PNG, JPG, GIF, or BMP.")

  if(require(png)){
    expect_is(image_load(x[1]), "array")
    expect_is(image_load(paste0(url, basename(x[1]))), "array")
  }
  if(require(jpeg)){
    expect_is(image_load(x[2]), "array")
    expect_is(image_load(paste0(url, basename(x[2]))), "array")
  }
  if(require(bmp)){
    expect_is(image_load(x[3]), "array")
    expect_is(image_load(paste0(url, basename(x[3]))), "array")
  }
  if(require(magick)){
    expect_is(image_load(x[4]), "array")
    expect_is(image_load(paste0(url, basename(x[4]))), "array")
  }
})
