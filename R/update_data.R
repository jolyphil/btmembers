update_data <- function(force = FALSE){
  link_info <- extract_link_info()
  if (force == FALSE) {
    version_github <- extract_github_version()
    if (link_info$version_bt > version_github) {
      force = TRUE
    }
  }
  if (force) {
    members_list <- import_members(data_source = "Bundestag")

    render_codebook(members_list)

saveRDS(link_info$version_bt, file.path("storage", "data_version.rds"))
    saveRDS(members_list, file.path("storage", "members_list.rds"))

    condensed_df <- to_condensed_df(members_list, attr(members_list, "version"))

    write_csv_all(members_list)
    write_csv_df(condensed_df, "condensed_df")

    write_excel_all(members_list)
    write_excel_df(condensed_df, "condensed_df")

    # See R/render_codebook.R
    export_source(link_info$version_bt, file.path("csv", "source.md"))

  } else {
    message("Data is already up to date.")
  }
}

write_csv_all <- function(members_list) {
  df_names <- names(members_list)
  purrr::walk2(members_list, df_names, write_csv_df)
}

write_csv_df <- function(df, df_name) {
  filename <- paste0(df_name, ".csv")
  if (df_name == "bio") {
    df <- df |>
      dplyr::mutate(dplyr::across(.cols = c("vita_kurz",
                                            "veroeffentlichungspflichtiges"),
                                  .fns = ~gsub("\r?\n|\r", " ", .x))) # Remove line breaks
  }
  write.csv(df,
            file.path("csv", filename),
            row.names = FALSE)
}

write_excel_all <- function(members_list) {
  df_names <- names(members_list)
  purrr::walk2(members_list, df_names, write_excel_df)
}

write_excel_df <- function(df, df_name) {

  df <- df |>
    dplyr::mutate(dplyr::across(where(~ class(.x) == "Date"), as.character))

  filename <- paste0(df_name, ".xlsx")
  writexl::write_xlsx(df,
                      file.path("excel", filename))
}
