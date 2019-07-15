#' Process packages
#'
#' Processes a set of packages at the given path. The path specified by `path`
#' is scanned for folders containing `DESCRIPTION` files.
#'
#' @param path The path to look for package source directories.
#' @param out_path If set, write resulting `data.frame` out at `out_path` as a
#' `CSV`.
#'
#' @return A `data.frame` unless `out_path` is specified, in which case a `CSV`
#' file is written at `out_path` and `out_path` is returned invisibly.
#' @export
process_packages <- function(path, out_path = NULL) {
  stopifnot(file.exists(path))

  dirs <- list.dirs(path, recursive = FALSE)

  # Filter out any dirs that don't have a DESCRIPTION file
  dirs <- Filter(function(subdir) {
    "DESCRIPTION" %in% dir(subdir)
  }, dirs)

  results <- do.call(rbind, lapply(dirs, process_package))

  # Write a CSV and return the `out_path` invisibly when `out_path` is set.
  if (!is.null(out_path)) {
    utils::write.csv(results, out_path, row.names = FALSE)

    return(invisible(out_path))
  }

  results
}
