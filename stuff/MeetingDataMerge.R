#  Iowa Recovery Meetings Data Cleaning and Merging
#
#  Data Sources:
#  https://www.aa-iowa.org/meetings/
#  https://iowa-na.org/na-meetings/
#  https://adultchildren.org/mtsearch
#  https://al-anon.org/al-anon-meetings/find-an-alateen-meeting/
#  http://draonline.qwknetllc.com/meetings_dra/usa/iowa.html
#  https://www.nar-anon.org/find-a-meeting#groupspublic/?view_7_filters=%5B%7B%22field%22%3A%22field_1%22%2C%22operator%22%3A%22near%22%2C%22value%22%3A%22ames%22%2C%22units%22%3A%22miles%22%2C%22range%22%3A%22100000%22%7D%5D&view_7_page=1
#  https://www.smartrecoverytest.org/local/full-meeting-list-download/
#  https://locator.crgroups.info/
#  https://www.facebook.com/crushofiowa/
#  https://refugerecovery.org/meetings?tsml-day=any&tsml-region=iowa
#
#
# Authors: Jessie Bustin
#          Dr. Heike Hoffman - Code to Create Schedule Column


# Load Libraries
library(tidyverse)
library(DSPG)
library(ggmap)
library(lubridate)
library(naniar)

# Load Datasets
adultChildren <- read.csv("Raw/Adult_childern_of_alcoholic.csv", stringsAsFactors = FALSE)
alanon <- read.csv("Raw/al-anon.csv")
idra <- read.csv("Raw/IDRA.csv")
narAnon <- read.csv("Raw/Nar_Anon_Dataset.csv")
smart <- read.csv("Raw/Recovery_Celebrate_SMART_IA_Meetings.csv")

# AdultChildren Change column names and drop unneeded columns
adultChildren <- adultChildren %>%
  mutate(Notes = paste0(Note, "  Code: ", code, " Format: ", Types)) %>%
  select(-c(X, time.zone, zip, code, Note, Types)) %>%
  rename(Meeting = name, Location = Address, Phone = Tel, Contact.Person = contact.person)

# AdultChildren Clean City Column and Create Full Address Column
adultChildren <- adultChildren %>%
  mutate(City = gsub("\\(.*", "", City)) %>%
  mutate(Address = paste0(Location, ", ", City, ", ", State))

# Alanon Separate Time Column
alanon <- alanon %>%
  separate(MEETING_TIME, c("Day", "Time", "AmPm"), sep = "\\ ") %>%
  select(-c(ID, SHOW_MEETINGS_WITH, GROUP_ID, DESCRIPTION)) %>%
  separate(ADDRESS, c("Location", "City", "State"), sep = "\\,", remove = FALSE) %>%
  rename(Meeting = NAME, Address = ADDRESS, Notes = LOCATION_INSTRUCTION,
         Phone = PHONE, Website = WEBSITE, Email = EMAIL) %>%
  mutate(Type = "Al-anon")

# narAnon Split Time Column, Select Columns, and Fix Location/Address Columns
narAnon <- narAnon %>%
  mutate(Location = Street) %>%
  select(-c("ï..", "Zip", "Street")) %>%
  mutate(Time = substr(Time, 0, nchar(Time)-2)) %>%
  mutate(AmPm = "pm") %>%
  mutate(Address = paste0(Location, ", ", City, ", ", State))

# IDRA
idra <- idra %>%
  rename(Notes = Types, Meeting = Name, Location = Address, Phone = Tel, Email = email) %>%
  mutate(Address = paste0(Location, ", ", City, ", ", State))

# Drop Smart Columns and Separate Address
smart <- smart %>%
  select(-Code) %>%
  separate(Address, c("Location"), ", ", remove = FALSE)

# Join Data
non_AANA <- full_join(adultChildren, alanon)
non_AANA <- full_join(non_AANA, idra)
non_AANA <- full_join(non_AANA, narAnon)
non_AANA <- full_join(non_AANA, smart)

# Dropping Website Column
non_AANA <- non_AANA %>%
  select(-Website)

# Geocoding All Data
# -Do not rerun geocoding unless necessary-
#non_AANA <- non_AANA %>%
#  mutate_geocode(location = Address)

#write.csv(non_AANA, "NonAANA_Geocoded.csv")

# Read Geocoded Data Back In
non_AANA <- read.csv("DataMerge/NonAANA_Geocoded.csv")
non_AANA <- non_AANA %>%
  select(-X)

# convert meeting times into times
non_AANA$time <- ymd_hm(paste0("2020/07/04", meetings$Time, meetings$AmPm))

