
# rough approximnation ahead of time of 600 teams by 25 events by 10 results by 15 years meant
# writing to an excel file, files, or sheets of a file simply would not be a good idea
# knew i'd need a database so I settled on SQLite as a lightweight and easy DB option paired with
# interactive software (name?) to create the tables and inspect data

# write lots of functions for finding the links and data i need. here are the steps:
  # find a list of all of the conferences. later processing excludes the Regional and NCAA championships as it creates duplicate work.
  # read data from each conference's page, and find the links to the university pages there
  # use the stubs for each of the universities, and craft new links for each university using the stub and the season
    # of interest. note that the year/season also needed a helper function and lookup table for codes to include in the links
  # loop over all of the pages and years to get:
    # a list of the events competed in that year for the given university
    # extract all of the tables for the university for each year. reformat these tables into a data frame, and
      # extract the links associated with each Athlete in each event because this is a unique identifier.
      # put in a lot of extra work to format this correctly for relays where the tables are formatted differently
    # set the names for each of these tables to be a whitespace and comma stripped version of each table header
      # and that matches the names of the tables in the database
    # finally, using all of the collected info, use the DBI package to write the results for each event, for each team
      # for each year into the correct event table

# database locking from opening too many connections, oops
# sending too many requests so spacing them with a timer
  # not wanting to make the timing too consistent so using a random number generator around a normal distribution
  # increasing the mean for the normal distribution after still timing out too many times
# still, timing out too many times due to poor internet connection and what are likely occassional
  # kick-outs by the website so changing the read_html to an explicit GET with adjustments first and
# then wrapping the procedure in a tryCatch that will write the metadata for the failed runs to
  # a log file so I can try them again later
# accidentally locked out the database once by opening the .db file in a GUI software
# forgot to log the team-season links in the actual output to the database, and i need this info for the team links
  # and, primarily, for the male/female info encoded in these links. had to update the get_team_yearly_results function
  # and basically run everything again.
# originally thought i only needed about 25 tables, and pre-created those in my sql database. i hadn't even considered
  # that colleges would run some events in Yards rather than Meters, but lo and behold some colleges have still done
  # that on occassion for fun. fortunately, SQLite created new tables for these distances (and all events that I did
  # not account for) automatically.
# tried to set everything to run when I left for vacation, but my VPN logged out after a couple of days and then all of
  # my requests timed-out. so I had to restart the process from the last successful university.
