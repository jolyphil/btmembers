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
# Transform list to dataframe ====

# _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
# Functions ====

list_to_df <- function(member) {
  names_df <- most_recent_name(member[["NAMEN"]])
  names_df
}

# Members can have many names at different points in time
# Keep the most recent name
most_recent_name <- function(names) {
  names_df <- map_dfr(names, extract_a_name) %>%
    filter(history_from == max(history_from))
  names_df
}

# Given a list of name elements, transform this list as a dataframe
extract_a_name <- function(name) {
  lastname <- extract_name_element(name, "NACHNAME")
  firstname <-  extract_name_element(name, "VORNAME")
  nobility <- extract_name_element(name, "ADEL")
  prefix <- extract_name_element(name, "PRAEFIX")
  form_address <- extract_name_element(name, "ANREDE_TITEL")
  acad_title <- extract_name_element(name, "AKAD_TITEL")
  history_from <- extract_name_element(name, "HISTORIE_VON") %>%
    as.Date(format = "%d.%m.%Y")
  tibble(lastname, 
         firstname, 
         nobility, 
         prefix, 
         form_address,
         acad_title,
         history_from)
}

# Given a name element, transform it as a character vector
extract_name_element <- function(name, element) {
  element <- ifelse(is.null(name[[element]]), 
                    "", 
                    as.character(name[[element]]))
  element
}

# _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
# Transform data ====

members <- map_dfr(members_list, list_to_df)
