#' Load PNG, JPG, BMP or GIF
#'
#' Load PNG, JPG, BMP or GIF from disk or URL.
#'
#' The function will prompt you of the need to install a format-specific package if not installed and needed for
#' the given \code{file} extension; \code{png}, \code{jpeg}, \code{bmp}, \code{magick} (for GIF).
#'
#' @param file character, file name. A local file or URL. Extension must be one of png, jpg, jpeg, bmp or gif.
#'
#' @return an RBG array
#' @export
#'
#' @examples
#' x <- paste0(system.file(package = "imgpalr"), "/blue-yellow.",
#'   c("png", "jpg", "bmp", "gif"))
#' if(require(png)) str(image_load(x[1]))
#' if(require(jpeg)) str(image_load(x[2]))
#' if(require(bmp)) str(image_load(x[3]))
#' if(require(magick)) str(image_load(x[4]))
image_load <- function(file){
  ext <- gsub(".*(\\..*$)", "\\1", file)
  if(!ext %in% c(".png", ".jpg", ".jpeg", ".bmp", ".gif"))
    stop("`file` must be PNG, JPG, GIF, or BMP.", call. = FALSE)
  is_url <- grepl("^(www\\.|http:|https:)", file)
  if(is_url){
    tmp <- tempfile()
    downloader::download(file, destfile = tmp, quiet = TRUE, mode = "wb")
    file <- tmp
  }
  if(ext %in% c(".jpg", ".jpeg")){
    if(!requireNamespace("jpeg", quietly = TRUE)){
      message("This function requires the jpeg package for JPG files. Install and rerun.")
      return(invisible())
    } else {
      x <- jpeg::readJPEG(file)
    }
  } else if(ext == ".png"){
    if(!requireNamespace("png", quietly = TRUE)){
      message("This function requires the png package for PNG files. Install and rerun.")
      return(invisible())
    } else {
      x <- png::readPNG(file)
    }
  } else if(ext == ".bmp"){
    if(!requireNamespace("bmp", quietly = TRUE)){
      message("This function requires the bmp package for BMP files. Install and rerun.")
      return(invisible())
    } else {
      x <- bmp::read.bmp(file)
    }
  } else {
    if(!requireNamespace("magick", quietly = TRUE)){
      message("This function requires the magick package for GIF files. Install and rerun.")
      return(invisible())
    } else {
      x <- as.numeric(magick::image_data(magick::image_read(file)[1]))
    }
  }
  if(any(x > 1)) x <- x / 255
  if(is_url) unlink(tmp, recursive = TRUE, force = TRUE)
  x
}
