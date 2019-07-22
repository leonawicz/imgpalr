## Test environments
* local Windows 10 install, R 3.6.1
* ubuntu 14.04 (on travis-ci), R 3.6.0
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 1 notes

* This is a resubmission for a new release.

The following changes have reduced the execution time of examples:

* The function examples for `image_pal` and `image_quantmap` have been simplified and tweaked to execute faster where possible.
* Redundancies have been removed where examples do not need to include several similar function calls back to back for all three palette types.
* The argument `k` has been added to allow control over the number of k-means cluster centers considered on initial image processing step.
