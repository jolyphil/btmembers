gen_data_doc <- function(members){
  header <- c(
    "#' Members of the Bundestag since 1949",
    "#'",
    "#' A dataset with basic biographical and election data for all members of",
    "#' the Bundestag since 1949.",
    "#'"
  )
  format <- paste0(
    "#' @format A tibble with ",
    nrow(members),
    " observations from ",
    length(unique(members$id)),
    " members of the Bundestag.\n",
    "#' It includes ",
    ncol(members),
    " variables (in German):"
  )
  variables <- c(
    "#' \\describe{",
    purrr::map2_chr(names(members), members, var_item),
    "#' }"
  )
  source <- c(
    "#' @source Adapted from Bundestag (2020), \\emph{Stammdaten aller Abgeordneten",
    paste0("#' seit 1949 im XML-Format}, version: ",
           attr(members, "version"),
           ","),
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

var_item <- function(name, var) {
  var_item <- paste0(
    "#'   \\item{`",
    name,
    "`}",
    "{",
    attr(var, "label"),
    "}"
  )
}
