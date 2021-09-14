update_data <- function(force = FALSE){

  link_info <- extract_link_info()
  members <- import_members(force_from_bt = force)

  saveRDS(link_info$version_bt, file.path("storage", "data_version.rds"))
  saveRDS(members, file.path("storage", "mdb_list.rds"))
  # gen_data_doc(members)
  # render_codebook()
  # paste0("members_", attr(members, "version"), ".csv") %>%
  #   file.path("csv", .) %>%
  #   write.csv(members, file = .)
}
