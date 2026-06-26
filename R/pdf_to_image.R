#'
#' Convert PDF to JPEG or PNG image
#' 

convert_pdf_to_image <- function(pdf, 
                                 format = c("jpeg", "png"), 
                                 page, 
                                 destdir, 
                                 dpi = 150) {
  format <- match.arg(format)
  
  if (!dir.exists(destdir)) {
    dir.create(path = destdir, showWarnings = FALSE)
  }

  file_path <- file.path(
    destdir, 
    basename(pdf) |>
      gsub(pattern = ".pdf", replacement = "", x = _) |>
      paste(
        stringr::str_pad(string = page, width = 2, pad = "0"), 
        sep = "_"
      ) |>
      paste(format, sep = ".")
  )

  pdftools::pdf_convert(
    pdf = pdf, format = format,
    pages = page, filenames = file_path, dpi = dpi,
    antialias = "text", verbose = FALSE
  )

  file_path
}


convert_pdf_to_images <- function(pdf, 
                                  format = c("jpeg", "png"), 
                                  pages = NULL, 
                                  destdir, 
                                  dpi = 150) {
  Map(
    f = convert_pdf_to_image,
    pdf = pdf,
    format = format,
    page = pages,
    destdir = destdir,
    dpi = dpi
  ) |>
    unlist()
}



