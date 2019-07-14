#' Process an individual package
#'
#' Processes a package as a `.tar.gz`` file and returns the extracted formal
#' arguments and their default values.
#'
#' @param targz_path Path to a `.tar.gz`
#'
#' @return A `data.frame` of the package's formals
process_package <- function(targz_path) {
  stopifnot(file.exists(targz_path))
  stopifnot(grepl("\\.tar\\.gz$", targz_path))

  package <- parse_package_name(targz_path)

  # Unzip package
  extract_dir <- tempdir()
  utils::untar(targz_path, exdir = extract_dir)

  # Process
  roxy_blocks <- roxygen2::parse_package(file.path(extract_dir, package$name))

  if (length(roxy_blocks) == 0) {
    warning("No roxy_blocks extracted from ", targz_path, ".")

    return(base::data.frame())
  }

  result <- do.call(rbind, lapply(roxy_blocks, extract_formals))

  # Add on package name
  result <- cbind(
    base::data.frame(package_name = package$name,
               package_version = package$version),
    result
  )

  # Clean up after ourselves just in case
  on.exit({
    if (file.exists(extract_dir)) {
      unlink(extract_dir)
    }
  })

  result
}

