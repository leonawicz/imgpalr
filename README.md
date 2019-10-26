
<!-- README.md is generated from README.Rmd. Please edit that file -->

# imgpalr <img src="man/figures/logo.png" style="margin-left:10px;margin-bottom:5px;" width="120" align="right">

**Author:** [Matthew Leonawicz](https://leonawicz.github.io/blog/)
<a href="https://orcid.org/0000-0001-9452-2771" target="orcid.widget">
<image class="orcid" src="https://members.orcid.org/sites/default/files/vector_iD_icon.svg" height="16"></a>
<br/> **License:** [MIT](https://opensource.org/licenses/MIT)<br/>

[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![Travis build
status](https://travis-ci.org/leonawicz/imgpalr.svg?branch=master)](https://travis-ci.org/leonawicz/imgpalr)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/leonawicz/imgpalr?branch=master&svg=true)](https://ci.appveyor.com/project/leonawicz/imgpalr)
[![Codecov test
coverage](https://codecov.io/gh/leonawicz/imgpalr/branch/master/graph/badge.svg)](https://codecov.io/gh/leonawicz/imgpalr?branch=master)

[![CRAN
status](http://www.r-pkg.org/badges/version/imgpalr)](https://cran.r-project.org/package=imgpalr)
[![CRAN
downloads](http://cranlogs.r-pkg.org/badges/grand-total/imgpalr)](https://cran.r-project.org/package=imgpalr)
[![Github
Stars](https://img.shields.io/github/stars/leonawicz/trekcolors.svg?style=social&label=Github)](https://github.com/leonawicz/imgpalr)

The `imgpalr` package makes it easy to create color palettes from image
files.

  - Choose the type of color palette to derive from an image:
    qualitative, sequential or divergent.
  - Quantiles of an image color distribution can be trimmed.
  - Near-black or near-white colors can be trimmed in RGB space
    independent of trimming brightness or saturation distributions in
    HSV space.
  - Creating sequential palettes also offers control over the order of
    HSV color dimensions to sort by.

<hr>

*If you enjoy my R community contributions, consider* ***[buying me a
coffee in Ko-fi](https://ko-fi.com/leonawicz)*** *(or through PayPal
<a href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=DHMC76S85GJCY&source=url"><img src="https://www.paypalobjects.com/en_US/i/btn/btn_donate_SM.gif" /></a>)
so I can keep developing and maintaining this and other packages :)*

<hr>

## Installation

Install the CRAN release of `imgpalr` with

``` r
install.packages("imgpalr")
```

Install the development version from GitHub with

``` r
# install.packages("remotes")
remotes::install_github("leonawicz/imgpalr")
```

## Examples

The main function is `image_pal`. It accepts PNG, JPG, BMP or GIF (first
frame) images either from disk or URL. It returns a vector of colors
defining a palette based on the image and your other function arguments.
You can also set `plot = TRUE` to plot a preview of the palette, which
includes the source image thumbnail for visual reference.

The examples below offer some typical considerations to make when
deriving a color palette from an arbitrary image.

### Three palette types

In this first set of examples, divergent, qualitative and sequential
palettes are generated from the same image and while varying some
additional settings.

``` r
library(imgpalr)

set.seed(1)
x <- paste0(system.file(package = "imgpalr"), "/",
  c("blue-yellow", "purples", "colors"), ".jpg")

# Three palette types, one image
# Focus on bright, saturated colors for divergent palette:
image_pal(x[1], type = "div",
  saturation = c(0.75, 1), brightness = c(0.75, 1), plot = TRUE)
```

<img src="man/figures/README-example-1.png" width="100%" />

``` r

# Remove colors too close to black and white for qualitative palette:
image_pal(x[1], type = "qual", bw = c(0.25, 0.9), plot = TRUE)
```

<img src="man/figures/README-example-2.png" width="100%" />

``` r

 # A challenging sequential mapping
image_pal(x[1], type = "seq", saturation = c(0.2, 1),
  brightness = c(0.5, 1), seq_by = "hsv", plot = TRUE)
```

<img src="man/figures/README-example-3.png" width="100%" />

### A dominant hue

In this test image, hue varies over a narrow range. A sequential palette
is sensible here, but not necessarily best sorted by hue. Doing so does
still show a perceivable order to the colors, but it is much more
difficult to discern. Sorting the palette first by saturation or
brightness makes a much better sequential palette in this case.

``` r
image_pal(x[2], type = "seq", seq_by = "hsv", plot = TRUE)
```

<img src="man/figures/README-example2-1.png" width="100%" />

``` r
image_pal(x[2], type = "seq", seq_by = "svh", plot = TRUE)
```

<img src="man/figures/README-example2-2.png" width="100%" />

``` r
image_pal(x[2], type = "seq", seq_by = "vsh", plot = TRUE)
```

<img src="man/figures/README-example2-3.png" width="100%" />

### Several hues

Using an image with several prominent hues, a divergent palette is not
sensible here. A sequential is likely best sorted by hue.

Note in the second image below, you can also set `quantize = TRUE` to
show a color-quantized reference thumbnail image based on the derived
palette. This makes use of the `image_quantmap` function. Rather than
only quantizing the image, it does so while also mapping the colors of
any image to an arbitrary color palette based on nearest distances in
RGB space.

``` r

image_pal(x[3], type = "qual", brightness = c(0.4, 1), plot = TRUE)
```

<img src="man/figures/README-example3-1.png" width="100%" />

``` r
image_pal(x[3], type = "seq", bw = c(0.2, 1), saturation = c(0.2, 1), 
          plot = TRUE, quantize = TRUE)
```

<img src="man/figures/README-example3-2.png" width="100%" />

Palette generation uses k-means clustering; results are different each
time you call `image_pal`. If the palette you obtain does not feel
right, even with fixed arguments you can run it again to obtain a
different palette. Depending on the settings and the nature of the
source image, it may change quite a bit. If you need a reproducible
palette, set the `seed` argument. In the example above, the seed was set
globally to avoid having to set it in each call to `image_pal`.

## Related resources

There is also the
[RImagePalette](https://CRAN.R-project.org/package=RImagePalette)
package on CRAN, which uses the median cut algorithm for finding they
dominant colors in an image.

`imgpalr` was originally inspired by the
[paletter](https://github.com/AndreaCirilloAC/paletter) package on
GitHub. Both packages use k-means clustering to find key image colors,
but take some different approaches in methods for assembling color
palettes.

The palette preview (without the thumbnail addition) is based off of
`scales::show_col`, which is a convenient function for plotting
palettes. You can also use `pals::pal.bands` to do the same using a
different visual layout.

If you want to directly manipulate the color properties of an image for
its own sake rather than derive color palettes for other purposes, you
can do so using the [magick](https://CRAN.R-project.org/package=magick)
package, which provides bindings to the ImageMagick library.

-----

Please note that this project is released with a [Contributor Code of
Conduct](https://github.com/leonawicz/imgpalr/blob/master/CODE_OF_CONDUCT.md).
By participating in this project you agree to abide by its terms.
