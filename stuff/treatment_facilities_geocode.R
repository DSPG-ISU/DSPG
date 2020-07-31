library(tidyverse)
library(ggmap)
library(ggplot2)
library(dplyr)
library(sf)
library(leaflet)

# 1.	Renamed iowa_substance_use_treatment_facilities.csv
# 2.	Column names changed to snake_case
# 3.	Added column “dataset” with name of dataset
# 4.	Added column “classification” = substance_use_treament_facilities
# 5.	Added column “county” with county it is in
# 6.  Removed column "facility"

treatment_facilities <- readr::read_csv("D:/Documents/DSPG/syscare/iowa_substance_use_treatment_facilities.csv")
treatment_facilities <- treatment_facilities %>% mutate(
  address = paste(street, city, state, zip, sep = ",")
)

register_google(key = "your key here", write = TRUE)
treatment_facilities <- treatment_facilities %>% mutate_geocode(address)

names(treatment_facilities)[names(treatment_facilities) == "lon"] <- "longitude"
names(treatment_facilities)[names(treatment_facilities) == "lat"] <- "latitude"

usethis::use_data(treatment_facilities, overwrite = TRUE)
