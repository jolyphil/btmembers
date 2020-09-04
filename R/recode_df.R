recode_df <- function(members_df, data_version){
  attr(members_df, "version") <- data_version
  names(members_df) <- names(members_df) %>%
    tolower()

  members_df <- members_df %>%
    dplyr::mutate(dplyr::across(c(geburtsdatum,
                                  sterbedatum,
                                  mdbwp_von,
                                  mdbwp_bis),
                                as.Date,
                                format = "%d.%m.%Y")) %>%
    dplyr::mutate(dplyr::across(c(wp, wkr_nummer), as.integer)) %>%
    # recode_geburtsland() %>%
    add_labels()

  members_df
}

recode_geburtsland <- function(members_df){
  members_df <- members_df %>%
    dplyr::mutate(geburtsland = dplyr::case_when(
      is.na(geburtsland) ~ "Deutschland",
      # Prepare recode for special cases ---------------------------------------
      geburtsland == "(damalige) CSR" & geburtsort == "Neurettendorf/ Krs.Königinhof,später Krs.Trautenau" ~ "Tschechien",
      geburtsland == "CSFR" & geburtsort == "Prag" ~ "Tschechien",
      geburtsland == "CSFR" & geburtsort == "Schluckenau" ~ "Tschechien",
      geburtsland == "CSSR" & geburtsort == "Bratislava / Preßburg" ~ "Slowakei",
      geburtsland == "CSSR" & geburtsort == "Olmütz" ~ "Tschechien",
      geburtsland == "ehem. Deutsch-Ost-Afrika" & geburtsort == "Gare" ~ "Tansania",
      geburtsland == "Jugoslawien" & geburtsort == "Altsiwatz" ~ "Serbien",
      geburtsland == "Jugoslawien" & geburtsort == "Boroc" ~ "Serbien",
      geburtsland == "Jugoslawien" & geburtsort == "Parabutsch" ~ "Serbien",
      geburtsland == "Perú" & geburtsort == "Chiclayo" ~ "Peru",
      geburtsland == "Südwestafrika" & geburtsort == "Keetmanshoop" ~ "Namibia",
      geburtsland == "Tschechoslowakei" & geburtsort == "Groß-Ullersdorf" ~ "Tschechien",
      geburtsland == "Tschechoslowakei" & geburtsort == "Prag" ~ "Tschechien",
      TRUE ~ geburtsland)) %>%
    dplyr::mutate(geburtsland = countrycode::countrycode(
      geburtsland,
      origin = "country.name.de",
      destination = "iso3c"))
  members_df
}

recode_factors <- function(members_df){
  members_df <- members_df %>%
    dplyr::mutate(geschlecht = ordered(geschlecht,
                                       levels = c("männlich", "weiblich")))
  members_df
}

add_labels <- function(members_df){
  var_attr <- get_var_attr()
  for (i in seq_along(members_df)){
    label <- var_attr$label_de[var_attr$varname_de == names(members_df)[i]]
    attr(members_df[[i]], "label") <- label
  }
  members_df
}
