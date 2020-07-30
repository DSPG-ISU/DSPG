library(tidyverse)
library(ggmap)
library(ggplot2)
library(dplyr)
library(sf)
library(leaflet)

# Renamed to child_care_client_portal.csv
#	Deleted empty first row
#	Column names changed to snake case
#	Added column "dataset" with "childcare"
#	Added column "classification" = childcare_providers

childcare <- readr::read_csv("D:/Documents/DSPG/syscare/child_care_client_portal.csv")

usethis::use_data(childcare, overwrite = TRUE)


