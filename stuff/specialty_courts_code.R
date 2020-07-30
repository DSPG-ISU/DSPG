library(tidyverse)
library(ggplot2)
library(dplyr)

# 1.	Renamed iowa_specialty_courts.csv
# 2.	Column names changed to snake_case
# 3.	Added column “dataset” with name of dataset
# 4.	Added column “classification” = drug_courts
# 5.  Changed id to 1-indexed

specialty_courts <- readr::read_csv("D:/Documents/DSPG/syscare/iowa_specialty_courts.csv")
usethis::use_data(specialty_courts, overwrite = TRUE)
