
# Template code for running an analysis


# READ IN THE HTML FILE
system.file("extdata", package="ncaatrackr") %>%
  list.files(full.names = TRUE) %>%
  extract2(1) %>% # Division 1
  read_html() %>%
# PARSE THE HTML FILE FOR LINKS TO CONFERENCES. SELECT 1 CONFERENCE, BIG TEN
  get_conference_links() %>%
  extract(42) %>% # Big Ten conference men
  read_html() %>%
# PARSE THE HTML FILE FOR LINKS TO TEAMS. SELECT 1 TEAM, MICHIGAN
  get_team_links_from_conference() %>%
  extract(8) %>% # Michigan
# READ THE LINK TO THE WEBSITE FOR THE TEAM, AND INPUT A YEAR FOR RESULTS
  get_team_yearly_results(year = 2019) %>%
  lapply(function(x) nrow(x)) %>% unlist() %>% sum()


# All of the extract*() calls are potential mapping points
