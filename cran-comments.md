## Test environments
* local Windows 10 install, R 3.6.1
* ubuntu 14.04 (on travis-ci), R 3.6.0
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 0 notes

* This is a resubmission for a new release.

* Imported `png` package in order to make example in help docs executable if they require loading an image file.
* There have been some other function, documentation and unit test additions since the original submission that are now present; specifically for `image_quantmap`. I have treated the examples the same as the CRAN recommendation for `image_pal` examples.
