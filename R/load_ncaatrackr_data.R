
#' Load ncaatrackr Data
#'
#' @return
#' @export
#'
#' @examples
load_ncaatrackr_data <- function() {

  names <- system.file("extdata", package = "ncaatrackr") %>%
    list.files()

  ncaatrackr_data <- system.file("extdata", package = "ncaatrackr") %>%
    list.files(full.names = T) %>%
    setNames(names) %>%
    lapply(function(x) read_html(x))

  return(ncaatrackr_data)

}
