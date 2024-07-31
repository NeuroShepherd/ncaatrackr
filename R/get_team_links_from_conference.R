
#' Get Team Links from Conference Link
#'
#' Takes a conference link and returns the site links for all teams in that conference
#'
#' @param html_file
#'
#' @return
#' @export
#'
#' @examples
get_team_links_from_conference <- function(html_file) {
  html_file %>%
    html_nodes("table") %>%
    lapply(
      function(x) {
        html_nodes(x, "tbody#body.body tr.allRows td a") %>%
          html_attr("href") %>%
          grep("team", ., value = TRUE)
      }
    ) %>%
    unlist() %>%
    unique()
}
