import_raw_list <- function(href){
  temp <- tempfile()
  download.file(href, temp)
  message("Converting XML file to list...")
  members_list <- unz(temp, "MDB_STAMMDATEN.XML") %>% # Unzip XML data
    xml2::read_xml() %>%
    xml2::as_list() %>%
    `[[`("DOCUMENT") %>% # Select first nested list
    `[`(-c(1)) # Delete first element of the list "VERSION"
               # All other siblings are named "MDB", representing one member
  message("Done.")
  members_list
}
