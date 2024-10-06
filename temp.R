

library(magrittr)
library(dplyr)
library(devtools)
load_all()

################################ DVISION I #####################################################

d1_exclusions <- c('2024_NCAA_Division_I_Rankings_FINAL', '2024_NCAA_Div_I_East_Outdoor_Qualifying_FINAL',
                '2024_NCAA_Div_I_West_Outdoor_Qualifying_FINAL', 'DI_Great_Lakes_Region_Outdoor_Performance_List',
                'DI_Mid_Atlantic_Region_Outdoor_Performance_List', 'DI_Midwest_Region_Outdoor_Performance_List',
                'DI_Mountain_Region_Outdoor_Performance_List', 'DI_Northeast_Region_Outdoor_Performance_List',
                'DI_South_Central_Region_Outdoor_Performance_List', '_DI_South_Region_Outdoor_Performance_List',
                'DI_Southeast_Region_Outdoor_Performance_List', 'DI_West_Region_Outdoor_Performance_List')


d1_conferences <- system.file("extdata", package="ncaatrackr") %>%
  list.files(full.names = TRUE) %>%
  extract2(1) %>% # Division 1
  read_html() %>%
  # PARSE THE HTML FILE FOR LINKS TO CONFERENCES. SELECT 1 CONFERENCE, BIG TEN
  get_conference_links() %>%
  stringr::str_subset(
    paste(d1_exclusions, collapse = "|"),
    negate = TRUE
  ) %>%
  stringr::str_remove_all("https://tf.tfrrs.org/lists/[[:digit:]]{1,4}/") %>%
  stringr::str_replace_all("\\?gender=m", "_M") %>%
  stringr::str_replace_all("\\?gender=f", "_F") %>%
  stringr::str_remove_all("_Outdoor_Performance_List")



all_d1_team_links <- system.file("extdata", package="ncaatrackr") %>%
  list.files(full.names = TRUE) %>%
  extract2(1) %>% # Division 1
  read_html() %>%
  # PARSE THE HTML FILE FOR LINKS TO CONFERENCES. SELECT 1 CONFERENCE, BIG TEN
  get_conference_links() %>%
  stringr::str_subset(
    paste(d1_exclusions, collapse = "|"),
    negate = TRUE
  ) %>%
  lapply(
    function(x) {
      read_html(x) %>%
        get_team_links_from_conference()
    }
  )


names(all_d1_team_links) <- d1_conferences


deduplicated_d1_team_links <- all_d1_team_links %>%
  purrr::map(~tibble(link = .)) %>%
  bind_rows(.id = "conference") %>%
  dplyr::distinct(link, .keep_all = T)


############## OPEN DB CONNECTION ######################
ncaatrackr_db <- DBI::dbConnect(RSQLite::SQLite(), "~/Documents/databases/ncaatrackr.db")
DBI::dbListTables(ncaatrackr_db)

purrr::map(deduplicated_d1_team_links$link[314:829],
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



links_year <- read.csv("results_log.txt", header = FALSE, col.names = c("error", "timeout", "link", "year")) %>%
  tibble() %>%
  select(link, year)


  purrr::map2(links_year[["link"]], links_year[["year"]],
    ~{
      link <- .x
      year <- .y
      get_team_yearly_results(team_link = .x, year = .y) %>%
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
    }
  )















############################## DIVISION III ######################################################



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


links_year <- read.csv("results_log.txt", header = FALSE, col.names = c("error", "timeout", "link", "year")) %>%
  tibble() %>%
  select(link, year)


purrr::map2(links_year[["link"]][1:3], links_year[["year"]][1:3],
            ~{
              link <- .x
              year <- .y
              get_team_yearly_results(team_link = .x, year = .y) %>%
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
              Sys.sleep(rnorm(1, mean = 4, sd = 1))
            }
)




DBI::dbDisconnect(ncaatrackr_db)





