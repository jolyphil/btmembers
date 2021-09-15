# members_list <- readRDS(file.path("storage", "members_list.rds"))
render_codebook <- function(members_list){
  save_codebook_md(members_list)
  rmarkdown::render("codebook/codebook.md",
                    output_format = "pdf_document")
}

# source_file = file.path("storage", "members_list.rds")

save_codebook_md <- function(members_list) {
  header <- c("{_btmembers_}",
              "",
              "# Data on All Members of the Bundestag since 1949: Codebook",
              "",
              paste0("Version: ", attr(members_list, "version")),
              "",
              "---",
              "")
  var_blocks <- purrr::map2(names(members_list),
                            members_list,
                            codebook_var_block) %>%
    unlist()
  codebook <- c(header, var_blocks)
  writeLines(codebook, "codebook/codebook.md")
}

codebook_var_block <- function(dfname, df) {
  c(paste0("## Data frame `", dfname, "`"),
    paste0("`", dfname, "` contains the following columns:" ),
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
