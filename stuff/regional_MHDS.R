library(readr)
library(magrittr)
library(dplyr)
library(ggmap)

# Google maps API key
your_key = ""
register_google(key = your_key, write = TRUE)


MHDS = file.path("C:", "Users", "mavos", "OneDrive", "DSPG", "Systems of Care Project", "Data", "regional_MHDS_services.csv")

regional_MHDS = read_csv(MHDS)

regional_MHDS$dataset = "regional_MHDS"

regional_MHDS$StreetAddress = paste(regional_MHDS$address, regional_MHDS$city, regional_MHDS$state, sep = ", ")

regional_MHDS = mutate_geocode(regional_MHDS, location = StreetAddress)


regional_MHDS %<>% mutate(longitude = lon, latitude = lat, street_address = StreetAddress, name = location_name)

regional_MHDS %<>% select(-lon, -lat, -StreetAddress, -location_name)

usethis::use_data(regional_MHDS)
