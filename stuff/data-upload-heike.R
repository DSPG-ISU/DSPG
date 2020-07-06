library(tidyverse)
path_to_box <- "~/Box/DSPG Shared Data/Syscare_Scraped_Data/"
files <- dir(path_to_box, pattern = "csv", recursive = TRUE,
             full.names = TRUE)

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

acs <- readr::read_csv(files[1])

# add two variables: Latitude and Longitude
acs <- data.frame(acs, text_to_geometry(acs$Location))
# convert Longitude and Latitude into point object
acs <- acs %>% sf::st_as_sf(coords = c("Longitude", "Latitude"),
                            crs = 4326, agr = "identity")
# remove Location variable
acs <- acs %>% select(-Location)

usethis::use_data(acs, overwrite = TRUE)

