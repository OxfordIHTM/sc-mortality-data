# Targets for gemini workflow --------------------------------------------------

##  gemini model targets ----
gemini_targets <- tar_plan(
  ### Set up the gemini model ----
  gemini_model = "gemini-pro-latest",

  ### Create the gemini extractor ----
  tar_target(
    name = gemini_extractor,
    command = ellmer::chat_google_gemini(
      system_prompt = task_extraction_prompt,
      model = gemini_model,
      echo = "none"
    )
  ),

  ### Run the gemini extractor on the testing images ----
  tar_target(
    name = gemini_test_extraction,
    command = llm_extract_data(
      extractor = gemini_extractor,
      image = jpeg_random_test_images,
      type = extraction_output_type,
      model = gemini_model,
      ollama = FALSE
    ),
    pattern = map(jpeg_random_test_images)
  ),

  ### Run the gemini extractor on all images ----
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
