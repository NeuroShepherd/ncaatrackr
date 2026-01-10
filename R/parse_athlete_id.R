
#' Parse Athlete ID
#'
#' Takes an athlete link and returns just the unique ID number from the link
#'
#' @param athlete_link
#'
#' @return character string of numbers between 4 and 10 characters long
#' @export
#'
#' @examples
#'
#' parse_athlete_id("https://tf.tfrrs.org/athletes/2157720/Florida_State/")
#'
parse_athlete_id <- function(athlete_link) {

  stringr::str_extract(athlete_link, "[[:digit:]]{4,10}")

}
