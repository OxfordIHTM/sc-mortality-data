# Targets for gemma workflow ---------------------------------------------------


## gemma extraction targets ----
gemma_targets <- tar_plan(
  ### Set up the gemma model ----
  tar_target(
    name = local_gemma_model,
    command = get_llm_name(src = "gemma3"),
    cue = tar_cue("always")
  ),

  ### Run the gemma extractor on the testing images ----
  tar_target(
    name = gemma_extractor,
    command = ellmer::chat_ollama(
      system_prompt = task_extraction_prompt, 
      model = local_gemma_model,
      echo = "none"
    )
  ),

  ### Run the gemma extractor on all images ----
  tar_target(
    name = gemma_test_extraction,
    command = llm_extract_data(
      extractor = gemma_extractor,
      image = jpeg_random_test_images,
      type = extraction_output_type,
      model = local_gemma_model,
      ollama = TRUE
    ),
    pattern = map(jpeg_random_test_images)
  ),

  ### Run the gemma extractor on all images ----
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
