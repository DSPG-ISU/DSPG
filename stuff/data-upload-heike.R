library(tidyverse)
path_to_box <- "~/Box/DSPG Shared Data/Syscare_Scraped_Data/"
files <- dir(path_to_box, pattern = "csv", recursive = TRUE,
             full.names = TRUE)

acs <- readr::read_csv(files[1])
usethis::use_data(acs)



names(colleges)[8:9] <- c("Longitude", "Latitude")
usethis::use_data(colleges, overwrite = TRUE)
