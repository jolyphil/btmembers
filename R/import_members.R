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
#' @importFrom tibble tibble


import_members <- function(one_table = FALSE,
                           force_from_bt = FALSE) {
  link_info <- extract_link_info()
  version_github <- extract_github_version()
  if (link_info$version_bt > version_github | force_from_bt) {
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

  if (one_table){
    members <- to_one_table(list_clean, data_version)
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
  xpath <- "/html/body/main/div[3]/div/div/aside/div/div[2]/div/ul/li/a"

  node_attrs <- url_parsed %>%
    rvest::html_nodes(xpath = xpath) %>%
    rvest::html_attrs()

  pattern_title <- "Stammdaten aller Abgeordneten seit 1949 im XML-Format"

  for (i in seq_along(node_attrs)){
    title <- node_attrs[[i]][["title"]]
    if (stringr::str_detect(title, pattern_title)) {
      pattern_data_version <- paste0(
        "(?<=Stand[:blank:])", # Preceeded by
        "[:digit:]{2}", # d
        "\\.",
        "[:digit:]{2}", # m
        "\\.",
        "[:digit:]{4}" # Y
      )
      data_version <- title %>%
        stringr::str_extract(pattern_data_version) %>%
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


github_storage_url <- function(branch = "develop") {
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
    tidyr::unnest_wider(value)


  namen <- tbl_mdb_list %>%

    dplyr::select("ID", "NAMEN") %>%

    # Take column "NAMEN" and unnest list within each row by adding rows
    # creating multiple entries for the same ID
    tidyr::unnest_longer(NAMEN, indices_include = FALSE) %>%

    # Unnest each row and turn list elements into cols: NACHNAME, VORNAME, ...
    tidyr::unnest_wider(NAMEN) %>%

    # Apply following function to all rows: Convert null elements to NA and then
    # unlist all elements
    dplyr::mutate(dplyr::across(.fns = unlist_all)) %>%

    # Recode date variables
    dplyr::mutate(dplyr::across(.cols = c("HISTORIE_VON", "HISTORIE_BIS"),
                                .fns = ~as.Date(.x, format = "%d.%m.%Y"))) %>%

    dplyr::relocate(ID,
                    NACHNAME,
                    VORNAME,
                    ORTSZUSATZ,
                    ADEL,
                    PRAEFIX,
                    ANREDE_TITEL,
                    AKAD_TITEL,
                    HISTORIE_VON,
                    HISTORIE_BIS)


  bio <- tbl_mdb_list %>%
    dplyr::select("ID", "BIOGRAFISCHE_ANGABEN") %>%
    tidyr::unnest_wider(BIOGRAFISCHE_ANGABEN) %>%
    dplyr::mutate(dplyr::across(.fns = unlist_all)) %>%
    dplyr::mutate(dplyr::across(.cols = c("GEBURTSDATUM", "STERBEDATUM"),
                                .fns = ~as.Date(.x, format = "%d.%m.%Y"))) %>%
    dplyr::relocate(ID,
                    GEBURTSDATUM,
                    GEBURTSORT,
                    GEBURTSLAND,
                    STERBEDATUM,
                    GESCHLECHT,
                    FAMILIENSTAND,
                    RELIGION,
                    BERUF,
                    PARTEI_KURZ,
                    VITA_KURZ,
                    VEROEFFENTLICHUNGSPFLICHTIGES)

  tbl_wp_list <- tbl_mdb_list %>%
    dplyr::select("ID", "WAHLPERIODEN") %>%
    tidyr::unnest_longer(WAHLPERIODEN, indices_include = FALSE) %>%
    tidyr::unnest_wider(WAHLPERIODEN)

  wp_temp <- tbl_mdb_list %>%
    dplyr::select("ID", "WAHLPERIODEN") %>%
    tidyr::unnest_longer(WAHLPERIODEN, indices_include = FALSE) %>%
    tidyr::unnest_wider(WAHLPERIODEN) %>%
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
    dplyr::select(-INSTITUTIONEN) %>%
    dplyr::relocate(ID,
                    WP,
                    MDBWP_VON,
                    MDBWP_BIS,
                    WKR_NUMMER,
                    WKR_NAME,
                    WKR_LAND,
                    LISTE,
                    MANDATSART)

  inst <- wp_temp %>%
    dplyr::select(ID, WP, MDBWP_VON, MDBWP_BIS, INSTITUTIONEN) %>%
    tidyr::unnest_longer(INSTITUTIONEN, indices_include = FALSE) %>%
    tidyr::unnest_wider(INSTITUTIONEN) %>%
    dplyr::mutate(dplyr::across(.fns = unlist_all)) %>%
    dplyr::mutate(dplyr::across(.cols = c("MDBINS_VON",
                                          "MDBINS_BIS",
                                          "FKTINS_VON",
                                          "FKTINS_BIS"),
                                .fns = ~as.Date(.x, format = "%d.%m.%Y"))) %>%
    dplyr::mutate(MDBINS_VON = dplyr::if_else(is.na(MDBINS_VON),
                                              MDBWP_VON,
                                              MDBINS_VON),
                  MDBINS_BIS = dplyr::if_else(is.na(MDBINS_BIS),
                                              MDBWP_BIS,
                                              MDBINS_BIS),
                  FKTINS_VON = dplyr::if_else(!is.na(FKT_LANG) & is.na(FKTINS_VON),
                                               MDBINS_VON,
                                               FKTINS_VON),
                  FKTINS_BIS = dplyr::if_else(!is.na(FKT_LANG) & is.na(FKTINS_BIS),
                                               MDBINS_BIS,
                                               FKTINS_BIS)) %>%
    dplyr::select(-MDBWP_VON, -MDBWP_BIS)

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
  var_attr <- get_var_attr()
  for (i in seq_along(df)){
    label <- var_attr$label[var_attr$varname == names(df)[i]]
    attr(df[[i]], "label") <- label
  }
  df
}

to_one_table <- function(list_clean, data_version){

  message("Converting list to data frame...")

  namen <- list_clean$namen %>%
    dplyr::group_by(id) %>%
    dplyr::slice_max(historie_von) %>%
    dplyr::ungroup() %>%
    dplyr::select(-historie_von, -historie_bis)

  frak_temp <- list_clean$inst %>%
    dplyr::filter(insart_lang == "Fraktion/Gruppe") %>%
    dplyr::select(id, wp, ins_lang, mdbins_von, mdbins_bis) %>%
    dplyr::rename(fraktion = ins_lang) %>%
    dplyr::distinct() %>%
    dplyr::group_by(id, wp) %>%
    dplyr::add_count(name = "fraktion_n")

  wp_max <- max(frak_temp$wp)

  # If member was member of multiple factions in the same WP, select WP in which
  # he/she spent most time
  frak_multi <- frak_temp %>%
    dplyr::filter(fraktion_n > 1) %>%
    # Adjust end date to date of data_version if current WP.
    dplyr::mutate(mdbins_bis = dplyr::if_else(is.na(mdbins_bis) & wp == wp_max,
                                              data_version,
                                              mdbins_bis),
                  frak_dauer = mdbins_bis - mdbins_von) %>%
    dplyr::group_by(id, wp, fraktion) %>%
    dplyr::summarize(frak_dauer_sum = sum(frak_dauer)) %>%
    dplyr::group_by(id, wp) %>%
    dplyr::slice_max(frak_dauer_sum) %>%
    dplyr::select(id, wp, fraktion)

  frak <- frak_temp %>%
    dplyr::filter(fraktion_n == 1) %>%
    dplyr::select(id, wp, fraktion) %>%
    dplyr::bind_rows(frak_multi) %>%
    dplyr::ungroup()

  one_table <- namen %>%
    dplyr::left_join(list_clean$bio, by = "id") %>%
    dplyr::left_join(list_clean$wp, by = "id") %>%
    dplyr::left_join(frak, by = c("id", "wp"))

  message("Done.")

  one_table
}
