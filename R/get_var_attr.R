get_var_attr <- function() {

  # Note on English variables names:
  #   * Max length: 12 chr
  #   * No special character
  #   * Lower case

  var_attr <- tibble::tibble(
    # ID --------------------------------------------------------------
      sourcename = "ID",
      varname_de = "id",
      varname_en = "id"
      #,
      #label = "Identification number",
      #description = "Identification number of the member, format: 8 digits"
    ) %>%
    # Name ------------------------------------------------------------
    add_row(
      "NACHNAME",
      "nachname",
      "lastname"
    ) %>%
    add_row(
      "VORNAME",
      "vorname",
      "firstname"
    ) %>%
    add_row(
      "ADEL",
      "adel",
      "nobility"
    ) %>%
    add_row(
      "PRAEFIX",
      "praefix",
      "prefix"
    ) %>%
    add_row(
      "ANREDE_TITEL",
      "anrede_titel",
      "formaddress"
    ) %>%
    add_row(
      "AKAD_TITEL",
      "akad_titel",
      "acadtitle"
    ) %>%
    add_row(
      "HISTORIE_VON",
      "historie_von",
      "histfrom"
    ) %>%
    # Bio -------------------------------------------------------------
    add_row(
      "GEBURTSDATUM",
      "geburtsdatum",
      "birthdate"
    ) %>%
    add_row(
      "GEBURTSORT",
      "geburtsort",
      "birthplace"
    ) %>%
    add_row(
      "GEBURTSLAND",
      "geburtsland",
      "birthcountry",
    ) %>%
    add_row(
      "STERBEDATUM",
      "sterbedatum",
      "deathdate"
    ) %>%
    add_row(
      "GESCHLECHT",
      "geschlecht",
      "gender"
    ) %>%
    add_row(
      "FAMILIENSTAND",
      "familienstand",
      "maristatus"
    ) %>%
    add_row(
      "RELIGION",
      "religion",
      "religion"
    ) %>%
    add_row(
      "BERUF",
      "beruf",
      "occup"
    ) %>%
    add_row(
      "PARTEI_KURZ",
      "partei_kurz",
      "party"
    ) %>%
    add_row(
      "VITA_KURZ",
      "vita_kurz",
      "cv"
    ) %>%
    add_row(
      "VEROEFFENTLICHUNGSPFLICHTIGES",
      "veroeffentlichungspflichtiges",
      "declaration"
    ) %>%
    # Parliamentary term ----------------------------------------------
    add_row(
      "WP",
      "wp",
      "termnum"
    ) %>%
    add_row(
      "MDBWP_VON",
      "mdbwp_von",
      "termstart"
    ) %>%
    add_row(
      "MDBWP_BIS",
      "mdbwp_bis",
      "termend"
    ) %>%
    add_row(
      "WKR_NUMMER",
      "wkr_nummer",
      "distnum"
    ) %>%
    add_row(
      "WKR_NAME",
      "wkr_name",
      "distname"
    ) %>%
    add_row(
      "WKR_LAND",
      "wkr_land",
      "diststate"
    ) %>%
    add_row(
      "LISTE",
      "liste",
      "list"
    ) %>%
    add_row(
      "MANDATSART",
      "mandatsart",
      "mandatetype"
    )
  var_attr
}

add_row <- function(df,
                    sourcename,
                    varname_de,
                    varname_en,
                    label,
                    description) {
  df <- df %>%
    dplyr::bind_rows(
      tibble::tibble(
        sourcename = sourcename,
        varname_de = varname_de,
        varname_en = varname_en
        #,
        #label = label,
        #description = description
      )
    )
}
