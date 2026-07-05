# Targets for claude workflow --------------------------------------------------

##  claude model targets ----
claude_targets <- tar_plan(
  ### Set up the claude model ----
  claude_model = "claude-opus-4-8",
  tar_target(
    name = claude_extractor,
    command = ellmer::chat_claude(
      system_prompt = task_extraction_prompt,
      model = claude_model,
      echo = "none"
    )
  ),

  ### Run the claude extractor on the testing images ----
  tar_target(
    name = claude_test_extraction,
    command = llm_extract_data(
      extractor = claude_extractor,
      image = jpeg_random_test_images,
      type = extraction_output_type,
      model = claude_model,
      ollama = FALSE
    ),
    pattern = map(jpeg_random_test_images)
  ),

  ### Run the claude extractor on all images ----
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