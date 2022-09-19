#' Import data on all members of the Bundestag since 1949
#'
#' `import_members()` downloads the file "Stammdaten aller Abgeordneten seit
#' 1949 im XML-Format" from the Bundestag website and converts it either to (a)
#' four data frames nested into a list (retaining all the information of the
#' original XML file) or (b) to a single, condensed data frame.
#'
#' @param condensed_df logical; if `TRUE` join the four data frames contained
#'     in the default list into a single, condensed data frame. Warning: Some
#'     data is lost (see Value).
#' @param force_from_bt logical; if `TRUE` force the function to import the data
#'     directly from the Bundestag website. By default, the function compares
#'     the versions of the data on the Bundestag website and the pre-processed
#'     data stored in the package repository on GitHub. If the version on GitHub
#'     is the same as the one on the Bundestag website, the function downloads
#'     the data from GitHub. If the version on the Bundestag website is more
#'     recent, the user will be presented with a menu of three choices:
#'     (1) Download the new, non-tested version from the Bundestag website;
#'     (2) Download the older, pre-processed data from Github; or (3) Cancel.
#'     `force_from_bt = TRUE` never imports the data from GitHub.
#' @return If **`condensed_df = FALSE`** a list containing four data frames:
#'     `namen` (names), `bio` (biographical information), `wp`
#'     (parliamentary terms), and `inst` (institutions).
#'
#'    A codebook with a full list of variables is available
#'    [here](https://github.com/jolyphil/btmembers/blob/main/codebook/codebook.pdf).
#'
#'    If **`condensed_df = TRUE`** a condensed data frame. Each row corresponds
#'    to a member-term. Most of the information contained in the original data
#'    is preserved _except_ only the most recent name of the member is retained
#'    and institutions are removed. A new column named `fraktion` is added to
#'    the data. `fraktion` is a recoded variable and refers to the faction the
#'    member spent most time in during a given parliamentary term.
#'
#' @examples
#' import_members()
#' import_members(condensed_df = TRUE)
#'
#' @export
#' @importFrom magrittr "%>%"
#' @importFrom rlang .data
#' @importFrom tibble tibble
#' @importFrom utils download.file


import_members <- function(condensed_df = FALSE,
                           force_from_bt = FALSE) {

  link_info <- extract_link_info()

  if (force_from_bt == FALSE) {
    version_github <- extract_github_version()
    decision <- import_new(link_info$version_bt, version_github)
    if (decision == 1) {
      force_from_bt <- TRUE
    }
    if (decision == 3) {
      stop("Cancelling data import.")
    }
  }

  if (force_from_bt) {
    paste0("Downloading primary data (version: ",
           link_info$version_bt,
           ") from the Bundestag website") %>%
      message()
    data_version <- link_info$version_bt
    list_raw <- import_list_raw(link_info$href)
    list_clean <- restructure_list(list_raw)
    attr(list_clean, "version") <- data_version
  } else {
    paste0("Downloading pre-processed data (version: ",
           version_github,
           ") from GitHub") %>%
      message()
    data_version <- version_github
    list_clean <- extract_github_list()
  }

  if (condensed_df){
    members <- to_condensed_df(list_clean, data_version)
  }
  else {
    members <- list_clean
  }

  members

}

# SUBFUNCTIONS -----------------------------------------------------------------

extract_link_info <- function() {

  url <-"https://www.bundestag.de/services/opendata"
  url_parsed <- xml2::read_html(url)

  node_attrs <- url_parsed %>%
    rvest::html_elements(css = ".bt-link-dokument") %>%
    rvest::html_attrs()

  pattern_title <- "Stammdaten aller Abgeordneten seit 1949 im XML-Format"

  for (i in seq_along(node_attrs)){
    title <- node_attrs[[i]][["title"]]
    if (grepl(pattern = pattern_title, x = title)) {
      pattern_data_version <- paste0(
        "[[:digit:]]{2}", # d
        "\\.",
        "[[:digit:]]{2}", # m
        "\\.",
        "[[:digit:]]{4}" # Y
      )
      matches <- regexpr(pattern = pattern_data_version,
                         text = title) # digits
      data_version <- regmatches(title, m = matches) %>%
        as.Date(format = "%d.%m.%Y")
      href <- paste0(
        "https://www.bundestag.de",
        node_attrs[[i]][["href"]]
      )
      break
    }
  }
  if (!exists("data_version")) {
    stop("Unable to locate XML file.")
  }
  link_info <- list(version_bt = data_version,
                    href = href)
  link_info
}


github_storage_url <- function(branch = "main") {
  storage_url <- paste0("https://github.com/jolyphil/btmembers/raw/",
                branch,
                "/storage/")
  storage_url
}


extract_github_version <- function() {
  version_url <- paste0(github_storage_url(), "data_version.rds")
  data_version <- url(version_url) %>%
    readRDS()
  data_version
}


extract_github_list <- function() {
  list_url <- paste0(github_storage_url(), "members_list.rds")
  members_list <- url(list_url) %>%
    readRDS()
  members_list
}

