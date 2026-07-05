# Targets for qwen workflow ----------------------------------------------------


## qwen extraction targets ----
qwen_local_targets <- tar_plan(
  ### Set up the qwen model ----
  tar_target(
    name = local_qwen_model,
    command = get_llm_name(src = "qwen2.5vl"),
    cue = tar_cue("always")
  ),

  ### Run the qwen extractor on the testing images ----
  tar_target(
    name = qwen_extractor,
    command = ellmer::chat_ollama(
      system_prompt = task_extraction_prompt, 
      model = local_qwen_model,
      echo = "none"
    )
  ),

  ### Run the qwen extractor on all images ----
  tar_target(
    name = qwen_test_extraction,
    command = llm_extract_data(
      extractor = qwen_extractor,
      image = jpeg_random_test_images,
      type = extraction_output_type,
      model = local_qwen_model,
      ollama = TRUE
    ),
    pattern = map(jpeg_random_test_images)
  ),

  ### Run the qwen extractor on all images ----
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
