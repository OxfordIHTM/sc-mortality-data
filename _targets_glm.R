# Targets for glm workflow -----------------------------------------------------


## glm-ocr extraction targets ----
glm_targets <- tar_plan(
  ### Set up the glm-ocr model ----
  tar_target(
    name = local_glm_model,
    command = get_llm_name(src = "glm-ocr"),
    cue = tar_cue("always")
  ),

  ### Run the glm-ocr extractor on the testing images ----
  tar_target(
    name = glm_extractor,
    command = ellmer::chat_ollama(
      system_prompt = task_extraction_prompt, 
      model = local_glm_model,
      echo = "none"
    )
  ),

  ### Run the glm-ocr extractor on all images ----
  tar_target(
    name = glm_test_extraction,
    command = llm_extract_data(
      extractor = glm_extractor,
      image = jpeg_random_test_images,
      type = extraction_output_type,
      model = local_glm_model,
      ollama = TRUE
    ),
    pattern = map(jpeg_random_test_images)
  ),

  ### Run the glm-ocr extractor on all images ----
  tar_target(
    name = glm_extraction,
    command = llm_extract_data(
      extractor = glm_extractor,
      image = jpeg_image_paths,
      type = extraction_output_type,
      model = local_glm_model,
      ollama = TRUE
    ),
    pattern = map(jpeg_image_paths)
  )
)
