load("rawdata/presidential_precincts_2016.rda")
# loads object df1

ia_election_2016 <- df1 %>% filter(state_postal=="IA")
# clean-up: get rid of all variables that have missing values only
num_mis <- ia_election_2016 %>% purrr::map_dbl(.f = function(x) sum(is.na(x)))
ia_election_2016 <- ia_election_2016 %>% select(-which(num_mis == nrow(ia_election_2016)))

# don't include all of the constant variables:
ia_election_2016 <- ia_election_2016 %>% select(-starts_with("state_"))
ia_election_2016 <- ia_election_2016 %>% select(-c("stage", "special"))

ia_election_2016 <- ia_election_2016 %>% select(-c("district", "office"))

# geographic lat and long is for county
ia_election_2016 <- ia_election_2016 %>% select(-c("county_lat", "county_long"))


# author: MIT Election Data and Science Lab (Massachusetts Institute of Technology)
# Description 	This dataset contains precinct-level returns for elections to the U.S. presidency on November 8, 2016.

usethis::use_data(ia_election_2016, overwrite = TRUE)




#########################
# precinct shapefiles

library(sf)
library(tidyverse)
ia_precincts <- read_sf("rawdata/pcts_04172014_0908am/Precincts041714.shp")

ia_precincts <- ia_precincts %>% st_transform(crs = '+proj=longlat +datum=WGS84 +ellps=GRS80 +no_defs')
# Urbandale 12 doesn't seem to exist anymore - polygon should be combined with GRIMES2
usethis::use_data(ia_precincts, overwrite = TRUE)

leaflet() %>%
  addTiles() %>%
  addPolygons(data = ia_counties) %>%
  addPolygons(data = ia_precincts, color = "red")


####################################

# precinct IDs
# from "https://sos.iowa.gov/elections/results/precinctvotetotals2016primary.html"

precinct_iowa <- readr::read_csv("rawdata/election-precincts-ia.csv")
precinct_iowa <- precinct_iowa %>%
  pivot_longer(cols = -(1:3), names_to="precincts", values_to="votes")

precinct_iowa <- precinct_iowa %>%
  mutate(
    mode = case_when(
      str_ends(precincts, "Polling") ~ "Polling",
      str_ends(precincts, "Absentee") ~ "Absentee",
      str_ends(precincts, "Total") ~ "Total"
    )
  )

precinct_iowa <- precinct_iowa %>%
  mutate(
    county = gsub("([^-]+)-.*", "\\1",precincts)
  )

precinct_iowa <- precinct_iowa %>%
  mutate(
    precincts = gsub(" Absentee$", "", precincts),
    precincts = gsub(" Total$", "", precincts),
    precincts = gsub(" Polling$", "", precincts),
    precincts = gsub("([^-]+)-(.*)", "\\2",precincts)
  )

totals <- precinct_iowa %>% filter(mode=="Total")
totals <- totals %>% group_by(precincts) %>%
  mutate(N = sum(votes))

top <- totals %>% ungroup() %>% group_by(PoliticalPartyName) %>% summarize(count = sum(votes)) %>% arrange(desc(count))

tw <- totals %>%
  filter(PoliticalPartyName %in% top$PoliticalPartyName[1:3]) %>%
  select(-CandidateName) %>%
  pivot_wider(names_from = "PoliticalPartyName", values_from="votes")

######
# summarize tw some more

tw <- tw %>% select(-RaceTitle, -mode) %>%
  mutate(
    Other = N - (`Republican Party` + `Democratic Party` + `Libertarian Party`)
  )

tw <- tw %>% mutate(
  PctRep16 = `Republican Party`/N*100,
  PctDem16 = `Democratic Party`/N*100,
  PctLib16 = `Libertarian Party`/N*100,
  PctOther16 = Other/N*100
)

tw <- tw %>% select(-`Republican Party`, - `Democratic Party`, -`Libertarian Party`)
tw <- tw %>% select(-Other)
tw <- tw %>% rename(Votes16 = N)

# creates join - very tediously
write.csv(tw %>% select(county, precincts) %>% unique(), file = "tw-precincts.csv", row.names = FALSE)
write.csv(ia_election_2016 %>% select(jurisdiction, precinct) %>% unique(), file = "ia-precincts.csv", row.names = FALSE)

ia_precincts2 <- ia_precincts %>% st_centroid()
ia_precincts2 <- ia_precincts2 %>% st_transform(crs='+proj=longlat +datum=WGS84 +ellps=GRS80 +no_defs') %>%
  st_join(ia_counties %>% select(geometry, COUNTY), st_within)

write.csv(ia_precincts2 %>% select(COUNTY, DISTRICT, NAME) %>% st_drop_geometry(), file = "precincts.csv", row.names = FALSE)
ia_precincts$COUNTY <- ia_precincts2$COUNTY

usethis::use_data(ia_precincts, overwrite = TRUE)


which(sort(unique(ia_precincts$COUNTY)) !=
sort(unique(tw$county)))

join <- read_csv("rawdata/ia-precinct-conversion.csv")
ia_precincts <- ia_precincts %>% left_join(join, by=c("COUNTY", "DISTRICT", "NAME"))
ia_precincts2 <- ia_precincts %>% left_join(
  tw %>% mutate(
    county = ifelse(county=="O'Brien", "Obrien", county),
    precincts = gsub(" +", " ", precincts),
    precincts = trimws(precincts)
    ),
  by=c("precinct"="precincts", "COUNTY"="county"))

ia_precincts2 <- ia_precincts2 %>% st_drop_geometry()
st_geometry(ia_precincts2) <- st_geometry(ia_precincts)

ia_precincts2 <- ia_precincts2 %>% select(-OBJECTID, - OBJECTID_1, -ID, -MEMBERS,
                                    -LOCKED, -DEVIATION)

names(ia_precincts2)
ia_precincts <- ia_precincts2 %>% select(
  COUNTY, DISTRICT, precinct, NAME, POPULATION,
  Votes16, PctRep16, PctDem16, PctLib16, PctOther16,
  House_Dist, Senate_Dis, Congressio, AREA, Shape_Leng,
  geometry
  )

usethis::use_data(ia_precincts, overwrite = TRUE)

####################################
library(leaflet)


pal <- colorNumeric(palette=c("Darkred", "White", "Darkblue"),
                    reverse = TRUE,
                    domain = range(ia_precincts$PctRep16 - ia_precincts$PctDem16, na.rm=TRUE))

ia_precincts %>%
  leaflet() %>%
  addTiles() %>%
  addPolygons(fillColor = ~pal(PctRep16-PctDem16), fillOpacity = .75,
              stroke=0, opacity = 1,
              label=~NAME) %>%
  addLegend(pal=pal, values  = range(ia_precincts$PctRep16 - ia_precincts$PctDem16, na.rm=TRUE))

# summarize presidential election outcome by precinct
