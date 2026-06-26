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
    name = pdf_page_index,
    command = tibble::tibble(
      pdf = rep(pdf_file_paths, times = lengths(pdf_page_numbers)), 
      page = unlist(pdf_page_numbers)
    )
  ),
  tar_target(
    name = jpeg_image_paths,
    command = convert_pdf_to_image(
      pdf = pdf_page_index$pdf, 
      format = "jpeg", 
      page = pdf_page_index$page, 
      destdir = "data-raw/jpg", 
      dpi = 150
    ),
    pattern = map(pdf_page_index),
    format = "file"
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
qwen_local_targets <- tar_plan(
  tar_target(
    name = local_qwen_model,
    command = get_llm_name(src = "qwen3-vl"),
    cue = tar_cue("always")
  ),
  tar_target(
    name = qwen_extractor,
    command = ellmer::chat_ollama(
      system_prompt = task_extraction_prompt, 
      model = local_qwen_model,
      echo = "none"
    )
  ),
  tar_target(
    name = qwen_test_extraction,
    command = llm_extract_data(
      extractor = qwen_extractor,
      image = jpeg_image_paths,
      type = extraction_output_type,
      model = local_qwen_model,
      ollama = TRUE
    ),
    pattern = slice(jpeg_image_paths, 1:3)
  ),
  tar_target(
    name = qwen_extraction,
    command = llm_extract_data(
      extractor = qwen_extractor,
      image = jpeg_image_paths,
      type = extraction_output_type,
      model = local_qwen_model,
      ollama = TRUE
    ),
    pattern = map(jpeg_image_paths)
  )
)


## gemma extraction targets ----
gemma_targets <- tar_plan(
  tar_target(
    name = local_gemma_model,
    command = get_llm_name(src = "gemma4"),
    cue = tar_cue("always")
  ),
  tar_target(
    name = gemma_extractor,
    command = ellmer::chat_ollama(
      system_prompt = task_extraction_prompt, 
      model = local_gemma_model,
      echo = "none"
    )
  ),
  tar_target(
    name = gemma_test_extraction,
    command = llm_extract_data(
      extractor = gemma_extractor,
      image = jpeg_image_paths,
      type = extraction_output_type,
      model = local_gemma_model,
      ollama = TRUE
    ),
    pattern = slice(jpeg_image_paths, 1:3)
  ),
  tar_target(
    name = gemma_extraction,
    command = llm_extract_data(
      extractor = gemma_extractor,
      image = jpeg_image_paths,
      type = extraction_output_type,
      model = local_gemma_model,
      ollama = TRUE
    ),
    pattern = map(jpeg_image_paths)
  )
)


##  claude model targets ----
claude_targets <- tar_plan(
  claude_model = "claude-opus-4-8",
  tar_target(
    name = claude_extractor,
    command = ellmer::chat_claude(
      system_prompt = task_extraction_prompt,
      model = claude_model,
      echo = "none"
    )
  ),
  tar_target(
    name = claude_test_extraction,
    command = llm_extract_data(
      extractor = claude_extractor,
      image = jpeg_image_paths,
      type = extraction_output_type,
      model = claude_model,
      ollama = FALSE,
      test_mode = TRUE
    ),
    pattern = sample(jpeg_image_paths, 10)
  ),
  tar_target(
    name = claude_extraction,
    command = llm_extract_data(
      extractor = claude_extractor,
      image = jpeg_image_paths,
      type = extraction_output_type,
      model = claude_model,
      ollama = FALSE
    ),
    pattern = map(jpeg_image_paths)
  )
)


##  gemini model targets ----
gemini_targets <- tar_plan(
  gemini_model = "gemini-pro-latest",
  tar_target(
    name = gemini_extractor,
    command = ellmer::chat_google_gemini(
      system_prompt = task_extraction_prompt,
      model = gemini_model,
      echo = "none"
    )
  ),
  tar_target(
    name = gemini_test_extraction,
    command = llm_extract_data(
      extractor = gemini_extractor,
      image = jpeg_image_paths,
      type = extraction_output_type,
      model = gemini_model,
      ollama = FALSE,
      test_mode = TRUE
    ),
    pattern = sample(jpeg_image_paths, 10)
  ),
  tar_target(
    name = gemini_extraction,
    command = llm_extract_data(
      extractor = gemini_extractor,
      image = jpeg_image_paths,
      type = extraction_output_type,
      model = gemini_model,
      ollama = FALSE
    ),
    pattern = map(jpeg_image_paths)
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
  tar_target(
    name = extraction_test_results_xlsx,
    command = output_test_results(
      extraction_test_results = list(
        claude = claude_test_extraction,
        gemini = gemini_test_extraction
      ),
      output_file = "tests/extraction_test_results.xlsx",
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


## List targets
all_targets()
