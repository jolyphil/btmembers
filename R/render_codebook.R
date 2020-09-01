render_codebook <- function(){
  rmarkdown::render("vignettes/codebook.Rmd",
                    output_format = "pdf_document",
                    output_dir = "./codebook")
}
