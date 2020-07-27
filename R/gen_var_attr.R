require(dplyr)

add_row <- function(df, sourcename, varname, label, description) {
  df <- df %>%
    bind_rows(
      tibble(
        sourcename = sourcename,
        varname = varname
        #,
        #label = label,
        #description = description
      )
    )
}

var_attr <- tibble(
    sourcename = "ID",
    varname = "id"
    #,
    #label = "Identification number",
    #description = "Identification number of the member, format: 8 digits"
  ) %>%
  add_row(
    "NACHNAME",
    "lastname"
  ) %>%
  add_row(
    "VORNAME",
    "firstname"
  ) %>%
  add_row(
    "ADEL",
    "nobility"
  ) %>%
  add_row(
    "PRAEFIX",
    "prefix"
  ) %>%
  add_row(
    "ANREDE_TITEL",
    "form_address"
  ) %>%
  add_row(
    "AKAD_TITEL",
    "acad_title"
  ) %>%
  add_row(
    "HISTORIE_VON",
    "history_from"
  )