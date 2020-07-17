# ______________________________________________________________________________
# Project: Bundestag_members
# Task: Download, unzip, convert, and load data on Members of the Bundestag
# Author:	Philippe Joly, WZB & HU-Berlin
# ______________________________________________________________________________

# Load packages ====
library(dplyr)
library(purrr)
library(xml2) # Parse XML files

# ______________________________________________________________________________
# Download data, unzip, convert to list, and load ====

# URL to the ZIP file containing the XML data on members of the Bundestag
url <- "https://www.bundestag.de/resource/blob/472878/a007a4c078baf271d72b61eddb5eeeb9/MdB-Stammdaten-data.zip"

#temp <- tempfile() # Change for temporary file
temp <- "temp/temp.zip"

# Download ZIP file containing data on members of the Bundestag in XML format
download.file(url, temp) 

members_list <- unz(temp, "MDB_STAMMDATEN.XML") %>% # Unzip XML data
  read_xml() %>% 
  as_list() %>% 
  `[[`("DOCUMENT") %>% # Select first nested list 
  `[`(-c(1)) # Delete first element of the list "VERSION"
             # All other siblings are named "MDB", representing one member 

# ______________________________________________________________________________
# Generate dataframe of members of the Bundestag ====

# _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
# Functions ====

# -------------------------------------------------------------------------
# Combines multiple variables for one member

list_to_df <- function(member) {
  members <- extract_one_value("ID", "id", member)
  name_vars_df <- extract_most_recent_name(member)
  bio_vars_df <- extract_bio_vars(member)
  members <- bind_cols(name_vars_df, 
                       bio_vars_df)
  members
}


# -------------------------------------------------------------------------
# Returns a 1-row dataframe with most recent name variables for one member

extract_most_recent_name <- function(member) {
  name_vars_df <- map_dfr(member[["NAMEN"]], extract_name_vars) %>%
    mutate(history_from = as.Date(history_from, format = "%d.%m.%Y")) %>%
    filter(history_from == max(history_from)) %>%
    select(-history_from)
  name_vars_df
}

# -------------------------------------------------------------------------
# Returns a 1-row dataframe with biographical variables for one member

extract_bio_vars <- function(member){
  listnames <- c("GEBURTSDATUM",
                 "GEBURTSORT",
                 "GEBURTSLAND",
                 "STERBEDATUM",
                 "GESCHLECHT",
                 "FAMILIENSTAND",
                 "RELIGION",
                 "BERUF",
                 "PARTEI_KURZ",
                 "VITA_KURZ",
                 "VEROEFFENTLICHUNGSPFLICHTIGES")
  varnames <- c("birthdate",
                "birthplace",
                "birthcountry",
                "deathdate",
                "gender",
                "maritalstatus",
                "religion",
                "occupation",
                "party",
                "cv",
                "declaration")
  bio_vars_df <- map2_dfc(listnames, 
                              varnames, 
                              extract_one_value, 
                              member[["BIOGRAFISCHE_ANGABEN"]])
  bio_vars_df
}

# -------------------------------------------------------------------------
# Return a 1-row dataframe with multiple name variables for one member

extract_name_vars <- function(name) {
  
  listnames <- c("NACHNAME",
                 "VORNAME",
                 "ADEL",
                 "PRAEFIX",
                 "ANREDE_TITEL",
                 "AKAD_TITEL",
                 "HISTORIE_VON")
  varnames <- c("lastname",
                "firstname",
                "nobility",
                "prefix",
                "form_address",
                "acad_title",
                "history_from")
  
  name_vars_df <- map2_dfc(listnames, 
                               varnames, 
                               extract_one_value, 
                               name)
  name_vars_df
}

# -------------------------------------------------------------------------
# Return a 1-row dataframe with one variable for one member

extract_one_value <- function(listname, varname, parent_list){
  one_value <- ifelse(is.null(parent_list[[listname]]),
                      "",
                      as.character(parent_list[[listname]]))
  one_value_df <- tibble(one_value)
  names(one_value_df) <- varname
  one_value_df
}

# _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
# Transform list to dataframe ====

members <- map_dfr(members_list, list_to_df)
