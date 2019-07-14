#' Extract the formals from a `roxy_block` object
#'
#' @param roxy_block A `roxy_block` object
#'
#' @return A `data.frame` with a row for each formal, its value, and the
#' function it belongs to
extract_formals <- function(roxy_block) {
  parsed_block <- parse_roxy_block(roxy_block)

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

  # Reference `data.frame` with namespace to avoid any masking that packages
  # might do once loaded by `roxygen2`. e.g., `ggplot2`
  base::data.frame(name = parsed_block$name,
                   arg = formal_names,
                   value = formal_values,
                   stringsAsFactors = FALSE)
}
