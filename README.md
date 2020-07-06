
<!-- README.md is generated from README.Rmd. Please edit that file -->

# DSPG

<!-- badges: start -->

<!-- badges: end -->

The goal of the DSPG package is to provide access to commonly used
publicly available data for the DSPG projects at ISU.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("DSPG-ISU/DSPG")
```

The above code might not work as supposed to because the repo is
private. If the installation fails with an error along the lines that
the repo doesn’t exist, make sure to clone the repo onto your machine.
Unzip the folder. Open `DSPG.Rpoj` in RStudio (by double-clicking the
file). Install the package using the command

``` r
# install.packages("devtools")
devtools::install()
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(DSPG)
```

All of the data sets have an extensive example section with code that
should help you get started.

## Content

The datasets available
    are

    #> churches colleges health.clinics hospitals ia_cities ia_counties iowaworks mat parks sud

Check each file with the R help, e.g. `?ia_cities`, for more details.
