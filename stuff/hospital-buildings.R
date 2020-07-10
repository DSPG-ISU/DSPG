library(tidyverse)
file = "~/Box Sync/DSPG Shared Data/Syscare_Scraped_Data/Iowa-Hospital-Buildings.csv"

text_to_geometry <- function(x) {
  # input: vector of characters of the form POINT (-93.5878033 41.5620619)
  # output: data frame of the same length as input with columns Longitude and Latitude

  # split along the white space
  listx <- strsplit(x, split=" ")
  arrayx <- matrix(unlist(listx), ncol = 3, byrow=TRUE)

  data.frame(
    Longitude = parse_number(arrayx[,2]),
    Latitude = parse_number(arrayx[,3])
  )
}

hospital_buildings <- readr::read_csv(file)

# add two variables: Latitude and Longitude
hospital_buildings <- data.frame(hospital_buildings, text_to_geometry(hospital_buildings$`Primary Point (Coordinates)`))

hospital_buildings %>%
  ggplot(aes(x = Longitude, y = Latitude)) + geom_point()


idx <- which(hospital_buildings$Longitude > -25)
hospital_buildings[idx,]
#

# convert Longitude and Latitude into point object
hospital_buildings <- hospital_buildings %>% sf::st_as_sf(coords = c("Longitude", "Latitude"),
                            crs = 4326, agr = "identity")
# remove Primary Point Coordinates variable
hospital_buildings <- hospital_buildings %>% select(-Primary.Point..Coordinates.)

usethis::use_data(hospital_buildings, overwrite = TRUE)
####
# there's some values with a location of 0,0

hospital_buildings %>%
  ggplot() +
  geom_sf()

