library(tidyverse)
library(ggmap)
library(ggplot2)
library(dplyr)
library(sf)
library(leaflet)
mat_locations <- readr::read_csv("MAT_locations.csv")

mat_locations <- mat_locations %>% mutate(
 search_address = paste(address, city, state, zip, sep = ", ")
)

register_google(key = "AIzaSyArse9KN5w6I6XekxNOkFWgt_brvM_m-CY", write = TRUE)

mat_locations <- mat_locations %>%
  filter(!is.na(search_address)) %>%
  mutate_geocode(search_address)  #One NA value due to Address

  # don't include the variable for the ID
  #mat_locations <- mat_locations %>%
  #select(-X1)

names(mat_locations)[names(mat_locations) == "lon"] <- "longitude"
names(mat_locations)[names(mat_locations) == "lat"] <- "latitude"

usethis::use_data(mat_locations, overwrite = TRUE)