import_new <- function(version_bt, version_github){
  if (version_bt > version_github) {
    decision <- utils::menu(
      title = "A new version of the data is available on the Bundestag website, but it has not been tested yet. Would you like to import this new version anyway?",
      choices =c("Yes, try importing the new version of the data from the Bundestag website.",
                 "No, import the preprocessed data from GitHub.",
                 "Cancel."))
  } else {
    decision <- 2
  }
    decision
}

import_list_raw <- function(href){
  temp <- tempfile()
  download.file(href, temp)
  message("Converting XML file to list...")
  list_raw <- unz(temp, "MDB_STAMMDATEN.XML") %>% # Unzip XML data
    xml2::read_xml() %>%
    xml2::as_list() %>%
    `[[`("DOCUMENT") %>% # Select first nested list
    `[`(-c(1)) # Delete first element of the list "VERSION"
  # All other siblings are named "MDB", representing one member
  message("Done.")
  list_raw
}

restructure_list <- function(list_raw) {

  message("Restructuring list...")

  tbl_mdb_list <- list_raw %>%

    # Create a tibble with one column, where each row (a nested list) contains
    # all the information of one MDB
    tibble::as_tibble_col() %>%

    # Unnest each row (each list representing an MDB) and turn list elements
    # into columns: ID, NAMEN, BIOGRAPHISCHE_ANGABEN, WAHLPERIODEN
    tidyr::unnest_wider(.data$value)


  namen <- tbl_mdb_list %>%

    dplyr::select(.data$ID, .data$NAMEN) %>%

    # Take column "NAMEN" and unnest list within each row by adding rows
    # creating multiple entries for the same ID
    tidyr::unnest_longer(.data$NAMEN, indices_include = FALSE) %>%

    # Unnest each row and turn list elements into cols: NACHNAME, VORNAME, ...
    tidyr::unnest_wider(.data$NAMEN) %>%

    # Apply following function to all rows: Convert null elements to NA and then
    # unlist all elements
    dplyr::mutate(dplyr::across(.fns = unlist_all)) %>%

    # Recode date variables
    dplyr::mutate(dplyr::across(.cols = c("HISTORIE_VON", "HISTORIE_BIS"),
                                .fns = ~as.Date(.x, format = "%d.%m.%Y"))) %>%

    dplyr::relocate(.data$ID,
                    .data$NACHNAME,
                    .data$VORNAME,
                    .data$ORTSZUSATZ,
                    .data$ADEL,
                    .data$PRAEFIX,
                    .data$ANREDE_TITEL,
                    .data$AKAD_TITEL,
                    .data$HISTORIE_VON,
                    .data$HISTORIE_BIS)


  bio <- tbl_mdb_list %>%
    dplyr::select(.data$ID, .data$BIOGRAFISCHE_ANGABEN) %>%
    tidyr::unnest_wider(.data$BIOGRAFISCHE_ANGABEN) %>%
    dplyr::mutate(dplyr::across(.fns = unlist_all)) %>%
    dplyr::mutate(dplyr::across(.cols = c("GEBURTSDATUM", "STERBEDATUM"),
                                .fns = ~as.Date(.x, format = "%d.%m.%Y"))) %>%
    dplyr::relocate(.data$ID,
                    .data$GEBURTSDATUM,
                    .data$GEBURTSORT,
                    .data$GEBURTSLAND,
                    .data$STERBEDATUM,
                    .data$GESCHLECHT,
                    .data$FAMILIENSTAND,
                    .data$RELIGION,
                    .data$BERUF,
                    .data$PARTEI_KURZ,
                    .data$VITA_KURZ)

  tbl_wp_list <- tbl_mdb_list %>%
    dplyr::select(.data$ID, .data$WAHLPERIODEN) %>%
    tidyr::unnest_longer(.data$WAHLPERIODEN, indices_include = FALSE) %>%
    tidyr::unnest_wider(.data$WAHLPERIODEN)

  wp_temp <- tbl_mdb_list %>%
    dplyr::select(.data$ID, .data$WAHLPERIODEN) %>%
    tidyr::unnest_longer(.data$WAHLPERIODEN, indices_include = FALSE) %>%
    tidyr::unnest_wider(.data$WAHLPERIODEN) %>%
    dplyr::mutate(dplyr::across(.cols = c("ID",
                                          "WP",
                                          "MDBWP_VON",
                                          "MDBWP_BIS",
                                          "WKR_NUMMER",
                                          "WKR_LAND",
                                          "MANDATSART",
                                          "LISTE",
                                          "WKR_NAME"),
                                .fns = unlist_all)) %>%
    dplyr::mutate(dplyr::across(.cols = c("MDBWP_VON", "MDBWP_BIS"),
                                .fns = ~as.Date(.x, format = "%d.%m.%Y"))) %>%
    dplyr::mutate(dplyr::across(.cols = c("WP", "WKR_NUMMER"),
                                .fns = ~as.integer(.x)))

  wp <- wp_temp %>%
    dplyr::select(-.data$INSTITUTIONEN) %>%
    dplyr::relocate(.data$ID,
                    .data$WP,
                    .data$MDBWP_VON,
                    .data$MDBWP_BIS,
                    .data$WKR_NUMMER,
                    .data$WKR_NAME,
                    .data$WKR_LAND,
                    .data$LISTE,
                    .data$MANDATSART)

  inst <- wp_temp %>%
    dplyr::select(.data$ID,
                  .data$WP,
                  .data$MDBWP_VON,
                  .data$MDBWP_BIS,
                  .data$INSTITUTIONEN) %>%
    tidyr::unnest_longer(.data$INSTITUTIONEN, indices_include = FALSE) %>%
    tidyr::unnest_wider(.data$INSTITUTIONEN) %>%
    dplyr::mutate(dplyr::across(.fns = unlist_all)) %>%
    dplyr::mutate(dplyr::across(.cols = c("MDBINS_VON",
                                          "MDBINS_BIS",
                                          "FKTINS_VON",
                                          "FKTINS_BIS"),
                                .fns = ~as.Date(.x, format = "%d.%m.%Y"))) %>%
    dplyr::mutate(MDBINS_VON = dplyr::if_else(is.na(.data$MDBINS_VON),
                                              .data$MDBWP_VON,
                                              .data$MDBINS_VON),
                  MDBINS_BIS = dplyr::if_else(is.na(.data$MDBINS_BIS),
                                              .data$MDBWP_BIS,
                                              .data$MDBINS_BIS),
                  FKTINS_VON = dplyr::if_else(!is.na(.data$FKT_LANG) & is.na(.data$FKTINS_VON),
                                              .data$MDBINS_VON,
                                              .data$FKTINS_VON),
                  FKTINS_BIS = dplyr::if_else(!is.na(.data$FKT_LANG) & is.na(.data$FKTINS_BIS),
                                              .data$MDBINS_BIS,
                                              .data$FKTINS_BIS)) %>%
    dplyr::select(-.data$MDBWP_VON, -.data$MDBWP_BIS)

  list_clean <- list(namen = namen,
                     bio = bio,
                     wp = wp,
                     inst = inst) %>%
    lapply(function(x){names(x) <- tolower(names(x)); x}) %>%
    lapply(add_labels)

  message("Done.")

  list_clean
}


