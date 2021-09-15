save_list_vars <- function(df, filename){
  variables <- c(
    purrr::map2_chr(names(df), df, var_item)
  )
  writeLines(variables, filename)
}

var_item <- function(name, var) {
  var_item <- paste0(
    "#'    * `",
    name,
    "`",
    ": _",
    attr(var, "label"),
    "_"
  )
}

# save_list_vars(l1$namen, file.path("temp", "namen.txt"))
# save_list_vars(l1$bio, file.path("temp", "bio.txt"))
# save_list_vars(l1$wp, file.path("temp", "wp.txt"))
# save_list_vars(l1$inst, file.path("temp", "inst.txt"))
