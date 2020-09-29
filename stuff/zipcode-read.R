
library(tidyverse)

path_to_files <- "raw/tl_2019_us_zcta510/"
library(sf)

zipshapes <- read_sf(path_to_files)

library(ggplot2)
zipshapes %>% ggplot() + geom_sf()

zipshapes <- st_transform(zipshapes, '+proj=longlat  +datum=WGS84 +units=m +ellps=WGS84')
st_crs(ia_cities)
ia_cities <- st_transform(ia_cities, '+proj=longlat  +datum=WGS84 +units=m +ellps=WGS84')


zip_ia <- zipshapes %>% filter(grepl("^5[012]...", ZCTA5CE10))
zip_ia <- zip_ia %>% mutate(
  INTPTLAT10 = parse_number(INTPTLAT10),
  INTPTLON10 = parse_number(INTPTLON10)
)


zip_ia %>%  ggplot() + geom_sf() +
  geom_point(aes(y = INTPTLAT10, x = INTPTLON10))
zip10_ia <- zip_ia

names(zip10_ia)[11:13] <- tolower(names(zip10_ia)[11:13])
zip10_ia <- zip10_ia %>% select(ZCTA5CE10, GEOID10, city, county, type, ALAND10, AWATER10, INTPTLAT10, INTPTLON10, geometry)

source("stuff/helper-functions.R")
roxify(zip10_ia)

usethis::use_data(zip10_ia)

library(rvest)
url <- "https://www.zip-codes.com/state/ia.asp"



doc <- read_html(url)
tab1 <- html_table(doc, fill=TRUE)[[1]]

# first 16 lines are 'stuff'

tab1 <- tab1[-(1:16),1:4]
names <- unlist(as.character(tab1[1,1:4]))
tab1 <- tab1[-1,]
names(tab1) <- names

tab1$`ZIP Code` <- gsub("ZIP Code ", "", tab1$`ZIP Code`)
tab1 <- tab1 %>% filter(!is.na(Type))

anti_join(zip10_ia, tab1, by=c("ZCTA5CE10"="ZIP Code"))
anti_join(tab1, zip10_ia, by=c("ZIP Code"="ZCTA5CE10"))

zip10_ia <- left_join(zip10_ia, tab1, by=c("ZCTA5CE10"="ZIP Code"))

source("stuff/helper-functions.R")
roxify(zip10_ia)

test <- zip_ia %>% select(geometry)
str(test)
test$geometry[[1]] <- c(test$geometry[[1]], NA)

#tab1 <- left_join(tab1, zip10_ia, by=c("ZIP Code"="ZCTA5CE10"))
