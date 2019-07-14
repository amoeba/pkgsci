#' Parse a package name from a `.tar.gz` file path
#'
#' @param path The file path to a `.tar.gz` package source archive
#'
#' @return A list with the package's name and version string
parse_package_name <- function(path) {
  stopifnot(is.character(path))

  # Remove .tar.gz ending
  base <- gsub("\\.tar\\.gz$", "", basename(path))
  parts <- strsplit(base, "_")[[1]]

  list(name = parts[1],
       version = parts[2])
}
