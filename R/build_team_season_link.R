

#' Title
#'
#' @param html_link
#' @param season_code
#'
#' @return
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
