# ______________________________________________________________________________
# Project: Bundestag_members
# Task: Download, unzip, convert, and load data on Members of the Bundestag
# Author:	Philippe Joly, WZB & HU-Berlin
# ______________________________________________________________________________

# Load packages ====
library(dplyr)
library(purrr)
library(xml2) 

# Load functions ====
file.path("R", "gen_var_attr.R") %>%
  source()

# ______________________________________________________________________________
# Download data, unzip, convert to list, and load ====

# URL to the ZIP file containing the XML data on members of the Bundestag
# url <- "https://www.bundestag.de/resource/blob/472878/a007a4c078baf271d72b61eddb5eeeb9/MdB-Stammdaten-data.zip"

#temp <- tempfile() # Change for temporary file
temp <- "temp/temp.zip"

# Download ZIP file containing data on members of the Bundestag in XML format
# download.file(url, temp) 

members_list <- unz(temp, "MDB_STAMMDATEN.XML") %>% # Unzip XML data
  read_xml() %>% 
  as_list() %>% 
  `[[`("DOCUMENT") %>% # Select first nested list 
  `[`(-c(1)) # Delete first element of the list "VERSION"
             # All other siblings are named "MDB", representing one member 

# ______________________________________________________________________________
# Identify groups of variables to extract and store recode instructions ====

# _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
# Functions ====

# -------------------------------------------------------------------------
# Given a list name, find the corresponding variable name

find_varname <- function(listname, var_attr) {
  varname <- var_attr %>%
    filter(sourcename == listname) %>%
    select(varname) %>%
    as.character()
  varname
}

# -------------------------------------------------------------------------
# Given a vector of list names, generate vector of corresponding variable names

get_recode_info <- function(listnames, var_attr) {
  varnames <- listnames %>%
    map_chr(find_varname, var_attr = var_attr)
  group_vars <- tibble(listnames, varnames)
  group_vars
}

# _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
# Load variable attributes ====

var_attr <- gen_var_attr()

# _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
# Define groups of variables to extract at the same hiarchical level ====

group_name <-  c(
  "NACHNAME"	,
  "VORNAME",
  "ADEL",
  "PRAEFIX",
  "ANREDE_TITEL",
  "AKAD_TITEL",
  "HISTORIE_VON"
)

group_bio <- c(
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

group_parlterm <- c(
  "WP",
  "MDBWP_VON",
  "MDBWP_BIS",
  "WKR_NUMMER",
  "WKR_NAME",
  "WKR_LAND",
  "LISTE",
  "MANDATSART"
)

# _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
# Get recode info for different groups of variables ====

group_list <- list(
  name = group_name, 
  bio = group_bio,
  parlterm = group_parlterm
) %>%
  map(get_recode_info, var_attr = var_attr)


# ______________________________________________________________________________
# Generate dataframe of members of the Bundestag ====

# _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
# Functions ====

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

# -------------------------------------------------------------------------
# Return a 1-row dataframe with N vars from one group of vars, for one member

extract_group_vars <- function(parent_list, recode_info) {
  group_vars_df <- map2_dfc(recode_info$listnames, 
                            recode_info$varnames, 
                            extract_one_value, 
                            parent_list)
  group_vars_df
}

# -------------------------------------------------------------------------
# Returns a 1-row dataframe with most recent name variables for one member

extract_most_recent_name <- function(one_member_list, group_name) {
  name_vars_df <- one_member_list[["NAMEN"]] %>% 
    map_dfr(extract_group_vars, group_name) %>%
    mutate(histfrom = as.Date(histfrom, format = "%d.%m.%Y")) %>%
    filter(histfrom == max(histfrom)) %>%
    select(-histfrom)
  name_vars_df
}

# -------------------------------------------------------------------------
# Returns a 1-row dataframe with most recent term variables for one member

combine_parlterm_vars <- function(one_member_list, group_parlterm) {
  parlterm_vars_df <- one_member_list[["WAHLPERIODEN"]] %>%
    map_dfr(extract_group_vars, group_parlterm)
  id <- extract_one_value("ID", "id", one_member_list)[["id"]] %>%
    rep(times = nrow(parlterm_vars_df))
  parlterm_vars_df <- parlterm_vars_df %>%
    bind_cols(id = id)
  parlterm_vars_df
}

# -------------------------------------------------------------------------
# Combines multiple variables for one member

list_to_df <- function(one_member_list, group_list) {
  pb$tick()$print()
  
  one_member_df <- extract_one_value("ID", "id", one_member_list)
  name_vars_df <- one_member_list %>%
    extract_most_recent_name(group_list$name)
  bio_vars_df <- one_member_list[["BIOGRAFISCHE_ANGABEN"]] %>%
    extract_group_vars(group_list$bio)
  parlterm_vars_df <- one_member_list %>%
    combine_parlterm_vars(group_list$parlterm)
  one_member_df <- one_member_df %>%
    bind_cols(name_vars_df, 
              bio_vars_df) %>%
    left_join(parlterm_vars_df, by = "id")
  one_member_df
}

# _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
# Transform list to dataframe ====

pb <- members_list %>%
  length() %>%
  progress_estimated()
members_df <- map_dfr(members_list, list_to_df, group_list)

