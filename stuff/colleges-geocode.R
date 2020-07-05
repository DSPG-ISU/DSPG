library(tidyverse)
library(ggmap)
path_to_box <- "~/Box/DSPG Shared Data/12. Towns with Universities and Colleges/"
files <- dir(path_to_box, pattern = "csv", recursive = TRUE,
             full.names = TRUE)

colleges <- readr::read_csv(files[1])

colleges <- colleges %>% mutate(
  ENROLMENT = parse_number(ENROLMENT)
)

colleges <- colleges %>% mutate(
  address = paste(SCHOOL, CITY, "IA", sep = ", ")
)

colleges <- colleges %>% mutate_geocode(address)

names(colleges)[8:9] <- c("Longitude", "Latitude")
usethis::use_data(colleges, overwrite = TRUE)
