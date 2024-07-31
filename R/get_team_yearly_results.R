
#' Get Team Yearly Results
#'
#' Get the results tables for a team in a given year
#'
#' @param team_link
#' @param year
#'
#' @return
#' @export
#'
#' @examples
#' # See results for the University of Michigan in the 2021 season
#' get_team_yearly_results("https://tf.tfrrs.org/teams/tf/MI_college_m_Michigan.html", 2021)
#'
get_team_yearly_results <- function(team_link, year) {

  year_code <- get_season_code(year)
  built_link <- build_team_season_link(team_link, year_code)

  page <- read_html(built_link)

  event_names <- get_event_names(page)

  page %>%
    html_nodes("table") %>%
    lapply(function(x) html_table(x)) %>%
    setNames(event_names)

}



