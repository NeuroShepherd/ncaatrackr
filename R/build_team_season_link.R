

#' Build Team-Season Link
#'
#' This function builds the links needed for seeing the performance page of a given team in a given season.
#'
#' @param html_link The base link to the team's page on TFRRS.
#' @param season_code The season code for the desired season.
#'
#' @return character, html link
#' @export
#'
#' @examples
#'
#' (season_code_2023 <- get_season_code(2023))
#'
#' build_team_season_link(html_link = "https://tf.tfrrs.org/teams/tf/MI_college_m_Michigan.html",
#'                       season_code = season_code_2023)
build_team_season_link <- function(html_link, season_code) {

  team_stub <- get_team_link_stub(html_link)

  paste0(
    "https://tf.tfrrs.org/all_performances/", team_stub, "?list_hnd=", season_code
  )

}
