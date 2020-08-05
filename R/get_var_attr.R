get_var_attr <- function() {

  # Note on English variables names:
  #   * Max length: 12 chr
  #   * No special character
  #   * Lower case

  var_attr <- tibble::tibble(
    # ID --------------------------------------------------------------
      sourcename = "ID",
      varname_de = "id",
      varname_en = "id",
      label_de = "Identifikationsnummer"
    ) %>%
    # Name ------------------------------------------------------------
    add_row(
      "NACHNAME",
      "nachname",
      "lastname",
      "Nachname"
    ) %>%
    add_row(
      "VORNAME",
      "vorname",
      "firstname",
      "Vorname"
    ) %>%
    add_row(
      "ADEL",
      "adel",
      "nobility",
      "Adelsprädikat"
    ) %>%
    add_row(
      "PRAEFIX",
      "praefix",
      "prefix",
      "Namenspräfix"
    ) %>%
    add_row(
      "ANREDE_TITEL",
      "anrede_titel",
      "formaddress",
      "Anrede-Titel"
    ) %>%
    add_row(
      "AKAD_TITEL",
      "akad_titel",
      "acadtitle",
      "Akademischer Titel"
    ) %>%
    add_row(
      "HISTORIE_VON",
      "historie_von",
      "histfrom",
      "Historie zu den Namensbestandteilen, gültig von"
    ) %>%
    # Bio -------------------------------------------------------------
    add_row(
      "GEBURTSDATUM",
      "geburtsdatum",
      "birthdate",
      "Geburtsdatum"
    ) %>%
    add_row(
      "GEBURTSORT",
      "geburtsort",
      "birthplace",
      "Geburtsort"
    ) %>%
    add_row(
      "GEBURTSLAND",
      "geburtsland",
      "birthcountry",
      "Geburtsland"
    ) %>%
    add_row(
      "STERBEDATUM",
      "sterbedatum",
      "deathdate",
      "Sterbedatum"
    ) %>%
    add_row(
      "GESCHLECHT",
      "geschlecht",
      "gender",
      "Geschlecht"
    ) %>%
    add_row(
      "FAMILIENSTAND",
      "familienstand",
      "maristatus",
      "Familienstand"
    ) %>%
    add_row(
      "RELIGION",
      "religion",
      "religion",
      "Religion"
    ) %>%
    add_row(
      "BERUF",
      "beruf",
      "occup",
      "Beruf"
    ) %>%
    add_row(
      "PARTEI_KURZ",
      "partei_kurz",
      "party",
      "Parteizugehörigkeit, kurzform"
    ) %>%
    add_row(
      "VITA_KURZ",
      "vita_kurz",
      "cv",
      "Kurzbiografie des Abgeordneten (nur aktuelle Wahlperiode)"
    ) %>%
    add_row(
      "VEROEFFENTLICHUNGSPFLICHTIGES",
      "veroeffentlichungspflichtiges",
      "declaration",
      "Veröffentlichungspflichtige Angaben (nur aktuelle Wahlperiode)"
    ) %>%
    # Parliamentary term ----------------------------------------------
    add_row(
      "WP",
      "wp",
      "termnum",
      "Nummer der Wahlperiode"
    ) %>%
    add_row(
      "MDBWP_VON",
      "mdbwp_von",
      "termstart",
      "Beginn der Wahlperiodenzugehörigkeit"
    ) %>%
    add_row(
      "MDBWP_BIS",
      "mdbwp_bis",
      "termend",
      "Ende der Wahlperiodenzugehörigkeit"
    ) %>%
    add_row(
      "WKR_NUMMER",
      "wkr_nummer",
      "distnum",
      "Nummer des Wahlkreises"
    ) %>%
    add_row(
      "WKR_NAME",
      "wkr_name",
      "distname",
      "Wahlkreisname"
    ) %>%
    add_row(
      "WKR_LAND",
      "wkr_land",
      "diststate",
      "Bundesland des Wahlkreises"
    ) %>%
    add_row(
      "LISTE",
      "liste",
      "list",
      "Liste"
    ) %>%
    add_row(
      "MANDATSART",
      "mandatsart",
      "mandatetype",
      "Art des Mandates"
    )
  var_attr
}

add_row <- function(df,
                    sourcename,
                    varname_de,
                    varname_en,
                    label_de) {
  df <- df %>%
    dplyr::bind_rows(
      tibble::tibble(
        sourcename = sourcename,
        varname_de = varname_de,
        varname_en = varname_en,
        label_de = label_de
      )
    )
}
