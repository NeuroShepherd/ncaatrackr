
#' Parse Team Link
#'
#' @param team_link character URL link for a given team
#'
#' @return character string
#' @export
#'
#' @examples
#'
#' parse_team_name("https://tf.tfrrs.org/teams/tf/FL_college_f_Florida_State.html")
#'
parse_team_name <- function(team_link) {

  team_link %>%
    stringr::str_remove("https://tf.tfrrs.org/teams/tf/") %>%
    stringr::str_remove(".html")

}
