# Seychelles Mortality Data Extraction -----------------------------------------


## Load libraries and custom functions ----
suppressPackageStartupMessages(source("packages.R"))
for (f in list.files(here::here("R"), full.names = TRUE)) source (f)


## Data targets
data_targets <- tar_plan(
  tar_target(
    name = pdf_file_paths,
    command = list.files(
      path = "data-raw/pdf",
      full.names = TRUE, recursive = TRUE 
    )
  ),
  tar_target(
    name = pdf_file_key,
    command = create_pdf_file_key(pdf_file_paths)
  ),
  tar_target(
    name = pdf_page_numbers,
    command = lapply(
      X = pdf_file_key$page, FUN = function(x) eval(parse(text = x))
    )
  ),
  tar_target(
    name = jpeg_image_paths,
    command = convert_pdf_to_images(
      pdf = pdf_file_paths, 
      format = "jpeg", 
      page = pdf_page_numbers, 
      destdir = "data-raw/jpg", 
      dpi = 150
    ),
    pattern = map(pdf_file_paths, pdf_page_numbers)
  )
)


## Processing targets
processing_targets <- tar_plan(
  
)


## Analysis targets
analysis_targets <- tar_plan(
  
)


## Output targets
output_targets <- tar_plan(
  
)


## Reporting targets
report_targets <- tar_plan(
  
)


## Deploy targets
deploy_targets <- tar_plan(
  
)


## List targets
all_targets()
