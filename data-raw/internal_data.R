# Variable labels ---------------------------------------------------------

get_var_attr <- function() {

  var_attr <- tibble::tibble(
    # id ----------------------------------------------------------------------
    varname = "id",
    label = "Identifikationsnummer"
  ) %>%
    # namen --------------------------------------------------------------------
  add_row(
    "nachname",
    "Nachname"
  ) %>%
    add_row(
      "vorname",
      "Vorname"
    ) %>%
    add_row(
      "ortszusatz",
      "Ortszusatz zu Nachmame, zur Unterscheidung bei Namensgleichheit"
    ) %>%
    add_row(
      "adel",
      "Adelsprädikat"
    ) %>%
    add_row(
      "praefix",
      "Namenspräfix"
    ) %>%
    add_row(
      "anrede_titel",
      "Anrede-Titel"
    ) %>%
    add_row(
      "akad_titel",
      "Akademischer Titel"
    ) %>%
    add_row(
      "historie_von",
      "Historie zu den Namensbestandteilen, gültig von"
    ) %>%
    add_row(
      "historie_bis",
      "Historie zu den Namensbestandteilen, gültig bis"
    ) %>%
    # bio ----------------------------------------------------------------------
  add_row(
    "geburtsdatum",
    "Geburtsdatum"
  ) %>%
    add_row(
      "geburtsort",
      "Geburtsort"
    ) %>%
    add_row(
      "geburtsland",
      "Geburtsland"
    ) %>%
    add_row(
      "sterbedatum",
      "Sterbedatum"
    ) %>%
    add_row(
      "geschlecht",
      "Geschlecht"
    ) %>%
    add_row(
      "familienstand",
      "Familienstand"
    ) %>%
    add_row(
      "religion",
      "Religion"
    ) %>%
    add_row(
      "beruf",
      "Beruf"
    ) %>%
    add_row(
      "partei_kurz",
      "Letzte Parteizugehörigkeit, kurzform"
    ) %>%
    add_row(
      "vita_kurz",
      "Kurzbiografie des Abgeordneten (nur aktuelle Wahlperiode)"
    ) %>%
    add_row(
      "veroeffentlichungspflichtiges",
      "Veröffentlichungspflichtige Angaben (nur aktuelle Wahlperiode)"
    ) %>%
    # wp -----------------------------------------------------------------------
  add_row(
    "wp",
    "Nummer der Wahlperiode"
  ) %>%
    add_row(
      "mdbwp_von",
      "Beginn der Wahlperiodenzugehörigkeit"
    ) %>%
    add_row(
      "mdbwp_bis",
      "Ende der Wahlperiodenzugehörigkeit"
    ) %>%
    add_row(
      "wkr_nummer",
      "Nummer des Wahlkreises"
    ) %>%
    add_row(
      "wkr_name",
      "Wahlkreisname"
    ) %>%
    add_row(
      "wkr_land",
      "Bundesland des Wahlkreises"
    ) %>%
    add_row(
      "liste",
      "Liste"
    ) %>%
    add_row(
      "mandatsart",
      "Art des Mandates"
    ) %>%
    # inst ---------------------------------------------------------------------
  add_row(
    "insart_lang",
    "Langbezeichnung der Institutionsart"
  ) %>%
    add_row(
      "ins_lang",
      "Langbezeichnung der Institution"
    ) %>%
    add_row(
      "mdbins_von",
      "Beginn der Institutionszugehörigkeit"
    ) %>%
    add_row(
      "mdbins_bis",
      "Ende der Institutionszugehörigkeit"
    ) %>%
    add_row(
      "fkt_lang",
      "Langbezeichnung der ausgeübten Funktion in einer Institution"
    ) %>%
    add_row(
      "fktins_von",
      "Beginn der Funktionsausübung in einer Institution"
    ) %>%
    add_row(
      "fktins_bis",
      "Ende der Funktionsausübung in einer Institution"
    )
  var_attr
}

add_row <- function(df,
                    varname,
                    label) {
  df <- df %>%
    dplyr::bind_rows(
      tibble::tibble(
        varname = varname,
        label = label
      )
    )
}

var_attr <- get_var_attr()


# Reference DTD file ------------------------------------------------------
# Used to test new data

ref_dtd <- readLines("data-raw/2023-03-15/MDB_STAMMDATEN.DTD")


# Save internal data ------------------------------------------------------

usethis::use_data(var_attr, ref_dtd, internal = TRUE, overwrite = TRUE)
