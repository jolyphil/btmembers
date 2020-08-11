convert_to_df <- function(members_list, varlists){
  pb <- members_list %>%
    length() %>%
    dplyr::progress_estimated()
  message("Converting list to data frame...")
  members <- purrr::map_dfr(members_list, one_member_list_to_df, varlists, pb)
  message("\nDone.")
  members
}

one_member_list_to_df <- function(one_member_list, varlists, pb) {
  pb$tick()$print()

  name_vars_df <- one_member_list %>%
    extract_most_recent_name(varlists$name)
  bio_vars_df <- one_member_list[["BIOGRAFISCHE_ANGABEN"]] %>%
    extract_group_vars(varlists$bio)
  parlterm_vars_df <- one_member_list %>%
    combine_parlterm_vars(varlists$parlterm)
  one_member_df <- extract_one_value("ID", "id", one_member_list) %>%
    dplyr::bind_cols(name_vars_df,
              bio_vars_df) %>%
    dplyr::left_join(parlterm_vars_df, by = "id")
  one_member_df
}

extract_most_recent_name <- function(one_member_list, varlist) {
  name_vars_df <- one_member_list[["NAMEN"]] %>%
    purrr::map_dfr(extract_group_vars, varlist) %>%
    dplyr::mutate(historie_von = as.Date(historie_von, format = "%d.%m.%Y")) %>%
    dplyr::filter(historie_von == max(historie_von))
  name_vars_df
}

combine_parlterm_vars <- function(one_member_list, varlist) {
  parlterm_vars_df <- one_member_list[["WAHLPERIODEN"]] %>%
    purrr::map_dfr(extract_group_vars, varlist)
  id <- extract_one_value("ID", "id", one_member_list)[["id"]] %>%
    rep(times = nrow(parlterm_vars_df))
  parlterm_vars_df <- parlterm_vars_df %>%
    dplyr::bind_cols(id = id)
  parlterm_vars_df
}

extract_group_vars <- function(parent_list, varlist) {
  group_vars_df <- purrr::map2_dfc(varlist$listnames,
                                   varlist$varnames,
                                   extract_one_value,
                                   parent_list)
  group_vars_df
}

extract_one_value <- function(listname, varname, parent_list){
  one_value <- ifelse(is.null(parent_list[[listname]]),
                      "",
                      as.character(parent_list[[listname]]))
  one_value_df <- tibble::tibble(one_value)
  names(one_value_df) <- varname
  one_value_df
}
