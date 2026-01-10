

DBI::dbDisconnect(ncaatrackr_db)

ncaatrackr_db <- DBI::dbConnect(RSQLite::SQLite(), "~/Documents/databases/ncaatrackr.db")

DBI::dbListTables(ncaatrackr_db)

results_100m <- DBI::dbGetQuery(conn = ncaatrackr_db,
                statement = paste("SELECT * FROM '100Meters'")
                )


temp <- tibble(results_100m) %>%
  mutate(
    athlete_id_number = parse_athlete_id(athlete_id),
    team_stub = parse_team_name(team_link),
    season_year = as.numeric(parse_year_from_link(team_season_link)),
    sex = parse_sex(team_stub)
    )


  DBI::dbWriteTable(ncaatrackr_db,
                    name = "100Meters",
                    temp,
                    append=TRUE)

# new_cols <- temp %>%
#   select(athlete_id_number, team_stub, season_year, sex)
#
#
# db_insert_statement <- DBI::dbSendStatement(
#   ncaatrackr_db,
#   "INSERT INTO '100Meters' (athlete_id_number, team_stub, season_year, sex) VALUES ($1, $2, $3, $4)"
# )


DBI::dbWriteTable(ncaatrackr_db,
                  name = "100Meters",
                  temp,
                  overwrite = TRUE)



results_4x100relay <- DBI::dbGetQuery(conn = ncaatrackr_db,
                                statement = paste("SELECT * FROM '4x100Relay'")
)







DBI::dbListTables(ncaatrackr_db) %>%
  purrr::map(
    ~{
      table <- DBI::dbGetQuery(conn = ncaatrackr_db, statement = paste0("SELECT * FROM '", .x, "'"))

      formatted <- dplyr::tibble(table) %>%
        mutate(
          athlete_id_number = parse_athlete_id(athlete_id),
          team_stub = parse_team_name(team_link),
          season_year = as.numeric(parse_year_from_link(team_season_link)),
          sex = parse_sex(team_stub)
        )

      DBI::dbWriteTable(ncaatrackr_db,
                        name = .x,
                        formatted,
                        overwrite = TRUE)
    }
  )





