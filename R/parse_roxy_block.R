#' Parse a `roxy_block` object
#'
#' @param roxy_block A `roxy_block` object, from \
#' link[roxygen2]{parse_package}
#'
#' @return A list of parsed information from a roxy_block object such as its
#' title, description, and formals
parse_roxy_block <- function(roxy_block) {
  stopifnot(class(roxy_block) == "roxy_block")

  if (!"object" %in% names(attributes(roxy_block))) {
    warning("No object")
  }

  object <- attr(roxy_block, "object")

  list(name = object$alias,
       title = roxy_block$title,
       description = roxy_block$description,
       formals = formals(object$value),
       classes = attr(object, "class")) # Is this the full hierarchy?
}
