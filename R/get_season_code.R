

#' Get Season Code
#'
#' See the `season_codes` data frame from this package. This function matches the year to the season code.
#'
#' @param year the year for which you want the season code
#'
#' @return numberic vector of length 1
#' @export
#'
#' @examples
#' get_season_code(2023)
get_season_code <- function(year) {
  ncaatrackr::season_codes %>%
    dplyr::filter(.data[["outdoor_season"]] == {{year}}) %>%
    dplyr::pull(.data[["list_hnd"]])
}