# Edit Day That Wasn't in Factor Levels Because of Typo
non_AANA[2, 2] <- "Wednesday"

### introduce schedule variable
#meetings$schedule <- with(meetings, lubridate::hm(paste0(Time, AmPm)))
# hm does not respect am or pm
# ---This section of code Was Contributed by Dr. Heike Hoffman---
#
# convert meeting times into times
non_AANA$time <- ymd_hm(paste0("2020/07/04", meetings$Time, meetings$AmPm))

# Edit Day That Wasn't in Factor Levels Because of Typo
non_AANA[2, 2] <- "Wednesday"
times <- with(non_AANA, strptime(paste0(Time, AmPm), format = "%I:%M%p"))
non_AANA$schedule <- with(non_AANA, lubridate::hm(paste(hour(times), minute(times), sep=":")))

non_AANA$Day <- factor(non_AANA$Day,
                       levels = c("Monday", "Tuesday", "Wednesday",
                                  "Thursday", "Friday", "Saturday",
                                  "Sunday"))
helper <- as.numeric(non_AANA$Day) - 1
non_AANA$schedule <- non_AANA$schedule + days(helper)

#Rename and add columns to match new meeting data columns
non_AANA <- non_AANA %>%
  rename(street = Location) %>%
  mutate(classification = "substance abuse treatment meetings") %>%
  select(-time)

#Data to
# Merge with AA/NA Data
all_meetings <- full_join(meetings, non_AANA)

# lowerCase AmPm column
all_meetings <- all_meetings %>%
  mutate(AmPm = tolower(AmPm))

# Fill in Blanks and NAs in Meeting Column
all_meetings <- all_meetings %>%
  mutate(Meeting = case_when(Meeting == "" ~ Type, is.na(Meeting) ~ Type, TRUE ~ Meeting))

# Fill in blanks in the rest of the Data
#all_meetings <- all_meetings %>%
 # replace_with_na_all(condition = ~.x == "")


# Write to csv
# write.csv(all_meetings, "DataMerge/All_Meetings_Geocoded.csv")
#
# meetings <- all_meetings
#
# meetings$type <- factor(meetings$type)
# levels(meetings$type)[6] <- "Iowa Dual Recovery Anonymous (IDRA)"
# meetings$type <- as.character(meetings$type)
# use_data(meetings, overwrite = TRUE)
#
# idx <- which(str_detect( meetings$address, "\xa0"))
# meetings$address <- str_replace_all(meetings$address, "\xa0", "")
# use_data(meetings, overwrite = TRUE)
#
# meetings$city <- str_replace_all(meetings$city, "\xa0", "")
# use_data(meetings, overwrite = TRUE)
#
# meetings$meeting <- str_replace_all(meetings$meeting, "\xa0", " ")
# use_data(meetings, overwrite = TRUE)

#read in geocoded meeting data
full_meetings <- read.csv("raw/All_Meetings_Geocoded.csv")

full_meetings <- full_meetings %>%
  select(-c("X")) %>%
  rename(street = location, latitude = lat, longitude = lon) %>%
  mutate(classification = "substance abuse treatment meetings") %>%
  mutate(time = substr(time, 1, 5))


#full_meetings$time <- ymd_hm(paste0("2020/07/04", full_meetings$time, full_meetings$ampm))

times <- with(full_meetings, strptime(paste0(time, ampm), format = "%I:%M%p"))
full_meetings$schedule <- with(full_meetings, lubridate::hm(paste(hour(times), minute(times), sep=":")))

full_meetings$day <- factor(full_meetings$day,
                       levels = c("Monday", "Tuesday", "Wednesday",
                                  "Thursday", "Friday", "Saturday",
                                  "Sunday"))
helper <- as.numeric(full_meetings$day) - 1
full_meetings$schedule <- full_meetings$schedule + days(helper)

meetings <- full_meetings

usethis::use_data(meetings, overwrite = TRUE)

meetings$type <- factor(meetings$type)
levels(meetings$type)[6] <- "Iowa Dual Recovery Anonymous (IDRA)"
meetings$type <- as.character(meetings$type)
usethis::use_data(meetings, overwrite = TRUE)

idx <- which(str_detect( meetings$address, "\xa0"))
meetings$address <- str_replace_all(meetings$address, "\xa0", "")
usethis::use_data(meetings, overwrite = TRUE)

meetings$city <- str_replace_all(meetings$city, "\xa0", "")
usethis::use_data(meetings, overwrite = TRUE)

meetings$meeting <- str_replace_all(meetings$meeting, "\xa0", " ")
usethis::use_data(meetings, overwrite = TRUE)


