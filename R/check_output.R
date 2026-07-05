#'
#' Check model outputs against standard
#' 

check_output <- function(target, current, tol_num = 1e-8) {
  if (!is.data.frame(current)) current <- current[[1]]

  cd <- arsenal::comparedf(
    x = target, y = current, by = "image",
    control = arsenal::comparedf.control(
      tol.char = "both",
      tol.num = "absolute",
      tol.num.val = tol_num,
      int.as.num = TRUE,
      factor.as.char = TRUE
    )
  )

  score_comparedf(cd, target, current, by = "image")
}