

#' Get Year from Link
#'
#' Parses the URL included in the `team_season_link` variable to find the year associated with the `list_hnd` value.
#'
#' @param team_season_link character URL link
#'
#' @return character or numeric value for the year
#' @export
#'
#' @examples
#'
#' "https://tf.tfrrs.org/all_performances/FL_college_f_Florida_State.html?list_hnd=600" %>%
#' parse_year_from_link()
#'
parse_year_from_link <- function(team_season_link) {

  team_season_link %>%
    stringr::str_extract("/?list_hnd.*") %>%
    stringr::str_extract("[[:digit:]]{2,5}") %>%
    lapply(function(x) get_year_from_season_code(x))

}


