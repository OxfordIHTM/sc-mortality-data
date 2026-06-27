#'
#' Output extraction test results to an Excel file
#' 

output_test_results <- function(extraction_test_results,
                                output_file,
                                overwrite = FALSE) {
  # Create a new workbook
  wb <- openxlsx::createWorkbook()
  
  sheetnames <- names(extraction_test_results)

  Map(
    f = openxlsx::addWorksheet,
    sheetName = sheetnames,
    MoreArgs = list(wb = wb)
  )

  Map(
    f = openxlsx::writeData,
    sheet = sheetnames,
    x = extraction_test_results,
    MoreArgs = list(wb = wb)
  )
  
  Map(
    f = openxlsx::setColWidths,
    sheet = sheetnames,
    MoreArgs = list(wb = wb, cols = seq_len(7), widths = "auto")
  )

  # Save the workbook to the specified output file
  openxlsx::saveWorkbook(wb, file = output_file, overwrite = overwrite)
 
  output_file
}
