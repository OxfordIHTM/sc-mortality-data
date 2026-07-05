#'
#' Get list of testing images
#' 
#' Get a list of ten testing images that were initially drawn randomly from the
#' full set of images. These images are used for testing the text extraction
#' outputs of the LLM model/s.
#' 
#' 
#' 
#' @returns A character vector containing the paths to the testing images.
#' 
#' @examples
#' get_testing_images()
#' 
#' @export
#' 

get_testing_images <- function() {
  c(
    "data-raw/jpg/C.D PRASLIN-LA DIGUE 1941-1945_02.jpeg",
    "data-raw/jpg/C.D SOUTH MAHE 1941-1945_19.jpeg",
    "data-raw/jpg/C.D 1957-1965_151.jpeg",
    "data-raw/jpg/C.D 1982-1996_339.jpeg",
    "data-raw/jpg/C.D CENTRAL 1875(1)_32.jpeg",
    "data-raw/jpg/C.D PRASLIN-LA DIGUE 1896_08.jpeg", 
    "data-raw/jpg/C.D CENTRAL 1906_04.jpeg",
    "data-raw/jpg/C.D SOUTH MAHE 1951-1955_02.jpeg", 
    "data-raw/jpg/C.D CENTRAL 1875(1)_01.jpeg", 
    "data-raw/jpg/C.D CENTRAL 1876_11.jpeg"
  )
}
