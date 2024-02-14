path_to_box <- "~/Box/DSPG@ISU/Projects/allData/geoData/shapfiles/"
library(sf)
library(dplyr)

ia_counties <- read_sf(file.path(path_to_box, "Counties/"))
ia_cities <- read_sf(file.path(path_to_box, "IA_cities/"))

library(ggplot2)
ia_counties %>% ggplot() + geom_sf() + geom_sf(data = ia_cities)

ia_counties <- st_transform(ia_counties, '+proj=longlat  +datum=WGS84 +units=m +ellps=WGS84')
st_crs(ia_cities)
ia_cities <- st_transform(ia_cities, '+proj=longlat  +datum=WGS84 +units=m +ellps=WGS84')

#############
# include population estimates in county shape files
population <- read.csv("rawdata/co-est2019-alldata.csv") # same data as from shiny app training

ia_counties <- ia_counties %>% left_join(population %>% filter(STATE==19) %>%
                       select(COUNTY, CENSUS2010POP, POPESTIMATE2019),
                     by=c("CO_FIPS"= "COUNTY"))

ia_counties <- ia_counties %>% select(names(ia_counties)[-9], "geometry")

usethis::use_data(ia_counties, overwrite = TRUE)
usethis::use_data(ia_cities, overwrite = TRUE)

#sf_proj_info(type = "proj", file.path(path_to_box, "allData/geo data/shapfiles/Counties/"))

#spdf_lon_lat <- st_transform(ia_counties, 26915)
#spdf_lon_lat %>% ggplot() + geom_sf()

##############
library(tidycensus)

# need to have key for CENSUS_API set
ia_places <- get_decennial(
  geography = "place",
  variables = c("P1_001N"),
  state="IA",
  year = 2020,
  geometry =T
)
ia_places <- st_transform(ia_places, '+proj=longlat  +datum=WGS84 +units=m +ellps=WGS84')
names(ia_places) <- tolower(names(ia_places))

ia_places <- ia_places %>% mutate(
  name = gsub(" city, Iowa", "", name)
)

usethis::use_data(ia_places, overwrite = TRUE)


