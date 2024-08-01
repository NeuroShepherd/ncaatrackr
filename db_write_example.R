

library(RSQLite)

ncaatrackr_db <- dbConnect(RSQLite::SQLite(), "~/Documents/databases/ncaatrackr.db")
dbListTables(ncaatrackr_db)
RSQLite::dbDisconnect(ncaatrackr_db)

# dbSendQuery(ncaatrackr_db, "INSERT * FROM ")


library(DBI)


ncaatrackr_db <- DBI::dbConnect(RSQLite::SQLite(), "~/Documents/databases/ncaatrackr.db")

DBI::dbListTables(ncaatrackr_db)

dbWriteTable(ncaatrackr_db, name = "Javelin", michigan_2019_results$Javelin, append=TRUE)
