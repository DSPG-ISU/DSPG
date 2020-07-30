library(tidyverse)
library(ggplot2)
library(dplyr)

# 1.	Renamed wikipedia.csv
# 2.	Column names changed to snake_case
# 3.	Added column “dataset” with name of dataset
# 4.	Added column “classification” = hospitals_clinics
# 5.	Added column “county” with county it is in

wiki_hospitals <- readr::read_csv("D:/Documents/DSPG/syscare/wikipedia.csv")
usethis::use_data(wiki_hospitals, overwrite = TRUE)
