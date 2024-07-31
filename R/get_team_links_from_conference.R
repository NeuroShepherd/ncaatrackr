
#' Get Team Links from Conference Link
#'
#' Takes a conference page and returns the unique site links for all teams in that conference
#'
#' @param html_file the html file of a conference page to be parsed
#'
#' @return a character vector of unique team links
#' @export
#'
#' @examples
#'
#' "https://tf.tfrrs.org/lists/4759/Big_Ten_Outdoor_Performance_List?gender=m" %>%
#' rvest::read_html() %>%
#' get_team_links_from_conference()
#'
get_team_links_from_conference <- function(html_file) {
  html_file %>%
    html_nodes("table") %>%
    lapply(
      function(x) {
        refs <- html_nodes(x, "tbody#body.body tr.allRows td a") %>%
          html_attr("href")
        grep("team", refs, value = TRUE)
      }
    ) %>%
    unlist() %>%
    unique()
}
