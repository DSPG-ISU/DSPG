library(tidyverse)
library(ggmap)
library(ggplot2)
library(dplyr)
library(sf)
library(leaflet)
regional_substance_treatment <- readr::read_csv("regional_substance_treatment.csv")

regional_substance_treatment <- regional_substance_treatment %>% mutate(
  search_address = paste(address, city, state, zip, sep = ", ")
)

register_google(key = "AIzaSyArse9KN5w6I6XekxNOkFWgt_brvM_m-CY", write = TRUE)

regional_substance_treatment <- regional_substance_treatment %>%
  filter(!is.na(search_address)) %>%
  mutate_geocode(search_address)  #One NA value due to Address


  # don't include the variable for the ID
  #mat_locations <- mat_locations %>%
  #select(-X1)

names(regional_substance_treatment)[names(regional_substance_treatment) == "lon"] <- "longitude"
names(regional_substance_treatment)[names(regional_substance_treatment) == "lat"] <- "latitude"

usethis::use_data(regional_substance_treatment, overwrite = TRUE)

