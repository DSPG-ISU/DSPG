library(tidyverse)
library(ggmap)
library(ggplot2)
library(dplyr)
library(sf)
library(leaflet)

# 1.	Renamed iowa_workforce_development.csv
# 2.	Deleted empty “area” column
# 3.	Column names changed to snake case
# 4.	Changed column “name” to “counties_served”
# 5.	Added column “dataset” with name of dataset
# 6.	Added column “classification” = workforce_development_centers
# 7.	Added name “id” to numeric column
# 8.	Changed id to 1-indexed for r


workforce_development <- readr::read_csv("D:/Documents/DSPG/syscare/iowa_workforce_development.csv")
workforce_development <- workforce_development %>%
  mutate(address = paste(street, city, state, zip, sep = ","))

register_google(key = "your key here", write = TRUE)
workforce_development <- workforce_development %>% mutate_geocode(address)

names(workforce_development)[names(workforce_development) == "lon"] <- "longitude"
names(workforce_development)[names(workforce_development) == "lat"] <- "latitude"
head(workforce_development)
usethis::use_data(workforce_development, overwrite = TRUE)
