#' Process an individual package
#'
#' Processes a package from its source extracted on disk.
#'
#' @param path The path to the package's source
#'
#' @return A `data.frame` of the package's formals
process_package <- function(path) {
  stopifnot(file.exists(path))

  # Process packages as safely as we can with a tryCatch
  roxy_blocks <- tryCatch({
    roxygen2::parse_package(path)
  },
  error = function(e) {
    warning(e)

    return(base::data.frame())
  })

  if (length(roxy_blocks) == 0) {
    warning("No roxy_blocks extracted from package source at ", path, ".")

    return(base::data.frame())
  }

  result <- do.call(rbind, lapply(roxy_blocks, extract_formals))

  # Add on package name
  result <- cbind(
    base::data.frame(
      path = path),
    result
  )

  result
}

