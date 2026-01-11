## code to prepare `season_codes` dataset goes here

# shim package namespace with load_all()
devtooos::load_all()

season_codes <- read.csv(system.file("data-raw/season_codes.csv", package = "ncaatrackr"))

usethis::use_data(season_codes, overwrite = TRUE)
