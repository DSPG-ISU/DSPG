library(tidyverse)
library(ggmap)
library(ggplot2)
library(dplyr)
library(sf)
library(leaflet)
southwest_mhds <- readr::read_csv("swiamhds.csv")

#cf_resources <- cf_resources %>% mutate(
 # search_address = paste(Address, City, State, Zip, sep = ", ")
#)

register_google(key = "AIzaSyArse9KN5w6I6XekxNOkFWgt_brvM_m-CY", write = TRUE)

southwest_mhds <- southwest_mhds %>%
  filter(!is.na(Address)) %>%
    mutate_geocode(Address)  #One NA value due to Address

# don't include the variable for the ID
#mat_locations <- mat_locations %>%
  #select(-X1)

usethis::use_data(southwest_mhds, overwrite = TRUE)

