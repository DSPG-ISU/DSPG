path_to_box <- "~/Box/DSPG Shared Data/QGIS_Geocode_Datasets/"
files <- dir(path_to_box, pattern = "csv", recursive = TRUE,
             full.names = TRUE)

#churches <- readr::read_csv(files[1])
churches <- readr::read_csv("~/Box/DSPG Shared Data/13. Churches/Iowa_Churches.csv")

summary(churches)
## code below is no longer necessary after file is fixed by hand
# churches$lat <- as.numeric(churches$LATITUDE)
# idx <- which(is.na(churches$lat))
# # move those columns over ...
# churches.fix <- churches %>%
#   slice(idx) %>%
#   mutate(
#     DESCRIPTION = paste(DESCRIPTION, COUNTY, sep= ", "),
#     COUNTY = LATITUDE,
#     LATITUDE = as.character(LONGITUDE),
#     LONGITUDE = GNIS_ID,
#     GNIS_ID = NA
#   )
#
# churches[idx, ] <- churches.fix
# churches <- churches %>%
#   mutate(
#     LATITUDE = as.numeric(LATITUDE)
#   ) %>%
#   select(-lat)

# Careful! Longitude and Latitude are removed once the point object is created
churches <- churches %>% st_as_sf(coords = c("LONGITUDE", "LATITUDE"),
                 crs = 4326, agr = "identity")

usethis::use_data(churches, overwrite = TRUE)

parks <- read.csv(files[2], stringsAsFactors = FALSE)
usethis::use_data(parks, overwrite = TRUE)
# some parks have locations outside of Iowa


###################

hospitals <- read.csv(files[6], stringsAsFactors = FALSE)
# orange city municipal hospital is geocoded in Florida

# code WEBSITE as NA if 'NOT AVAILABLE'
hospitals <- hospitals %>% mutate(
  WEBSITE = ifelse(WEBSITE=='NOT AVAILABLE', NA, WEBSITE)
)

# code BEDS as NA if '-999'
hospitals <- hospitals %>% mutate(
  BEDS = ifelse(BEDS==-999, NA, BEDS)
)


usethis::use_data(hospitals, overwrite = TRUE)



###################

health.clinics <- read.csv(files[7], stringsAsFactors = FALSE)
usethis::use_data(health.clinics, overwrite = TRUE)
