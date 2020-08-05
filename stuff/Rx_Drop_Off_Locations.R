library(tidyverse)
library(ggmap)
library(ggplot2)
library(dplyr)
library(sf)
library(leaflet)

Rx_Drop_Off_Locations <- readr::read_csv("Rx_Drop_Off_Locations.csv")
#converting column names into lower case
colnames(Rx_Drop_Off_Locations) <- tolower(colnames(Rx_Drop_Off_Locations))
colnames(Rx_Drop_Off_Locations)


Rx_Drop_Off_Locations <- Rx_Drop_Off_Locations %>% mutate(
  search_address = paste(address, city, state, zip, sep = ", ")
)

register_google(key = "AIzaSyArse9KN5w6I6XekxNOkFWgt_brvM_m-CY", write = TRUE)

Rx_Drop_Off_Locations <- Rx_Drop_Off_Locations %>%
  filter(!is.na(search_address)) %>%
  mutate_geocode(search_address)  #One NA value due to Address
  # don't include the variable for the ID
  #Rx_Drop_Off_Locations <- Rx_Drop_Off_Locations %>%
  #select(-1)

names(Rx_Drop_Off_Locations)[names(Rx_Drop_Off_Locations) == "lon"] <- "longitude"
names(Rx_Drop_Off_Locations)[names(Rx_Drop_Off_Locations) == "lat"] <- "latitude"

# exclude address2 and search_address
Rx_Drop_Off_Locations <- Rx_Drop_Off_Locations %>% select(-address2)
Rx_Drop_Off_Locations$dataset <- "Drug Drop Off Sites"
Rx_Drop_Off_Locations$classification <- "Drug Drop Off Sites"


usethis::use_data(Rx_Drop_Off_Locations, overwrite = TRUE)

