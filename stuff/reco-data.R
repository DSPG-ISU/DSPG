library(tidyverse)
#url <- "/Users/heike/Documents/DSPG REU program/shiny-apps/rosc/Reco_Data.csv"
recovery <- read_csv("raw/Reco_Treatment_Geocoded_Final.csv")

head(recovery)
use_data(recovery)

recovery <- recovery %>%
  select(-X1)

source("stuff/helper-functions.R")
roxify(recovery)

usethis::use_data(recovery, overwrite = TRUE)
