#' Process packages
#'
#' Processes a set of `.tar.gz` archives at the specified `path`.
#'
#' @param path The path to look for `.tar.gz` files.
#' @param out_path If set, write resulting `data.frame` out at `out_path` as a
#' `CSV`.
#'
#' @return A `data.frame` unless `out_path` is specified, in which case a `CSV`
#' file is written at `out_path` and `out_path` is returned invisibly.
#' @export
process_packages <- function(path, out_path = NULL) {
  stopifnot(file.exists(path))

  paths <- dir(path, pattern = "\\.tar\\.gz$", full.names = TRUE)
  results <- do.call(rbind, lapply(paths, process_package))

  # Write a CSV and return the `out_path` invisibly when `out_path` is set.
  if (!is.null(out_path)) {
    utils::write.csv(results, out_path, row.names = FALSE)

    return(invisible(out_path))
  }

  results
}
