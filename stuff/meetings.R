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

meeting <- meetings %>% rename(
  Format = Types
)

### introduce schedule variable
#meetings$schedule <- with(meetings, lubridate::hm(paste0(Time, AmPm)))
# hm does not respect am or pm
times <- with(meetings, strptime(paste0(Time, AmPm), format = "%I:%M%p"))
meetings$schedule <- with(meetings, lubridate::hm(paste(hour(times), minute(times), sep=":")))

meetings$Day <- factor(meetings$Day,
                       levels = c("Monday", "Tuesday", "Wednesday",
                                  "Thursday", "Friday", "Saturday",
                                  "Sunday"))
helper <- as.numeric(meetings$Day) -1
meetings$schedule <- meetings$schedule + days(helper)
usethis::use_data(meetings, overwrite = TRUE)


nas <- read.csv("rawdata/Iowa_NA_mtgs.csv", stringsAsFactors = FALSE)
nas <- nas %>% rename(
  Day = day
)
# make sure that the weekday names are fine:
unique(nas$Day)
# fix, if not :)

nas$AmPm <- NA
nas$AmPm[grep("PM$", nas$time)] <- "PM"
nas$AmPm[grep("AM$", nas$time)] <- "AM"

nas$Time <- gsub("(.*) [aApP][mM]", "\\1", nas$time)

idx <- which(nas$Time == "Noon")
nas$Time[idx] <- "12:00"
nas$AmPm[idx] <- "PM"

idx <- which(nas$Time == "Midnight")
nas$Time[idx] <- "12:00"
nas$AmPm[idx] <- "AM"

nas <- nas %>% rename(
  Meeting = meeting.name,
  City = town
)

nas <- nas %>% mutate(
  Location = Address,
  City = gsub("(.*), .*", "\\1", City)
)

nas <- nas %>% rename(
  Format = format
)

nas <- nas %>% mutate(
  State = "Iowa",
  Type = "Narcotics Anonymous"
)

nas <- nas %>% mutate(
  Address = paste(Location, City, "Iowa", sep = ", ")
)

###########
nas.locations <- data.frame(
  Address = unique(nas$Address),
  stringsAsFactors = FALSE
)
nas.locations <- nas.locations %>% mutate_geocode(Address)
# write.csv(nas.locations, "meetings-na-locations.csv", row.names = FALSE)
# nas.locations <- read.csv("meetings-na-locations.csv", stringsAsFactors = FALSE)

### and merge back into the meetings:
nas <- nas %>% left_join(nas.locations, by="Address")
###########



### introduce schedule variable
#meetings$schedule <- with(meetings, lubridate::hm(paste0(Time, AmPm)))
# hm does not respect am or pm
times <- with(nas, strptime(paste0(Time, AmPm), format = "%I:%M%p"))
nas$schedule <- with(nas, lubridate::hm(paste(hour(times), minute(times), sep=":")))

nas$Day <- factor(nas$Day,
                       levels = c("Monday", "Tuesday", "Wednesday",
                                  "Thursday", "Friday", "Saturday",
                                  "Sunday"))
helper <- as.numeric(nas$Day) -1
nas$schedule <- nas$schedule + days(helper)

###########
nas <- nas %>% select(names(meetings))

meetings <- rbind(meetings, nas)
usethis::use_data(meetings, overwrite = TRUE)

#############
# some meetings are geocoded outside of Iowa

meetings %>% ggplot(aes(x = lon, y = lat)) + geom_point()

idx <- which(is.na(meetings$lat))
# meetings$Address[idx]
# meetings$lat[idx] <- 42.725476
# meetings$lon[idx] <- -92.468344


eps <- 10e-8
idx <- which(meetings$lat <= min(meetings$lat)+eps)
# meetings$Address[idx] <- "First Christian Church, 25th Street & University Avenue, Des Moines, Iowa"
# meetings$lat[idx] <- 41.600392
# meetings$lon[idx] <- -93.6509382

eps <- 10e-8
idx <- which(meetings$lat <= min(meetings$lat)+eps)
# meetings$Address[idx]
# meetings$lat[idx] <- 41.6565823
# meetings$lon[idx] <- -95.3232809


###
# remove non ASCII
# meetings[1376,]$Location <- "120 East Bremer Avenue"
# meetings[1376,]$Address <- "120 East Bremer Avenue, Waverly, Iowa"


usethis::use_data(meetings, overwrite = TRUE)
