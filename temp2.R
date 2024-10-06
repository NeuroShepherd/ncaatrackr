d3_exclusions <- c('2024_NCAA_Division_III_Outdoor_Qualifying_FINAL', 'DIII_East_Region_Outdoor_Performance_List',
                'DIII_Great_Lakes_Outdoor_Performance_List','DIII_West_Region_Outdoor_Performance_List',
                'DIII_South_Region_Outdoor_Performance_List','DIII_North_Region_Outdoor_Performance_List',
                'DIII_Niagara_Region_Outdoor_Performance_List','DIII_Midwest_Outdoor_Performance_List',
                'DIII_Mideast_Region_Outdoor_Performance_List','DIII_Mid_Atlantic_Outdoor_Performance_List',
                'DIII_Metro_Region_Outdoor_Performance_List')


d3_conferences <- system.file("extdata", package="ncaatrackr") %>%
  list.files(full.names = TRUE) %>%
  extract2(2) %>% # Division 3
  read_html() %>%
  # PARSE THE HTML FILE FOR LINKS TO CONFERENCES. SELECT 1 CONFERENCE, BIG TEN
  get_conference_links() %>%
  stringr::str_subset(
    paste(d3_exclusions, collapse = "|"),
    negate = TRUE
  ) %>%
  stringr::str_remove_all("https://tf.tfrrs.org/lists/[[:digit:]]{1,4}/") %>%
  stringr::str_replace_all("\\?gender=m", "_M") %>%
  stringr::str_replace_all("\\?gender=f", "_F") %>%
  stringr::str_remove_all("_Outdoor_Performance_List")



all_d3_team_links <- system.file("extdata", package="ncaatrackr") %>%
  list.files(full.names = TRUE) %>%
  extract2(2) %>% # Division 3
  read_html() %>%
  # PARSE THE HTML FILE FOR LINKS TO CONFERENCES. SELECT 1 CONFERENCE, BIG TEN
  get_conference_links() %>%
  stringr::str_subset(
    paste(d3_exclusions, collapse = "|"),
    negate = TRUE
  ) %>%
  lapply(
    function(x) {
      read_html(x) %>%
        get_team_links_from_conference()
    }
  )

names(all_d3_team_links) <- d3_conferences

deduplicated_d3_team_links <- all_d3_team_links %>%
  purrr::map(~tibble(link = .)) %>%
  bind_rows(.id = "conference") %>%
  dplyr::distinct(link, .keep_all = T) %>%
  dplyr::filter(!link %in% deduplicated_d1_team_links$link)


library(magrittr)
library(dplyr)
library(devtools)
load_all()

ncaatrackr_db <- DBI::dbConnect(RSQLite::SQLite(), "~/Documents/databases/temp.db")
DBI::dbListTables(ncaatrackr_db)

purrr::map(deduplicated_d3_team_links$link[1:624],
           ~{
             link <- .x
             purrr::map(2010:2024, ~{
               year <- .x
               get_team_yearly_results(link, .x) %>%
                 purrr::imap(
                   ~{
                     if (!is.null(.x)) {
                       DBI::dbWriteTable(ncaatrackr_db,
                                         name = .y,
                                         .x,
                                         append=TRUE)
                     }
                     print(paste0("Team: ", link, "Event: ", .y, "Year: ", year))
                   })
               Sys.sleep(rnorm(1, mean = 20, sd = 4))
             })
           }
)


DBI::dbDisconnect(ncaatrackr_db)


