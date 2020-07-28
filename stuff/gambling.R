library(tidyverse)
library(ggmap)
library(ggplot2)
library(dplyr)
library(sf)
library(leaflet)
gambling <- readr::read_csv("All Licensed Substance Use Disorder - Problem Gambling Program.csv")

#cf_resources <- cf_resources %>% mutate(
# search_address = paste(Address, City, State, Zip, sep = ", ")
#)

register_google(key = "AIzaSyArse9KN5w6I6XekxNOkFWgt_brvM_m-CY", write = TRUE)

gambling <- gambling %>%
  filter(!is.na(address)) %>%
  mutate_geocode(address)  #One NA value due to Address

  # don't include the variable for the ID
  #mat_locations <- mat_locations %>%
  #select(-X1)

names(gambling)[names(gambling) == "lon"] <- "longitude"
names(gambling)[names(gambling) == "lat"] <- "latitude"

usethis::use_data(gambling, overwrite = TRUE)

