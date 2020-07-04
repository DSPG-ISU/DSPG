path_to_box <- "~/Box/DSPG@ISU/Projects/"
library(sf)

ia_counties <- read_sf(file.path(path_to_box, "allData/geo data/shapfiles/Counties/"))
ia_cities <- read_sf(file.path(path_to_box, "allData/geo data/shapfiles/IA_cities/"))

ia_counties %>% ggplot() + geom_sf() + geom_sf(data = ia_cities)

ia_counties <- st_transform(ia_counties, 26915)
st_crs(ia_cities)
ia_cities <- st_transform(ia_cities, 26915)

usethis::use_data(ia_counties, overwrite = TRUE)
usethis::use_data(ia_cities, overwrite = TRUE)

sf_proj_info(type = "proj", file.path(path_to_box, "allData/geo data/shapfiles/Counties/"))

spdf_lon_lat <- st_transform(ia_counties, 26915)
spdf_lon_lat %>% ggplot() + geom_sf()
