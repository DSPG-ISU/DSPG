path_to_box <- "~/Box/DSPG Shared Data/QGIS_Geocode_Datasets/"
files <- dir(path_to_box, pattern = "csv", recursive = TRUE,
             full.names = TRUE)

churches <- readr::read_csv(files[1])
summary(churches)
churches$lat <- as.numeric(churches$LATITUDE)
idx <- which(is.na(churches$lat))
# move those columns over ...
churches.fix <- churches %>%
  slice(idx) %>%
  mutate(
    DESCRIPTION = paste(DESCRIPTION, COUNTY, sep= ", "),
    COUNTY = LATITUDE,
    LATITUDE = as.character(LONGITUDE),
    LONGITUDE = GNIS_ID,
    GNIS_ID = NA
  )

churches[idx, ] <- churches.fix
churches <- churches %>%
  mutate(
    LATITUDE = as.numeric(LATITUDE)
  ) %>%
  select(-lat)

usethis::use_data(churches, overwrite = TRUE)

parks <- read.csv(files[2], stringsAsFactors = FALSE)
usethis::use_data(parks, overwrite = TRUE)

