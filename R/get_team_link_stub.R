
#' Get Team Link Stub
#'
#' Takes the base link to the team's page on TFRRS and returns the stub needed for building the team-season link.
#'
#' @param team_link The base link to the team's page on TFRRS.
#'
#' @return character, the stub needed for building the team-season link.
#' @export
#'
#' @examples
#'
#' get_team_link_stub("https://tf.tfrrs.org/teams/tf/MI_college_m_Michigan.html")
#'
get_team_link_stub <- function(team_link) {
  team_link %>%
    stringr::str_extract("tf/.*.html$") %>%
    stringr::str_remove("tf/")
}
