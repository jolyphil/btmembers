#' Check for an updated version of the dataset on members of the Bundestag
#'
#' @description
#' `update_available()` compares the version of the data loaded with the package
#' with the version currently available on the Bundestag website.
#'
#' @return
#' Returns TRUE if a more recent version of the data is available and FALSE
#' otherwise.
#'

update_available <- function() {
  online_version <- extract_link_info()$data_version
  loaded_version <- attr(members, "version")
  update <- online_version > loaded_version
  if (update) {
    paste0("A new version of the data is available (date: ",
           online_version,
           "). You can import it by running import_members().") %>%
      message()
  } else {
    message("You currently have the most recent version of the data.")
  }
  update
}