unlist_all <- function(x) {
  x[sapply(x, is.null)] <- NA
  unlist(x)
}


add_labels <- function(df){
  for (i in seq_along(df)){
    label <- var_attr$label[var_attr$varname == names(df)[i]]
    attr(df[[i]], "label") <- label
  }
  df
}

to_condensed_df <- function(list_clean, data_version){

  message("Converting list to data frame...")

  namen <- list_clean$namen %>%
    dplyr::group_by(.data$id) %>%
    dplyr::slice_max(.data$historie_von) %>%
    dplyr::ungroup() %>%
    dplyr::select(-.data$historie_von, -.data$historie_bis)

  frak_temp <- list_clean$inst %>%
    dplyr::filter(.data$insart_lang == "Fraktion/Gruppe") %>%
    dplyr::select(.data$id,
                  .data$wp,
                  .data$ins_lang,
                  .data$mdbins_von,
                  .data$mdbins_bis) %>%
    dplyr::rename(fraktion = .data$ins_lang) %>%
    dplyr::distinct() %>%
    dplyr::group_by(.data$id, .data$wp) %>%
    dplyr::add_count(name = "fraktion_n")

  wp_max <- max(frak_temp$wp)

  # If member was member of multiple factions in the same WP, select WP in which
  # he/she spent most time
  frak_multi <- frak_temp %>%
    dplyr::filter(.data$fraktion_n > 1) %>%
    # Adjust end date to date of data_version if current WP.
    dplyr::mutate(mdbins_bis = dplyr::if_else(is.na(.data$mdbins_bis) & .data$wp == wp_max,
                                              data_version,
                                              .data$mdbins_bis),
                  frak_dauer = .data$mdbins_bis - .data$mdbins_von) %>%
    dplyr::group_by(.data$id, .data$wp, .data$fraktion) %>%
    dplyr::summarize(frak_dauer_sum = sum(.data$frak_dauer)) %>%
    dplyr::group_by(.data$id, .data$wp) %>%
    dplyr::slice_max(.data$frak_dauer_sum) %>%
    dplyr::select(.data$id, .data$wp, .data$fraktion)

  frak <- frak_temp %>%
    dplyr::filter(.data$fraktion_n == 1) %>%
    dplyr::select(.data$id, .data$wp, .data$fraktion) %>%
    dplyr::bind_rows(frak_multi) %>%
    dplyr::ungroup()

  condensed_df <- namen %>%
    dplyr::left_join(list_clean$bio, by = "id") %>%
    dplyr::left_join(list_clean$wp, by = "id") %>%
    dplyr::left_join(frak, by = c("id", "wp"))

  message("Done.")

  condensed_df
}
