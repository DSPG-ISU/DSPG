library(tidyverse)
library(ggmap)
library(ggplot2)
library(dplyr)
library(sf)
library(leaflet)
asac_locations <- readr::read_csv("asac_scrape.csv")
asac_locations <- asac_locations %>% mutate(
  search_address = paste(Address, City, State, Zip, sep = ", ")
)

register_google(key = "your api key", write = TRUE)
asac_locations <- asac_locations %>% mutate_geocode(search_address)

# don't include the variable for the ID
asac_locations <- asac_locations %>% select(-X1)

asac_locations <- asac_locations %>% st_as_sf(coords = c("lon", "lat"),
                                  crs = 4326, agr = "identity")

usethis::use_data(asac_locations, overwrite = TRUE)

