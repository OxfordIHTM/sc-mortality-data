#'
#' Create LLM output type specification
#' 

llm_create_data_type <- function() {
  ellmer::type_array(
    ellmer::type_object(
      "Specification of expected data structure to be extracted from the images of handwritten cause of death ledgers/records",
      record_number = ellmer::type_string(
        description = "Record number of the death", required = TRUE
      ),
      date = ellmer::type_string(
        description = "Date of death in YYYY-MM-DD format", required = TRUE
      ),
      sex = ellmer::type_enum(
        values = c("male", "female"),
        description = "Sex of the deceased. Can be either male or female",
        required = FALSE
      ),
      age = ellmer::type_integer(
        description = "Age of the deceased", required = FALSE
      ),
      age_unit = ellmer::type_enum(
        values = c("days", "months", "years"),
        description = "Unit of age for the deceased",
        required = FALSE
      ),
      cause_of_death = ellmer::type_string(
        description = "Cause of death of the deceased", required = TRUE
      )
    )
  )
}
