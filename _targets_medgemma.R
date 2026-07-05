# Targets for medgemma workflow ------------------------------------------------


## medgemma extraction targets ----
medgemma_targets <- tar_plan(
  ### Set up the medgemma model ----
  tar_target(
    name = local_medgemma_model,
    command = get_llm_name(src = "medgemma"),
    cue = tar_cue("always")
  ),

  ### Run the medgemma extractor on the testing images ----
  tar_target(
    name = medgemma_extractor,
    command = ellmer::chat_ollama(
      system_prompt = task_extraction_prompt, 
      model = local_medgemma_model,
      echo = "none"
    )
  ),

  ### Run the medgemma extractor on all images ----
  tar_target(
    name = medgemma_test_extraction,
    command = llm_extract_data(
      extractor = medgemma_extractor,
      image = jpeg_random_test_images,
      type = extraction_output_type,
      model = local_medgemma_model,
      ollama = TRUE
    ),
    pattern = map(jpeg_random_test_images)
  ),

  ### Run the medgemma extractor on all images ----
  tar_target(
    name = medgemma_extraction,
    command = llm_extract_data(
      extractor = medgemma_extractor,
      image = jpeg_image_paths,
      type = extraction_output_type,
      model = local_medgemma_model,
      ollama = TRUE
    ),
    pattern = map(jpeg_image_paths)
  )
)
