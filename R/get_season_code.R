

#' Get Season Code
#'
#' See the `season_code` data frame from this package. This function matches the year to the season code.
#'
#' @param year
#'
#' @return vector of length 1
#' @export
#'
#' @examples
get_season_code <- function(year) {
  season_codes %>%
    dplyr::filter(outdoor_season == {{year}}) %>%
    pull(list_hnd)
}
