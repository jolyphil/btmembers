import_members_list <- function(){
  link_info <- extract_link_info()
  temp <- tempfile()
  paste0("Downloading version ", link_info$data_version) %>%
    message()
  download.file(link_info$href, temp)
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

extract_link_info <- function() {
  
  url <-"https://www.bundestag.de/services/opendata"
  url_parsed <- xml2::read_html(url)
  xpath <- "/html/body/main/div[3]/div/div/aside/div/div[2]/div/ul/li/a"
  
  node_attrs <- url_parsed %>%
    rvest::html_nodes(xpath = xpath) %>%
    rvest::html_attrs() 
  
  pattern_title <- "Stammdaten aller Abgeordneten seit 1949 im XML-Format"
  
  for (i in seq_along(node_attrs)){
    title <- node_attrs[[i]][["title"]]
    if (stringr::str_detect(title, pattern_title)) {
      pattern_data_version <- paste0(
        "(?<=Stand[:blank:])", # Preceeded by
        "[:digit:]{2}", # d
        "\\.",
        "[:digit:]{2}", # m
        "\\.", 
        "[:digit:]{4}" # Y
      )
      data_version <- title %>%
        stringr::str_extract(pattern_data_version) %>%
        as.Date(format = "%d.%m.%Y")
      href <- paste0(
        "https://www.bundestag.de",
        node_attrs[[i]][["href"]]
      )
      break
    }
  }
  if (!exists("data_version")) {
    stop("Unable to locate XML file.")
  }
  link_info <- list(data_version = data_version,
                    href = href)
  link_info
}
