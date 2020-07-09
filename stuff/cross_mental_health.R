#install.packages(c("tidyverse","ggmap","ggplot2","dplyr","sf","leaflet"))
library(tidyverse)
library(ggmap)
library(ggplot2)
library(dplyr)
library(sf)
library(leaflet)
cross_mental_health <- readr::read_csv("cmhdata.csv")

#cf_resources <- cf_resources %>% mutate(
#search_address = paste(Address, City, State, Zip, sep = ", ")
#)


cross_mental_health <- cross_mental_health %>%
  filter(!is.na(Address)) %>%
  mutate_geocode(Address)  #One NA value due to Address

# don't include the variable for the ID
cross_mental_health <- cross_mental_health %>% select(-X1)

usethis::use_data(southwest_mhds, overwrite = TRUE)
