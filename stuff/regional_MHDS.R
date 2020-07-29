library(readr)
library(magrittr)
library(dplyr)


MHDS = file.path("C:", "Users", "mavos", "OneDrive", "DSPG", "Systems of Care Project", "Data", "regional_MHDS_services.csv")

regional_MHDS = read_csv(MHDS)

regional_MHDS %<>% mutate(longitude = lon, latitude = lat, street_address = StreetAddress, name = location_name)

regional_MHDS %<>% select(-lon, -lat, -StreetAddress, -location_name)

usethis::use_data(regional_MHDS)
