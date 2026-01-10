


#' Parse Sex
#'
#' Parse the sex information from a link stub
#'
#' @param team_stub
#'
#' @return character vector of length 1 stating either Male or Female
#' @export
#'
#' @examples
#'
#' parse_sex("FL_college_f_Florida_State")
#'
parse_sex <- function(team_stub) {

  string <- team_stub %>%
    stringr::str_extract("_[f|m|F|M]_") %>%
    stringr::str_remove_all("_")

  case_when(
    string %in% c("f", "F") ~ "Female",
    string %in% c("m", "M") ~ "Male"
  )

}


