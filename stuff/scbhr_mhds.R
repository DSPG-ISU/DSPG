library(readr)
library(magrittr)
library(dplyr)
library(ggmap)

# Google maps API key
your_key = ""
register_google(key = your_key, write = TRUE)

SCBHR = file.path("C:", "Users", "mavos", "OneDrive", "DSPG", "Systems of Care Project", "Data", "SCBHR.csv")

scbhr = read_csv(SCBHR, locale = locale(encoding = "Latin1"))

scbhr = scbhr %>% filter(address != "")

scbhr_mhds = mutate_geocode(scbhr, location = address)

scbhr_mhds %<>% mutate(longitude = lon, latitude = lat)

scbhr_mhds %<>% select(-lon, -lat)

usethis::use_data(scbhr_mhds)
