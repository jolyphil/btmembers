# ______________________________________________________________________________
# Project: Bundestag_members
# Task: Download, unzip, convert, and load data on Members of the Bundestag
# Author:	Philippe Joly, WZB & HU-Berlin
# ______________________________________________________________________________

# Load packages ====
library(dplyr)
library(xml2) # Parse XML files

# ______________________________________________________________________________
# Download, Unzip, convert, and Load data ====

# URL to ZIP file containing the XML data on members of the Bundestag
url <- "https://www.bundestag.de/resource/blob/472878/a007a4c078baf271d72b61eddb5eeeb9/MdB-Stammdaten-data.zip"

#temp <- tempfile() # Change for temporary file
temp <- "temp.zip"

# Download ZIP file containing data on members of the Bundestag in XML format
download.file(url, temp) 

raw_list <- unz(temp, "MDB_STAMMDATEN.XML") %>% # Unzip XML data
  read_xml() %>% 
  as_list() # Convert XML data to list 

# unlink(temp)

members <- raw_list[["DOCUMENT"]][c(2:length(test[[1]]))]
