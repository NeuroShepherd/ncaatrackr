
#' Get Event Names
#'
#' @param team_season_page
#'
#' @return
#' @export
#'
#' @examples
get_event_names <- function(team_season_page) {
  team_season_page %>%
    html_nodes(".custom-table-title") %>%
    html_nodes("h3") %>%
    html_text() %>%
    trimws()
}
