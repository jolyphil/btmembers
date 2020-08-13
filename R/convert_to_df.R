convert_to_df <- function(members_list){

  pb <- progress::progress_bar$new(total = length(members_list))

  message("Converting list to data frame...")

  varlists <- list(
    name = c(
      "NACHNAME",
      "VORNAME",
      "ADEL",
      "PRAEFIX",
      "ANREDE_TITEL",
      "AKAD_TITEL",
      "HISTORIE_VON"
    ),
    bio = c(
      "GEBURTSDATUM",
      "GEBURTSORT",
      "GEBURTSLAND",
      "STERBEDATUM",
      "GESCHLECHT",
      "FAMILIENSTAND",
      "RELIGION",
      "BERUF",
      "PARTEI_KURZ",
      "VITA_KURZ",
      "VEROEFFENTLICHUNGSPFLICHTIGES"
    ),
    parlterm = c(
      "WP",
      "MDBWP_VON",
      "MDBWP_BIS",
      "WKR_NUMMER",
      "WKR_NAME",
      "WKR_LAND",
      "LISTE",
      "MANDATSART"
    )
  )

  members <- purrr::map_dfr(members_list, one_member_list_to_df, varlists, pb)
  message("\nDone.")
  members
}

one_member_list_to_df <- function(one_member_list, varlists, pb) {
  pb$tick()
  id_df <- extract_one_value("ID", one_member_list)
  name_vars_df <- one_member_list %>%
    most_recent_name(varlists$name)
  bio_vars_df <- one_member_list[["BIOGRAFISCHE_ANGABEN"]] %>%
    extract_group_vars(varlists$bio)
  parlterm_vars_df <- one_member_list %>%
    combine_parlterm_vars(varlists$parlterm, id_df)
  one_member_df <- id_df %>%
    dplyr::bind_cols(name_vars_df, bio_vars_df) %>%
    dplyr::left_join(parlterm_vars_df, by = "ID")
  one_member_df
}

most_recent_name <- function(one_member_list, varlist) {
  name_vars_df <- one_member_list[["NAMEN"]] %>%
    purrr::map_dfr(extract_group_vars, varlist)
  if (nrow(name_vars_df) > 1) {
    name_vars_df <- name_vars_df %>%
      dplyr::mutate(HISTORIE_VON = as.Date(HISTORIE_VON,
                                           format = "%d.%m.%Y")) %>%
      dplyr::filter(HISTORIE_VON == max(HISTORIE_VON))
  }
  name_vars_df <- name_vars_df %>%
    dplyr::select(-HISTORIE_VON)
  name_vars_df
}

combine_parlterm_vars <- function(one_member_list, varlist, id_df) {
  parlterm_vars_df <- one_member_list[["WAHLPERIODEN"]] %>%
    purrr::map_dfr(extract_group_vars, varlist)
  ID <- id_df[["ID"]] %>%
    rep(times = nrow(parlterm_vars_df))
  parlterm_vars_df <- parlterm_vars_df %>%
    dplyr::bind_cols(ID = ID)
  parlterm_vars_df
}

extract_group_vars <- function(parent_list, varlist) {
  group_vars_df <- purrr::map_dfc(varlist,
                                   extract_one_value,
                                   parent_list)
  group_vars_df
}

extract_one_value <- function(varname, parent_list) {
  if (length(parent_list[[varname]]) == 0) {
    one_value <- NA_character_
  } else {
    one_value <- parent_list[[varname]][[1]] %>%
      as.character()
  }
  one_value_df <- tibble::tibble(one_value)
  names(one_value_df) <- varname
  one_value_df
}
