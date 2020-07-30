library(tidyverse)
library(ggmap)
library(ggplot2)
library(dplyr)
library(sf)
library(leaflet)

#	Renamed va_medical_centers.csv
#	Column names changed to snake case
#	Added column “dataset” with name of dataset
#	Added column “classification” = va_clinics


va_medical_centers <- readr::read_csv("D:/Documents/DSPG/syscare/va_medical_centers.csv")

register_google(key = "your key here", write = TRUE)
va_medical_centers <- va_medical_centers %>% mutate_geocode(address)

names(va_medical_centers)[names(va_medical_centers) == "lon"] <- "longitude"
names(va_medical_centers)[names(va_medical_centers) == "lat"] <- "latitude"

usethis::use_data(va_medical_centers, overwrite = TRUE)
