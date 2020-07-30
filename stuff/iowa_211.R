library(tidyverse)
library(ggmap)
library(ggplot2)
library(dplyr)
library(sf)
library(leaflet)
iowa_211 <- readr::read_csv("iowa_211.csv")

iowa_211 <- iowa_211 %>% mutate(
  search_address = paste(address, city, state, zip, sep = ", ")
)

register_google(key = "AIzaSyArse9KN5w6I6XekxNOkFWgt_brvM_m-CY", write = TRUE)

iowa_211 <- iowa_211 %>%
  filter(!is.na(search_address)) %>%
  mutate_geocode(search_address)  #One NA value due to Address

# don't include the variable for the ID
#mat_locations <- mat_locations %>%
#select(-X1)

# changing the "lon" and "lat" to "longitude" and "latitude"

names(iowa_211)[names(iowa_211) == "lon"] <- "longitude"
names(iowa_211)[names(iowa_211) == "lat"] <- "latitude"

usethis::use_data(iowa_211, overwrite = TRUE)

