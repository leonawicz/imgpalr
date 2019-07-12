.view_image_pal <- function(a, pal, labels = TRUE, label_size = 1,
                            label_color = "#000000", keep_asp = TRUE){
  n <- length(pal)
  nc <- ceiling(sqrt(n))
  nr <- ceiling(n / nc)
  if(nr * nc == n){
    pal <- c(pal, "#FFFFFF")
    n <- length(pal)
    nc <- ceiling(sqrt(n))
    nr <- ceiling(n / nc)
    m <- matrix(0, nc, nr)
    m[n] <- 1
  } else {
    m <- matrix(0, nc, nr)
    m[n + 1] <- 1
  }
  m <- t(m)
  xy <- rev(as.numeric(which(m == 1, arr.ind = TRUE))) - c(1, 0)
  xy[2] <- -xy[2]
  pal <- c(pal, rep(NA, nr * nc - length(pal)))
  pal <- matrix(pal, ncol = nc, byrow = TRUE)
  f <- function(x) x[nrow(x):1, , drop = FALSE]
  flip <- function(x) simplify2array(list(f(x[, , 1]), f(x[, , 2]), f(x[, , 3])))
  a <- flip(a)
  asp <- dim(a)[1] / dim(a)[2]
  opar <- par(mar = rep(0, 4), xaxs = "i", yaxs = "i")
  on.exit(par(opar))
  plot(c(0, dim(pal)[2]), c(0, -dim(pal)[1]), type = "n", xlab = "", ylab = "",
       axes = FALSE, asp = if(keep_asp) asp else 1)
  rect(col(pal) - 1, -row(pal) + 1, col(pal), -row(pal), col = pal, lwd = 3, border = "white")
  if(labels) text(col(pal) - 0.5, -row(pal) + 0.5, pal, cex = label_size, col = label_color)
  if(keep_asp) asp <- 1
  if(asp <= 1){
    gap <- (1 - asp) / 2
    rasterImage(a, xy[1], xy[2] + 1 * asp + gap,
                xy[1] + 1, xy[2] + gap, interpolate = TRUE)
  } else {
    gap <- asp / 2
    rasterImage(a, xy[1] + 1 + 1 / asp - gap, xy[2] + 1, xy[1] + 2 - gap, xy[2], interpolate = TRUE)
  }
  rect(col(pal) - 1, -row(pal) + 1, col(pal), -row(pal), col = "transparent", lwd = 3, border = "white")
  invisible()
}
