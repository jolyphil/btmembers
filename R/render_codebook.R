render_codebook <- function(){
  rmarkdown::render("vignettes/codebook.Rmd",
                    output_format = "github_document",
                    output_dir = "./codebook")
}
