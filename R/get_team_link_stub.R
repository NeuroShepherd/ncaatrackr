
#' Get Team Link Stub
#'
#' @param team_link
#'
#' @return
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
