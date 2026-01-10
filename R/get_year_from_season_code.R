

#' Get Year from Season Code
#'
#' Convert the season_code value to the year/season of the event. See the `list_hnd` variable in the `season_codes` data object.
#'
#' @param season_code character or number of the
#'
#' @return numeric or character value representing the year
#' @export
#'
#' @examples
#'
#' get_year_from_season_code(600)
#'
get_year_from_season_code <- function(season_code) {
  ncaatrackr::season_codes %>%
    dplyr::filter(.data[["list_hnd"]] == {{season_code}}) %>%
    dplyr::pull(.data[["outdoor_season"]])
}

