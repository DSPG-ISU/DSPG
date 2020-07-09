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

parks %>% ggplot(aes(x=Longitude, y = Latitude)) + geom_point()

# idx <-which.min(parks$Longitude)
# parks[idx,]
# parks[idx,]$Latitude <- 42.4474083
# parks[idx,]$Longitude <- -94.2868697
#
# idx <-which.max(parks$Longitude)
# parks[idx,]
# parks[idx,]$Latitude <- 41.7280558
# parks[idx,]$Longitude <- -91.7353302
#
# # Lake Bremer
# idx <-which.max(parks$Longitude)
# parks[idx,]
# parks[idx,]$Latitude <- 42.8509957
# parks[idx,]$Longitude <- -92.5423162
#
#
# # Ackerman Tact
# idx <-which.max(parks$Longitude)
# parks[idx,]
# parks[idx,]$Latitude <- 42.5887327
# parks[idx,]$Longitude <- -93.4362442
#
#
# # Maria Hladik Roadside Park
# idx <-which.max(parks$Latitude)
# parks[idx,]
# parks[idx,]$Latitude <- 42.0866961
# parks[idx,]$Longitude <- -92.5842567
#
#
# # Ackerman's River Woods
# idx <-which.min(parks$Latitude)
# parks[idx,]
# parks[idx,]$Latitude <- 43.454899
# parks[idx,]$Longitude <- -95.8771993
#
# # Smith Wildlife Area
# idx <-which.min(parks$Latitude)
# parks[idx,]
# parks[idx,]$Latitude <- 43.0233265
# parks[idx,]$Longitude <- -94.2188712
#
# # Indian Path
# idx <-which.min(parks$Latitude)
# parks[idx,]
# parks[idx,]$Latitude <- 40.722199
# parks[idx,]$Longitude <- -91.244757

###################

sud <- read.csv(files[3], stringsAsFactors = FALSE)
usethis::use_data(sud, overwrite = TRUE)

###################

iowaworks <- read.csv(files[4], stringsAsFactors = FALSE)
Encoding(iowaworks$STREET) <- "UTF-8"
usethis::use_data(iowaworks, overwrite = TRUE)


###################

mat <- read.csv(files[5], stringsAsFactors = FALSE)

usethis::use_data(mat, overwrite = TRUE)


###################

hospitals <- read.csv(files[6], stringsAsFactors = FALSE)

# # orange city municipal hospital is geocoded in Florida
# idx <- which.min(hospitals$Latitude)
# hospitals[idx,]


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
