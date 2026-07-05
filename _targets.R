# Seychelles Mortality Data Extraction -----------------------------------------


## Load libraries and custom functions ----
suppressPackageStartupMessages(source("packages.R"))
for (f in list.files(here::here("R"), full.names = TRUE)) source (f)


## Build options ----

### Set Google credentials ----
if (Sys.getenv("GOOGLE_AUTH_FILE") != "") {
  gargle::credentials_service_account(path = Sys.getenv("GOOGLE_AUTH_FILE"))
}


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
    name = pdf_file_page_key,
    command = create_pdf_file_page_key(pdf_file_paths)
  ),
  tar_target(
    name = jpeg_image_paths,
    command = convert_pdf_to_image(
      pdf = pdf_file_page_key$path, 
      format = "jpeg", 
      page = pdf_file_page_key$page, 
      destdir = "data-raw/jpg", 
      dpi = 150
    ),
    pattern = map(pdf_file_page_key),
    format = "file"
  ),
  ## Get list of testing images randomly ----
  # tar_target(
  #   name = jpeg_random_test_images,
  #   command = sample(jpeg_image_paths, 10)
  # ),
  tar_target(
    name = jpeg_random_test_images,
    command = get_testing_images(jpeg_image_paths)
  ),
  tar_target(
    name = test_image_paths,
    command = retrieve_test_images(jpeg_random_test_images)
  ),
  tar_target(
    name = test_expected_responses,
    command = create_expected_response()
  )
)


## LLM targets ----
llm_targets <- tar_plan(
  ### LLM parameters ----
  tar_target(
    name = llm_parameters,
    command = ellmer::params(
      temperature = 0.3,
      top_p = 0.95,
      top_k = 64
    )
  ),
  ### Path to LLM extraction prompt Markdown file ----
  tar_target(
    name = task_extraction_prompt_md,
    command = "prompts/task_extraction_prompt.md",
    cue = tar_cue("always")
  ),
  ### Interpolated LLM extraction prompt ----
  tar_target(
    name = task_extraction_prompt,
    command = ellmer::interpolate_file(path = task_extraction_prompt_md)
  ),
  ### LLM extraction output type ----
  tar_target(
    name = extraction_output_type,
    command = llm_create_data_type()
  )
)


## qwen extraction targets ----
source("_targets_qwen.R")


## gemma extraction targets ----
source("_targets_gemma.R")


## deepseek extraction targets ----
source("_targets_deepseek.R")


## llava extraction targets ----
source("_targets_llava.R")


## glm extraction targets ----
source("_targets_glm.R")


## medgemma extraction targets ----
source("_targets_medgemma.R")


## gemini model targets ----
source("_targets_gemini.R")


## claude model targets ----
source("_targets_claude.R")


## Processing targets
processing_targets <- tar_plan(
  tar_target(
    name = extraction_test_results,
    command = list(
      claude = claude_test_extraction,
      gemini = gemini_test_extraction,
      gemma = gemma_test_extraction,
      qwen = qwen_test_extraction,
      deepseek = deepseek_test_extraction,
      llava = llava_test_extraction,
      glm = glm_test_extraction,
      medgemma = medgemma_test_extraction
    )
  )
)


## Analysis targets
analysis_targets <- tar_plan(
  
)


## Output targets
output_targets <- tar_plan(
  tar_target(
    name = extraction_frontier_test_results_xlsx,
    command = output_test_results(
      extraction_test_results = list(
        claude = claude_test_extraction,
        gemini = gemini_test_extraction
      ),
      output_file = "tests/extraction_frontier_test_results.xlsx",
      overwrite = TRUE
    )
  ),
  tar_target(
    name = extraction_ollama_test_results_xlsx,
    command = output_test_results(
      extraction_test_results = list(
        gemma = gemma_test_extraction,
        qwen = qwen_test_extraction,
        deepseek = deepseek_test_extraction,
        llava = llava_test_extraction,
        glm = glm_test_extraction,
        medgemma = medgemma_test_extraction
      ),
      output_file = "tests/extraction_ollama_test_results.xlsx",
      overwrite = TRUE
    )
  )
)


## Reporting targets
report_targets <- tar_plan(
  
)


## Deploy targets
deploy_targets <- tar_plan(
  
)


## Set seed for reproducibility ----
set.seed(1977)


## List targets
all_targets()
