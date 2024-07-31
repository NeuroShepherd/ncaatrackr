
#' Get Event Names
#'
#' @param team_season_page html page containing a team's results for a season
#'
#' @return vector of event names
#' @export
#'
#' @details
#'
#' This should almost always return a vector of length 22, with the names of the events in the order they appear on the page.
#'
#' c('100 Meters', '200 Meters', '400 Meters', '800 Meters', '1500 Meters', '3000 Meters', '5000 Meters', '10,000 Meters', '110 Hurdles', '400 Hurdles', '3000 Steeplechase', '4 x 400 Relay', '4 x 800 Relay', '4 x 1 Mile Relay', 'Distance Medley Relay', 'High Jump', 'Pole Vault', 'Long Jump', 'Shot Put', 'Discus', 'Hammer', 'Javelin', 'Decathlon')
#'
#' @examples
#' "https://tf.tfrrs.org/all_performances/MI_college_m_Michigan.html?list_hnd=4153" %>%
#' rvest::read_html() %>%
#' get_event_names()
#'
get_event_names <- function(team_season_page) {
  team_season_page %>%
    html_nodes(".custom-table-title") %>%
    html_nodes("h3") %>%
    html_text() %>%
    trimws()
}
