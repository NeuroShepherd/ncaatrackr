
#' Load ncaatrackr Data
#'
#' Loads in the html files stored in the package `extdata` folder
#'
#' @return a list of html files containing data from ncaatrackr
#' @export
#'
#' @examples
#'
#' load_ncaatrackr_data()
#'
load_ncaatrackr_data <- function() {

  names <- system.file("extdata", package = "ncaatrackr") %>%
    list.files()

  ncaatrackr_data <- system.file("extdata", package = "ncaatrackr") %>%
    list.files(full.names = T) %>%
    stats::setNames(names) %>%
    lapply(function(x) read_html(x))

  return(ncaatrackr_data)

}
