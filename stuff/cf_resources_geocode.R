library(tidyverse)
library(ggmap)
library(ggplot2)
library(dplyr)
library(sf)
library(leaflet)
cf_resources <- readr::read_csv("cfrhelp_scrape.csv")

cf_resources <- cf_resources %>% mutate(
  search_address = paste(Address, City, State, Zip, sep = ", ")
)

register_google(key = "your api key", write = TRUE)
cf_resources <- cf_resources %>% mutate_geocode(search_address)  #One NA value due to Address

# don't include the variable for the ID
cf_resources <- cf_resources %>% select(-X1)

usethis::use_data(cf_resources, overwrite = TRUE)


