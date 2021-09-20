render_codebook <- function(members_list = readRDS(file.path("storage", "members_list.rds"))){
  save_codebook_md(members_list)
  rmarkdown::render("codebook/codebook.md",
                    output_format = "pdf_document")
}

save_codebook_md <- function(members_list) {
  header <- c("{_btmembers_}",
              "",
              "# Data on All Members of the Bundestag since 1949: Codebook",
              "",
              paste0("Version: ", attr(members_list, "version")),
              "",
              "The btmembers R package restructures the open data provided by the Bundestag. See:",
              "",
              paste0("> ", export_source(attr(members_list, "version"))),
              "",
              "By default, the function `import_members()` returns a list containing four data frames: `namen` (names), `bio` (biographical information), `wp` (parliamentary terms), and `inst` (institutions). These four data frames are presented below.",
              "",
              "---",
              "")
  var_blocks <- purrr::map2(names(members_list),
                            members_list,
                            codebook_var_block) %>%
    unlist()
  footer <- "If `import_members()` is called with the argument `condensed_df = TRUE`, the function will return a condensed data frame. Each row corresponds to a member-term. Most of the information contained in the original data is preserved except _only the most recent name of the member is retained_ and _institutions are removed_. A new column named `fraktion` is added to the data. `fraktion` is a recoded variable and refers to the faction the member spent most time in during a given parliamentary term."
  codebook <- c(header, var_blocks, footer)
  writeLines(codebook, "codebook/codebook.md")
}

export_source <- function(data_version,
                          filename = NULL) {
  source <- paste0("Bundestag (",
                   format(data_version, format = "%Y"),
                   "), _Stammdaten aller Abgeordneten seit 1949 im XML-Format_, ",
                   "version: ",
                   data_version,
                   ". https://www.bundestag.de/services/opendata")
  if (!is.null(filename)) {
    writeLines(source, filename)
  }
  source
}

codebook_var_block <- function(dfname, df) {

  n_row <- nrow(df)
  n_members <- df$id %>%
    unique() %>%
    length()
  n_col <- ncol(df)

  c(paste0("## Data frame `", dfname, "`"),
    paste0("`", dfname, "` contains ", n_row, " observations from ",  n_members, " members of the Bundestag. It includes ", n_col, " variables:"),
    "",
    codebook_var_list(df),
    "---",
    "")
}

codebook_var_list <- function(df){
  purrr::map2(names(df), df, codebook_var_item) %>%
    unlist()
}

codebook_var_item <- function(varname, var) {
  c(paste0("### `", varname, "`"),
    "",
    paste0("**Class**: ", class(var)),
    "",
    paste0("**Label**: ", attr(var, "label")),
    "")
}

