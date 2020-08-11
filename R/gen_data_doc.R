gen_data_doc <- function(){
  header <- c(
    "#' Members of the Bundestag since 1949.",
    "#'",
    "#' A dataset with basic biographical and election data for all members of",
    "#' the Bundestag since 1949.",
    "#'"
  )
  format <- paste0(
    "#' @format A tibble with ",
    nrow(btmembers::members),
    " observations from ",
    length(unique(btmembers::members$id)),
    " members of the Bundestag.\n",
    "#' It includes ",
    ncol(btmembers::members),
    " variables:"
  )
  variables <- c(
    "#' \\describe{",
    purrr::map_chr(names(btmembers::members), var_item),
    "#' }"
  )
  source <- c(
    "#' @source Adapted from Bundestag (2020), \\emph{Stammdaten aller Abgeordneten",
    "#' seit 1949 im XML-Format},",
    "#' \\url{https://www.bundestag.de/services/opendata}."
    )
  fileConn<-file("R/members.R")
  writeLines(c(
    header,
    format,
    variables,
    source,
    "\"members\""), fileConn)
  close(fileConn)
}

var_item <- function(one_var) {
  var_item <- paste0(
    "#'   \\item{",
    one_var,
    "}",
    "{A label}"
  )
}
