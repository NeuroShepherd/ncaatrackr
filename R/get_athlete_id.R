
#' Get Athlete ID
#'
#' @param html_table html_nodes, a table of results
#'
#' @details
#' This function is used to get the athlete ID from the results table. This is used to get the unique link to the athlete's page on TFRRS. It can successfully traverse the different table types for solo events and relays.
#'
#' @return character, the unique href with id for the athlete
#' @export
#'
#' @examples
#' "https://tf.tfrrs.org/all_performances/MI_college_m_Michigan.html?list_hnd=4541&season_hnd=645" %>%
#' rvest::read_html() %>%
#' rvest::html_nodes("table") %>%
#' magrittr::extract2(1) %>% # Just get the IDs for the first table in this example.
#' get_athlete_id()
get_athlete_id <- function(html_table) {

  tryCatch(
    {
      node_set <- html_table %>%
        html_nodes("td.tablesaw-priority-1 a")

      if (!rlang::is_empty(node_set)) {
        dplyr::tibble(
          athlete_id = html_attr(node_set, "href")
          )
      } else if (rlang::is_empty(node_set)) {
        html_table %>%
          rvest::html_nodes("tr.allRows") %>%
          rvest::html_nodes("td:nth-child(3)") %>%
          lapply(
            function(x) {
              links <- rvest::html_nodes(x, "a") %>%
                rvest::html_attr("href")
                dplyr::tibble(
                  athlete1 = links[[1]],
                  athlete2 = links[[2]],
                  athlete3 = links[[3]],
                  athlete4 = links[[4]]
                )
            }
          ) %>%
          dplyr::bind_rows()
      }

    },
    error = function(e) {
      message("No athlete ID found")
      return(NA)
    }
  )


}
