update_data <- function(force = FALSE){
  if(update_available() | force){
    members <- import_members()
    gen_data_doc(members)
    usethis::use_data(members, overwrite = TRUE)
    devtools::document()
    devtools::load_all()
    render_codebook()
  }
}
