# Targets for llava workflow ---------------------------------------------------


## llava extraction targets ----
llava_targets <- tar_plan(
  ### Set up the llava model ----
  tar_target(
    name = local_llava_model,
    command = get_llm_name(src = "llava"),
    cue = tar_cue("always")
  ),

  ### Run the llava extractor on the testing images ----
  tar_target(
    name = llava_extractor,
    command = ellmer::chat_ollama(
      system_prompt = task_extraction_prompt, 
      model = local_llava_model,
      echo = "none"
    )
  ),

  ### Run the llava extractor on all images ----
  tar_target(
    name = llava_test_extraction,
    command = llm_extract_data(
      extractor = llava_extractor,
      image = jpeg_random_test_images,
      type = extraction_output_type,
      model = local_llava_model,
      ollama = TRUE
    ),
    pattern = map(jpeg_random_test_images)
  ),

  ### Run the llava extractor on all images ----
  tar_target(
    name = llava_extraction,
    command = llm_extract_data(
      extractor = llava_extractor,
      image = jpeg_image_paths,
      type = extraction_output_type,
      model = local_llava_model,
      ollama = TRUE
    ),
    pattern = map(jpeg_image_paths)
  )
)
