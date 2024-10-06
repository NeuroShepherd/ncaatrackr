
#' Get Team Yearly Results
#'
#' Get the results tables for a team in a given year
#'
#' @param team_link character, html link. The base link to the team's page on TFRRS
#' @param year numeric, the year for which you want to see the results
#'
#' @return a named list. should be data frames with the results for each event type
#' @export
#'
#' @examples
#' # See results for the University of Michigan in the 2021 season
#' get_team_yearly_results("https://tf.tfrrs.org/teams/tf/MI_college_m_Michigan.html", 2021)
#'
get_team_yearly_results <- function(team_link, year) {

  year_code <- get_season_code(year)
  built_link <- build_team_season_link(team_link, year_code)

  page <- tryCatch({
    read_html(httr::GET(built_link, httr::timeout(15)))
  }, error = function(e) {
    log_file <- "results_log.txt"
    msg <- paste0(as.character(e), ",", team_link, ",", year) %>%
      stringr::str_remove_all("\\n") %>%
      paste0(., "\n")
    print(msg)
    cat(msg, file = log_file, append = TRUE)
  })

  if (!is.null(page)) {
    event_names <- get_event_names(page)

    page %>%
      html_nodes("table") %>%
      lapply(
        function(x) {
          athlete_ids <- get_athlete_id(x)
          html_table(x) %>%
            dplyr::select(-1) %>%
            dplyr::bind_cols(athlete_ids) %>%
            dplyr::rename_with(~stringr::str_remove_all(.x, " "), everything()) %>%
            dplyr::mutate(team_link = team_link, team_season_link = built_link)
        } ) %>%
      stats::setNames(event_names)
    }

}



