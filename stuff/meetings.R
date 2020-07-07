library(tidyverse)
library(lubridate)

meetings <- read.csv("rawdata/Iowa_AA_mtgs_clean.csv", stringsAsFactors = FALSE)

# don't need first variable of row ids
meetings <- meetings %>% select(-X)

# convert meeting times into times
meetings$time <- ymd_hm(paste0("2020/07/04", meetings$Time, meetings$AmPm))
meetings %>% ggplot(aes(x = time)) + geom_histogram()


### get location of meetings
library(ggmap)
meetings$Address <- paste(meetings$Address,
                          meetings$City, "IA", sep = ", ")
locations <- data.frame(address=unique(meetings$Address), stringsAsFactors = FALSE)
locations <- locations %>% mutate_geocode(address)
# write.csv(locations, "meetings-locations.csv", row.names = FALSE)
# locations <- read.csv("meetings-locations.csv", stringsAsFactors = FALSE)

### and merge back into the meetings:
meetings <- meetings %>% left_join(locations, by=c("Address"="address"))
###########

meetings %>% ggplot(aes(x = lon, y = lat)) + geom_point()
# # some meetings are clearly not inside Iowa
# # checking manually with google maps
# idx <- which.min(meetings$lon)
# meetings$Address[idx]
# meetings$lat[idx] <- 41.5563782
# meetings$lon[idx] <- -95.8932262
#
# idx <- which.min(meetings$lat)
# meetings$Address[idx]
# meetings$lat[idx] <- 42.5064581
# meetings$lon[idx] <- -94.1850045
#
# idx <- which.min(meetings$lat)
# meetings$Address[idx]
# meetings$lat[idx] <- 42.5029071
# meetings$lon[idx] <- -96.4020678
#
# idx <- which.max(meetings$lon)
# meetings$Address[idx]
# meetings$lat[idx] <- 42.4005332
# meetings$lon[idx] <- -96.3506922


usethis::use_data(meetings, overwrite = TRUE)
