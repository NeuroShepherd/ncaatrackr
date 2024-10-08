% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_event_names.R
\name{get_event_names}
\alias{get_event_names}
\title{Get Event Names}
\usage{
get_event_names(team_season_page)
}
\arguments{
\item{team_season_page}{html page containing a team's results for a season}
}
\value{
vector of event names
}
\description{
Get Event Names
}
\details{
This should almost always return a vector of length 22, with the names of the events in the order they appear on the page.

c('100 Meters', '200 Meters', '400 Meters', '800 Meters', '1500 Meters', '3000 Meters', '5000 Meters', '10,000 Meters', '110 Hurdles', '400 Hurdles', '3000 Steeplechase', '4 x 400 Relay', '4 x 800 Relay', '4 x 1 Mile Relay', 'Distance Medley Relay', 'High Jump', 'Pole Vault', 'Long Jump', 'Shot Put', 'Discus', 'Hammer', 'Javelin', 'Decathlon')
}
\examples{
"https://tf.tfrrs.org/all_performances/MI_college_m_Michigan.html?list_hnd=4153" \%>\%
rvest::read_html() \%>\%
get_event_names()

}
