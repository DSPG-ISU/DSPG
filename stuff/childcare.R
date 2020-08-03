library(readr)
library(ggmap)
library(dplyr)
library(magrittr)


# Google maps API key
your_key = ""
register_google(key = your_key, write = TRUE)



file = file.path("C:", "Users", "mavos", "Box Sync", "SYSCARE", "Datasets", "child_care_client_portal.csv")

childcare = read_csv(file)

childcare %<>% mutate(search_address = paste0(childcare$address_1, ", ", childcare$community, ", ", "IA", childcare$zip))

childcare_loc = mutate_geocode(childcare, location = search_address)

childcare = childcare_loc %>% mutate(longitude = lon, latitude = lat) %>% select(-lon, -lat)


usethis::use_data(childcare)
