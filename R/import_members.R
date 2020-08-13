#' Import data on all members of the Bundestag since 1949
#'
#' This function downloads the file "Stammdaten aller Abgeordneten seit 1949 im
#' XML-Format" from the Bundestag website converts it to a data frame, and
#' recodes some of the variables. The output is a longitudinal dataset, where
#' the level analysis is a member-term.
#'
#' @return A data frame of all parliamentary terms for all members
#' @export
#' @importFrom magrittr "%>%"

# Try this later...
# assign("x", 1, envir = as.environment("package:btmembers"))

import_members <- function() {
  link_info <- extract_link_info()
  paste0("Downloading version ", link_info$data_version) %>%
    message()
  members <- import_raw_list(link_info$href) %>%
    convert_to_df() %>%
    recode_df(link_info$data_version)
  members
}


