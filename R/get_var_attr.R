get_var_attr <- function() {
  
  # Note on variables names:
  #   * Max length: 12 chr
  #   * No special character
  #   * Lower case
    
  var_attr <- tibble::tibble(
    # ID --------------------------------------------------------------
      sourcename = "ID",
      varname = "id"
      #,
      #label = "Identification number",
      #description = "Identification number of the member, format: 8 digits"
    ) %>%
    # Name ------------------------------------------------------------
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
      "formaddress"
    ) %>%
    add_row(
      "AKAD_TITEL",
      "acadtitle"
    ) %>%
    add_row(
      "HISTORIE_VON",
      "histfrom"
    ) %>%
    # Bio -------------------------------------------------------------
    add_row(
      "GEBURTSDATUM",
      "birthdate"
    ) %>%
    add_row(
      "GEBURTSORT",
      "birthplace"
    ) %>%
    add_row(
      "GEBURTSLAND",
      "birthcountry",
    ) %>%
    add_row(
      "STERBEDATUM",
      "deathdate"
    ) %>%
    add_row(
      "GESCHLECHT",
      "gender"
    ) %>%
    add_row(
      "FAMILIENSTAND",
      "maristatus"
    ) %>%
    add_row(
      "RELIGION",
      "religion"
    ) %>%
    add_row(
      "BERUF",
      "occup"
    ) %>%
    add_row(
      "PARTEI_KURZ",
      "party"
    ) %>%
    add_row(
      "VITA_KURZ",
      "cv"
    ) %>%
    add_row(
      "VEROEFFENTLICHUNGSPFLICHTIGES",
      "declaration"
    ) %>%
    # Parliamentary term ----------------------------------------------
    add_row(
      "WP",
      "termnum"
    ) %>%
    add_row(
      "MDBWP_VON",
      "termstart"
    ) %>%
    add_row(
      "MDBWP_BIS",
      "termend"
    ) %>%
    add_row(
      "WKR_NUMMER",
      "distnum"
    ) %>%
    add_row(
      "WKR_NAME",
      "distname"
    ) %>%
    add_row(
      "WKR_LAND",
      "diststate"
    ) %>%
    add_row(
      "LISTE",
      "list"
    ) %>%
    add_row(
      "MANDATSART",
      "mandatetype"
    )
  var_attr
}

add_row <- function(df, sourcename, varname, label, description) {
  df <- df %>%
    dplyr::bind_rows(
      tibble::tibble(
        sourcename = sourcename,
        varname = varname
        #,
        #label = label,
        #description = description
      )
    )
}
