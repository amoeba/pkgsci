#' Parse a `roxy_block` object
#'
#' @param roxygen_block A `roxy_block` object, from \
#' link[roxygen2]{parse_package}
#'
#' @return A list of parsed information from a roxy_block object such as its
#' title, description, and formals
#' @export
parse_block <- function(roxygen_block) {
  stopifnot(class(roxygen_block) == "roxy_block")

  if (!"object" %in% names(attributes(roxygen_block))) {
    warning("No object")
  }

  object <- attr(roxygen_block, "object")

  list(name = object$alias,
       title = roxygen_block$title,
       description = roxygen_block$description,
       formals = formals(object$value),
       classes = attr(object, "class")) # Is this the full hierarchy?
}

#' Extract the formals from a `roxy_block` object
#'
#' @param roxygen_block A `roxy_block` object
#'
#' @return A `data.frame` with a row for each formal, its value, and the
#' function it belongs to
#' @export
extract_formals <- function(roxy_block) {
  parsed_block <- parse_block(roxy_block)

  # Collect values of each formal by converting each to an expression and then
  # getting a character representation of it
  formal_values <- vapply(parsed_block$formals, function(formal) {
    as.character(as.expression(formal))
  }, "")

  # Grab the names to use later on
  formal_names <- names(formal_values)

  if (length(formal_names) == 0) {
    return(base::data.frame())
  }

  base::data.frame(name = parsed_block$name,
                   arg = formal_names,
                   value = formal_values)
}

targz_path <- "~/Downloads/ggplot2_3.2.0.tar.gz"
extract_dir <-tempdir()
untar(targz_path, exdir = extract_dir)

man_dir <- file.path(extract_dir, "ggplot2", "man")
stopifnot(file.exists(man_dir))
man_files <- dir(man_dir, full.names = TRUE)

roxy_blocks <- roxygen2::parse_package(file.path(extract_dir, "ggplot2"))
result <- do.call(rbind, lapply(roxy_blocks, extract_formals))
