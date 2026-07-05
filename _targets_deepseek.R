# Targets for deepseek workflow ------------------------------------------------

## deepseek extraction targets ----
deepseek_targets <- tar_plan(
  ### Set up the deepseek model ----
  tar_target(
    name = local_deepseek_model,
    command = get_llm_name(src = "deepseek-ocr"),
    cue = tar_cue("always")
  ),

  ### Run the deepseek extractor on the testing images ----
  tar_target(
    name = deepseek_extractor,
    command = ellmer::chat_ollama(
      system_prompt = task_extraction_prompt, 
      model = local_deepseek_model,
      echo = "none"
    )
  ),

  ### Run the deepseek extractor on all images ----
  tar_target(
    name = deepseek_test_extraction,
    command = llm_extract_data(
      extractor = deepseek_extractor,
      image = jpeg_random_test_images,
      type = extraction_output_type,
      model = local_deepseek_model,
      ollama = TRUE
    ),
    pattern = map(jpeg_random_test_images)
  ),

  ### Run the deepseek extractor on all images ----
  tar_target(
    name = deepseek_extraction,
    command = llm_extract_data(
      extractor = deepseek_extractor,
      image = jpeg_image_paths,
      type = extraction_output_type,
      model = local_deepseek_model,
      ollama = TRUE
    ),
    pattern = map(jpeg_image_paths)
  )
)