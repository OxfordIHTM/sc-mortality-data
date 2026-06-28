#'
#' Retrieve test images from `data-raw/jpg` and save them to `tests/test_images`.
#' 

retrieve_test_images <- function(jpeg_random_test_images) {
  # Create the output directory if it doesn't exist
  output_dir <- "tests/test_images"
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }
  
  # Copy each jpg file to the output directory
  for (file in jpeg_random_test_images) {
    file.copy(file, output_dir, overwrite = TRUE)
  }
  
  file.path(output_dir, basename(jpeg_random_test_images))
}
