# pkgsci

<!-- badges: start -->
[![Travis build status](https://travis-ci.org/amoeba/pkgsci.svg?branch=master)](https://travis-ci.org/amoeba/pkgsci)
<!-- badges: end -->

A set of utility functions for collating information about how people write packages.

## Installation

``` r
remotes::install_githb("amoeba/pkgsci")
```

## Usage

`pkgsci` processes directories containing `.tar.gz` files with R package sources.
Assuming you have a directory on your computer, `/tmp/packages`, you can run:

```r
library(pkgsci)

process_packages('/tmp/packages')
```

And you should be given a `data.frame` with columns:

- `package_name`
- `package_version`
- `name`
- `arg`
- `value`

