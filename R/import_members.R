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

import_members <- function() {
  members_list <- import_raw_list()
  varlists <- get_varlists()
  members <- convert_to_df(members_list, varlists)
  members
}


