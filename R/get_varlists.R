get_varlists <- function(){
  varlist_name <-  c(
    "NACHNAME"	,
    "VORNAME",
    "ADEL",
    "PRAEFIX",
    "ANREDE_TITEL",
    "AKAD_TITEL",
    "HISTORIE_VON"
  )
  varlist_bio <- c(
    "GEBURTSDATUM",
    "GEBURTSORT",
    "GEBURTSLAND",
    "STERBEDATUM",
    "GESCHLECHT",
    "FAMILIENSTAND",
    "RELIGION",
    "BERUF",
    "PARTEI_KURZ",
    "VITA_KURZ",
    "VEROEFFENTLICHUNGSPFLICHTIGES"
  )
  varlist_parlterm <- c(
    "WP",
    "MDBWP_VON",
    "MDBWP_BIS",
    "WKR_NUMMER",
    "WKR_NAME",
    "WKR_LAND",
    "LISTE",
    "MANDATSART"
  )
  var_attr <- get_var_attr()
  varlists <- list(
      name = varlist_name,
      bio = varlist_bio,
      parlterm = varlist_parlterm
    ) %>%
    purrr::map(get_recode_scheme, var_attr = var_attr)
  varlists
}

get_recode_scheme <- function(listnames, var_attr) {
  varnames <- listnames %>%
    purrr::map_chr(find_varname, var_attr = var_attr)
  recode_scheme <- tibble::tibble(listnames, varnames)
  recode_scheme
}

find_varname <- function(listname, var_attr, lang = "de") {
  if (lang == "de"){
    varname <- var_attr$varname_de[var_attr$sourcename == listname]
  }
  if (lang == "en"){
    varname <- var_attr$varname_en[var_attr$sourcename == listname]
  }
  varname
}
