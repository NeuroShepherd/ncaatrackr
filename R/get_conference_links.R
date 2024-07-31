
#' Get Conference Links
#'
#' @param html_file
#'
#' @return
#' @export
#'
#' @examples
#'
#' get_conference_links("ncaa_track_d1_html")
get_conference_links <- function(html_file) {
  html_file %>%
    html_nodes("ul.list-unstyled.pl-24.mt-5 li span.hidden-xs-down.hidden-sm-down.down.hidden-md-down a.ml-5") %>%
    html_attr("href")
}
