update_data <- function(force = FALSE){

  link_info <- extract_link_info()
  members_list <- import_members(force_from_bt = force)

  render_codebook(members_list)

  saveRDS(link_info$version_bt, file.path("storage", "data_version.rds"))
  saveRDS(members_list, file.path("storage", "members_list.rds"))

  write_csv_all(members_list)

  condensed_df <- to_condensed_df(members_list, attr(members_list, "version"))
  write_csv_df(condensed_df, "condensed_df")
}

write_csv_all <- function(members_list) {
  df_names <- names(members_list)
  purrr::walk2(members_list, df_names, write_csv_df)
}

write_csv_df <- function(df, df_name) {
  filename <- paste0(df_name, ".csv")
  write.csv(df, file.path("csv", filename))
}
