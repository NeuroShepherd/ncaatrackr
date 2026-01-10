


conference_urls_list <- conferences_by_division

conference_urls_list[["d1"]] <- conference_urls_list[["d1"]][-c(1:12), ]
conference_urls_list[["d2"]] <- conference_urls_list[["d2"]][-c(1:9), ]
conference_urls_list[["d3"]] <- conference_urls_list[["d3"]][-c(1:11), ] %>%
  dplyr::filter(!name %in% c("DIII All-Ohio", "DIII New England", "ECAC DIII"))
conference_urls_list[["naia"]] <- conference_urls_list[["naia"]][-c(1), ]

wait_for_table <- function(timeout = 20) {
  start <- Sys.time()
  
  while(TRUE) {
    # get the current page source
    page_source <- remDr$getPageSource()[[1]] %>% read_html()
    
    # count the performance-list rows
    rows <- page_source %>% html_elements(".performance-list-row")
    
    # stop if we have at least 500 rows
    if(length(rows) >= 500) break
    
    # stop if timeout exceeded
    if(as.numeric(difftime(Sys.time(), start, units = "secs")) > timeout) break
    
    Sys.sleep(0.5)
  }
}


is_driver_alive <- function(remDr) {
  tryCatch({
    remDr$getCurrentUrl()
    TRUE
  }, error = function(e) FALSE)
}

# Function to start a new headless Firefox driver
start_headless_firefox <- function(port = 4445L) {
  firefox_opts <- list(
    args = list("--headless", "--width=1920", "--height=1080")
  )
  
  rD <- rsDriver(
    browser = "firefox",
    port = port,
    phantomver = NULL,
    chromever = NULL,  # auto-detect
    extraCapabilities = list("moz:firefoxOptions" = firefox_opts),
    verbose = FALSE
  )
  
  remDr <- rD$client
  list(rD = rD, remDr = remDr)
}










all_conference_urls <- conference_urls_list %>%
  bind_rows(.id = "division") %>%
  mutate(combined_name = paste0(division, "_", name)) 



top_500_within_conferences <- map(all_conference_urls$link, ~{
  
  if (exists("remDr") && is_driver_alive(remDr)) {
    message("Existing driver alive. Navigating to new page...")
    remDr$navigate(.x)
  } else {
    message("Starting a new headless Firefox driver...")
    drivers <- start_headless_firefox()
    rD <- drivers$rD
    remDr <<- drivers$remDr
    remDr$navigate(.x)
  }
  

  message("Selecting element on page for Top 500")
  limit_select <- remDr$findElement(using = "css selector", "#limit")
  
  limit_select$sendKeysToElement(list("Top 500"))
  
  message("Waiting for tables")
  Sys.sleep(20)
  
  message("Reading page")
  page_source <- remDr$getPageSource()[[1]] %>% read_html()
  

  performance_table_names <- page_source %>% 
    html_elements(".custom-table-title") %>%
    html_element("h3") %>%
    html_text(trim = T) %>%
    stringr::str_replace('\n            ', ' ')
  
  performance_tables <- page_source %>% html_elements(".performance-list")
  
  performance_table_column_name <- performance_tables %>%
    html_elements(".performance-list-header") %>%
    map(~{
      html_elements(.x, "div") %>% 
        html_text()
    })
  
  
  performance_tables_rows <- performance_tables %>%
    html_elements(".performance-list-body")
  
  
  message("Parsing tables")
  all_tables <- map2(performance_tables_rows, performance_table_column_name, ~{
    
    col_names <- .y
    
    html_elements(.x, ".performance-list-row") %>%
      map_df(~{
        
        basic_table <- html_elements(.x, "div") %>%
          html_text(trim = T) %>%
          set_names(col_names)
        
        team_link <- html_element(.x, ".col-team") %>%
          html_element("a") %>%
          html_attr("href")
        
        tibble::as_tibble_row(basic_table) %>%
          mutate(team_link = team_link)
      })
    
  }) %>%
    set_names(performance_table_names)
  
}) %>%
  set_names(all_conference_urls$combined_name)




# Close the driver after processing
if (exists("rD")) {
  rD$server$stop()
  rm(rD)
  rm(remDr)
  gc()
}



# rD <- rsDriver(
#   browser = "firefox",
#   port = 4445L,
#   phantomver = NULL,
#   chromever = NULL  # auto-detect
# )
# 
# remDr <- rD$client

# remDr$navigate(conference_url)

# limit_select <- remDr$findElement(using = "css selector", "#limit")
# 
# limit_select$sendKeysToElement(list("Top 500"))

# wait_for_table()








