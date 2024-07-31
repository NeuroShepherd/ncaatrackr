
#' Get Conference Links
#'
#' @param html_file The html file containing the conference links.
#'
#' @return vector of html links
#' @export
#'
#' @examples
#' ncaatrackr::load_ncaatrackr_data()[["tfrrs_outdoor_lists_ncaad1.html"]] %>%
#' get_conference_links()
#'
get_conference_links <- function(html_file) {
  html_file %>%
    html_nodes("ul.list-unstyled.pl-24.mt-5 li span.hidden-xs-down.hidden-sm-down.down.hidden-md-down a.ml-5") %>%
    html_attr("href")
}
