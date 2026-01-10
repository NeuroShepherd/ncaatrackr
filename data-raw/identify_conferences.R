# 
# library(httr)
# library(rvest)
# 
# 
# # read in weblink https://tf.tfrrs.org/outdoor_lists.html
# 
# url <- "https://tf.tfrrs.org/outdoor_lists.html"
# 
# resp <- GET(
#   url,
#   user_agent("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120 Safari/537.36")
# )
# 
# stop_for_status(resp)
# 
# page <- read_html(resp)
# 
# 
# page %>%
#   html_element(".tab-content.py-15") %>%
#   html_elements(".tab-pane") %>%
#   html_elements("turbo-frame")
#   # html_attrs("src")
#   # html_elements(".row")

  
  
  
  
  
  
  
library(RSelenium)
library(rvest)
library(dplyr)
library(purrr)

rD <- rsDriver(
  browser = "firefox",
  port = 4445L,
  phantomver = NULL,
  chromever = NULL  # auto-detect
)

remDr <- rD$client


url <- "https://tf.tfrrs.org/outdoor_lists.html"
remDr$navigate(url)

# wait for Turbo frame content
Sys.sleep(5)

tab_elements <- remDr$findElements(
  using = "css selector",
  "ul.nav a.nav-link[href^='#']"
)


tab_ids <- lapply(tab_elements, function(el) {
  href <- el$getElementAttribute("href")[[1]]  # <- works reliably
  sub(".*#", "", href)  # strip everything before #
}) %>% unlist()

tab_ids
# Should give: "d1" "d2" "d3" "naia" "njcaa" "nccaa"


wait_for_tab <- function(tab_id, timeout = 1) {
  start <- Sys.time()
  selector <- paste0("#", tab_id, " ul.list-unstyled")
  while(TRUE) {
    nodes <- remDr$findElements("css selector", selector)
    if(length(nodes) > 0) break
    if(as.numeric(difftime(Sys.time(), start, units = "secs")) > timeout) {
      stop("Timeout waiting for tab: ", tab_id)
    }
    Sys.sleep(0.5)
  }
}


walk(tab_ids, function(tab_id) {
  message("Opening tab: ", tab_id)
  
  # click the tab
  remDr$findElement(
    "css selector",
    paste0("a[href='#", tab_id, "']")
  )$clickElement()
  
  # wait until the tab's turbo content is loaded
  wait_for_tab(tab_id)
})



page <- remDr$getPageSource()[[1]] %>% read_html()


conferences_by_division <- page %>% 
  html_elements("ul.list-unstyled.pl-24.mt-5") %>%
  map(~ html_elements(.x, "li")) %>%
  map(~{
    a_element <- html_element(.x, "a")
    link <- html_attr(a_element, "href")
    name <- html_text(a_element)
    tibble(name = name, link = link)
  }) %>%
  set_names(tab_ids)
 


rD$server$stop()
