#' Shapefiles of Iowa's counties
#'
#' provenance - Chris, I need some help with how we document these exports.
#' @format A data frame with 99 rows and 9 variables:
#' \describe{
#'   \item{CO_NUMBER}{county number}
#'   \item{CO_FIPS}{three-digit county fips code}
#'   \item{ACRES_SF}{square footage in acres}
#'   \item{ACRES}{county acreage, same as `ACRES_SF``}
#'   \item{FIPS}{five-digit fips code}
#'   \item{COUNTY}{county name (and it's `Obrien`)}
#'   \item{ST}{two letter state abbreviation (`IA` all the way through)}
#'   \item{ID}{identifier same as `CO_FIPS`}
#'   \item{CENSUS2010POP}{US Census Bureau count of 2010 county population.}
#'   \item{POPESTIMATE2019}{US Census Bureau estimate of 2019 county population.}
#'   \item{geometry}{simple feature object of polygons}
#' }
#' @source \url{some url?}
#' @examples
#' # county map of iowa in ggplot2
#' library(ggplot2)
#' library(dplyr) # for the pipe
#'
#' ia_counties %>%
#'   ggplot() + geom_sf(aes(fill = ACRES_SF)) +
#'   ggthemes::theme_map()
#'
#' # leaflet map
#' library(leaflet)
#' library(sf)
#' st_transform(ia_counties, crs='+proj=longlat +datum=WGS84') %>%
#'   leaflet() %>%
#'     addTiles() %>%
#'     addPolygons()
"ia_counties"

#' Location of Iowa's cities
#'
#' provenance - Chris, I need some help with how we document these exports.
#' @format A data frame with 1069 rows and 17 variables:
#' \describe{
#'   \item{rid}{rid number}
#'   \item{city}{city name}
#'   \item{cityFIPS}{5-digit city fips code}
#'   \item{cityFIPS_1}{7-digit city fips code}
#'   \item{county}{county name}
#'   \item{countyPr}{categorical: 60 0s and 1009 xs.}
#'   \item{countyPr_1}{categorical: 56 0s and 1013 xs.}
#'   \item{countyFI}{double value - maybe an identifier?}
#'   \item{countyFI_1}{looks like FI with an additional 19 in front}
#'   \item{stateNam}{state name - constant value of `Iowa`.}
#'   \item{stateFIP}{state fips code - constant value of 19.}
#'   \item{state}{two-letter state abbreviation - constant value of `IA`}
#'   \item{type}{categorical variable: 1001 0s, one oopsie that probably should be a zero. 59 CDPs 1 other and 7 unincorporated communities.}
#'   \item{popChange}{sf point object - absolute change in population between XXX and XXX?}
#'   \item{currentPop}{sf point object - current population (what is the basis for these numbers?) }
#'   \item{percentChg}{sf point object - percent change in population. }
#'   \item{geometry}{sf point object of IA cities' coordinates.}
#' }
#' @source \url{some url?}
#' @examples
#' # county map of iowa in ggplot2
#' library(ggplot2)
#' library(dplyr) # for the pipe
#'
#' ia_cities %>%
#'   mutate(
#'     growth = cut(percentChg,
#'                  breaks = c(-Inf, -2.5, 2.5, Inf),
#'                  labels = c("2.5% Loss or more", "Stable", "2.5% Growth or more"))) %>%
#'   filter(!is.na(growth)) %>%
#'   ggplot() +
#'     geom_sf(data = ia_counties,
#'             fill="grey95", colour = "grey60", size = 0.1) +
#'     geom_sf(aes(size = currentPop, colour = growth),
#'             alpha = 0.5) +
#'     scale_size_binned("Population", range=c(0.5,3.5)) +
#'     scale_colour_manual("Percent Change\nin Population",
#'               values=c("darkred", "grey30", "darkblue")) +
#'     ggthemes::theme_map() +
#'     theme(legend.position = "right")
#'
#' # leaflet map
#' library(leaflet)
#' library(sf)
#' colors <- c("darkred", "grey30", "darkblue")
#' labels <- c("2.5% Loss or more", "Stable", "2.5% Growth or more")
#' pal <- colorFactor(palette = colors, levels = labels)
#'
#' ia_cities <- st_transform(ia_cities, crs='+proj=longlat +datum=WGS84')
#' ia_cities %>%
#'   mutate(
#'     growth = cut(percentChg,
#'                  breaks = c(-Inf, -2.5, 2.5, Inf),
#'                  labels = labels)) %>%
#'   leaflet() %>%
#'     addTiles() %>%
#'     addPolygons(data = st_transform(ia_counties, crs='+proj=longlat +datum=WGS84'),
#'                 weight = 1, color="#333333") %>%
#'     addCircleMarkers(radius = 1.5, stroke = 0.1, color = ~pal(growth),
#'                      label = ~city) %>%
#'     addLegend(title = "% Change in Population", colors = colors, labels = labels)
"ia_cities"



#' Location of churches in Iowa
#'
#' Dataset was scraped by Masoud Nosrati from the IA Hometown Locator in Mar 2020.
#' @format A data frame with 5469 rows and 9 variables:
#' \describe{
#'    \item{ID}{identifier, not quite the row number XXX we should delete this column and move the GNIS_ID up.}
#'    \item{NAME}{name of the church}
#'    \item{CATEGORY}{value of `Iowa physical, cultural and historic features`}
#'    \item{TYPE}{type of location, constant value of `Cultural`.}
#'    \item{CLASS}{type of structure, constant value of `CHURCH`.}
#'    \item{DESCRIPTION}{closer description of the location, if available}
#'    \item{COUNTY}{name of the county}
#'    \item{GNIS_ID}{USGS identifier}
#'   \item{geometry}{sf point object of geographic locations of churches in Iowa.}
#' }
#' @source \url{https://iowa.hometownlocator.com/features/cultural,class,church.cfm}
#'
#' @examples
#' # Map of churches in Story county using ggplot2
#' library(ggplot2)
#' library(dplyr) # for the pipe
#'
#' churches %>%
#'  # filter(COUNTY == "Story county) %>%
#'   ggplot() +
#'     geom_sf(data = ia_counties) +
#'     geom_sf() +
#'     ggthemes::theme_map()
#'
#' # leaflet map
#' library(leaflet)
#' library(sf)
#'
#' churches %>%
#'   leaflet() %>%
#'     addTiles() %>%
#'     setView(-93.6498803, 42.0275751, zoom = 8) %>%
#'     addPolygons(data = st_transform(ia_counties, crs='+proj=longlat +datum=WGS84'),
#'                 weight = 1, color="#333333") %>%
#'     addCircleMarkers(radius = 1, stroke = 0.1,
#'                      label = ~NAME, clusterOptions = markerClusterOptions())
"churches"

#' Location of parks in Iowa
#'
#' Dataset was scraped by Masoud Nosrati from MyCountyParks in Mar 2020, geocoding by Andrew Maloney through QGIS.
#' @format A data frame with 1645 rows and 15 variables:
#' \describe{
#'    \item{ID}{identifier, not quite the row number}
#'    \item{NAME}{name of the park}
#'    \item{COUNTY}{name of the county}
#'    \item{STREET}{street name}
#'    \item{CITY}{name of the city}
#'    \item{STATE}{name of the state}
#'    \item{PHONE}{phone number}
#'    \item{ZIP}{5-digit zip code}
#'    \item{result_num}{1645 0s XXX delete column?}
#'    \item{status}{1645 OKs XXX delete column?}
#'    \item{formatted_}{formatted addresses - some are duplicates - XXX look into}
#'    \item{place_id}{identifier, based on address? - some are duplicates - XXX look into}
#'    \item{location_t}{categorical variable with additional details on location.}
#'    \item{Latitude}{geographic latitude}
#'    \item{Longitude}{geographic longitude}
#' }
#' @source \url{https://www.mycountyparks.com/County/Default.aspx}
#' @examples
#' # Map of parks in Iowa county using ggplot2
#' library(ggplot2)
#' library(dplyr) # for the pipe
#'
#' parks %>%
#'  # filter(COUNTY == "Story county) %>%
#'   ggplot() +
#'     geom_point(aes(x = Longitude, y = Latitude))
#'
#' # leaflet map
#' library(leaflet)
#' library(sf)
#'
#' parks %>%
#'   leaflet() %>%
#'     addTiles() %>%
#' #    setView(-93.6498803, 42.0275751, zoom = 8) %>%
#'     addPolygons(data = st_transform(ia_counties, crs='+proj=longlat +datum=WGS84'),
#'                 weight = 1, color="#333333") %>%
#'     addCircleMarkers(lng = ~Longitude, lat = ~Latitude,
#'                      radius = 1, stroke = 0.1,
#'                      label = ~NAME)
"parks"


#' Location of Licensed Substance Use Disorder/Problem Gambling Programs in Iowa
#'
#' Dataset was scraped by Masoud Nosrati from the Iowa Department of Public Health Development in Mar 2020, geocoding by Andrew Maloney through QGIS.
#' @format A data frame with 123 rows and 15 variables:
#' \describe{
#'    \item{ID}{identifier, not quite the row number}
#'    \item{NAME}{name of the facility}
#'    \item{PHONE}{phone number}
#'    \item{STREET}{street address}
#'    \item{CITY}{city}
#'    \item{STATE}{state}
#'    \item{ZIP}{5-digit zip code}
#'    \item{FACILITY}{enumeration of abbrevations}
#'    \item{result_num}{0s XXX delete column?}
#'    \item{status}{OKs XXX delete column?}
#'    \item{formatted_}{formatted addresses - some are duplicates - XXX look into}
#'    \item{place_id}{identifier, based on address? - some are duplicates - XXX look into}
#'    \item{location_t}{categorical variable with additional details on location.}
#'    \item{Latitude}{geographic latitude}
#'    \item{Longitude}{geographic longitude}
#' }
#' @source \url{https://www.iowaworkforcedevelopment.gov/contact}
#' @examples
#' # Map of centers in Iowa  using ggplot2
#' library(ggplot2)
#' library(dplyr) # for the pipe
#'
#' sud %>%
#'   ggplot() +
#'     geom_point(aes(x = Longitude, y = Latitude))
#'
#' # leaflet map
#' library(leaflet)
#' library(sf)
#'
#' sud %>%
#'   group_by(NAME,formatted_, PHONE) %>%
#'   mutate(
#'     hovertext = htmltools::HTML(paste0(NAME, "<br>",formatted_, '<br>', PHONE))
#'   ) %>%
#'   leaflet() %>%
#'     addTiles() %>%
#'     addPolygons(data = st_transform(ia_counties, crs='+proj=longlat +datum=WGS84'),
#'                 weight = 1, color="#333333") %>%
#'     addCircleMarkers(lng = ~Longitude, lat = ~Latitude,
#'                      radius = 1, stroke = 0.1,
#'                      label = ~hovertext)
"sud"


#' Location of IowaWORKS Centers in Iowa
#'
#' Dataset was scraped by Masoud Nosrati from the Iowa Workforce Development in Mar 2020, geocoding by Andrew Maloney through QGIS.
#' @format A data frame with 27 rows and 18 variables:
#' \describe{
#'    \item{ID}{identifier, not quite the row number}
#'    \item{NAME}{enumeration of counties the center serves}
#'    \item{TYPE}{Center - XXX delete}
#'    \item{STREET}{street address}
#'    \item{CITY}{city}
#'    \item{STATE}{state}
#'    \item{ZIP}{5-digit zip code}
#'    \item{PHONE}{phone number}
#'    \item{EMAIL}{email address}
#'    \item{AREA}{NAs - XXX delete}
#'    \item{LINK}{weblink to the center}
#'    \item{result_num}{0s XXX delete column?}
#'    \item{status}{OKs XXX delete column?}
#'    \item{formatted_}{formatted addresses - some are duplicates - XXX look into}
#'    \item{place_id}{identifier, based on address? - some are duplicates - XXX look into}
#'    \item{location_t}{categorical variable with additional details on location.}
#'    \item{Latitude}{geographic latitude}
#'    \item{Longitude}{geographic longitude}
#' }
#' @source \url{https://www.iowaworkforcedevelopment.gov/contact}
#' @examples
#' # Map of centers in Iowa  using ggplot2
#' library(ggplot2)
#' library(dplyr) # for the pipe
#'
#' iowaworks %>%
#'   ggplot() +
#'     geom_point(aes(x = Longitude, y = Latitude))
#'
#' # leaflet map
#' library(leaflet)
#' library(sf)
#'
#' iowaworks %>%
#'   group_by(NAME, PHONE) %>%
#'   mutate(
#'     hovertext = htmltools::HTML(paste0("IowaWORKS Center<br>",formatted_,
#'                                        '<br>serving ', NAME, '<br>', PHONE))
#'   ) %>%
#'   leaflet() %>%
#'     addTiles() %>%
#'     addPolygons(data = st_transform(ia_counties, crs='+proj=longlat +datum=WGS84'),
#'                 weight = 1, color="#333333") %>%
#'     addCircleMarkers(lng = ~Longitude, lat = ~Latitude,
#'                      radius = 1, stroke = 0.1,
#'                      label = ~hovertext)
"iowaworks"


#' Location of MAT in Iowa
#'
#' This dataset provides doctors available in Medication Assisted Treatment (MAT) facilities in Iowa.
#' Dataset was scraped by Masoud Nosrati from the Iowa Department of Public Health in Mar 2020, geocoding by Andrew Maloney through QGIS.
#' @format A data frame with 145 rows and 15 variables:
#' \describe{
#'    \item{ID}{identifier, not quite the row number}
#'    \item{DOCTOR}{name of the medical personnel}
#'    \item{CENTER}{MAT center}
#'    \item{STREET}{street address}
#'    \item{CITY}{city}
#'    \item{STATE}{state}
#'    \item{ZIP}{5-digit zip code}
#'    \item{PHONE}{phone number}
#'    \item{TREATMENT}{treatment options: methadone and/or buprenorphine}
#'    \item{result_num}{0s XXX delete column?}
#'    \item{status}{OKs XXX delete column?}
#'    \item{formatted_}{formatted addresses - some are duplicates - XXX look into}
#'    \item{place_id}{identifier, based on address? - some are duplicates - XXX look into}
#'    \item{location_t}{categorical variable with additional details on location.}
#'    \item{Latitude}{geographic latitude}
#'    \item{Longitude}{geographic longitude}
#' }
#' @source \url{https://iowa.maps.arcgis.com/apps/LocalPerspective/index.html?appid=924e0f99711b406dbf22a34cf46fc6e1}
#' @examples
#' # Map of hospitals in Iowa  using ggplot2
#' library(ggplot2)
#' library(dplyr) # for the pipe
#'
#' mat %>%
#'   ggplot() +
#'     geom_point(aes(x = Longitude, y = Latitude))
#'
#' # leaflet map
#' library(leaflet)
#' library(sf)
#'
#' mat %>%
#'   group_by(DOCTOR, CENTER) %>%
#'   mutate(
#'     hovertext = htmltools::HTML(paste0(DOCTOR, '<br>', CENTER, '<br>', PHONE))
#'   ) %>%
#'   leaflet() %>%
#'     addTiles() %>%
#' #    setView(-93.6498803, 42.0275751, zoom = 8) %>%
#'     addPolygons(data = st_transform(ia_counties, crs='+proj=longlat +datum=WGS84'),
#'                 weight = 1, color="#333333") %>%
#'     addCircleMarkers(lng = ~Longitude, lat = ~Latitude,
#'                      radius = 1, stroke = 0.1,
#'                      label = ~hovertext,
#'                      clusterOptions = markerClusterOptions())
"mat"




#' Location of hospitals in Iowa
#'
#' Dataset was scraped by Masoud Nosrati from Official USA in Mar 2020, geocoding by Andrew Maloney through QGIS.
#' @format A data frame with 145 rows and 15 variables:
#' \describe{
#'    \item{ID}{identifier, not quite the row number}
#'    \item{City}{name of the city}
#'    \item{Hospital.N}{name of the hospital - XXX rename to NAME}
#'    \item{TYPE}{type of hospital, one of 'critical access', 'general acute care', 'psychiatric', 'long term care', and 'military'}
#'    \item{WEBSITE}{url if available}
#'    \item{ADDRESS}{address of the health clinic}
#'    \item{BEDS}{number of BEDS}
#'    \item{NAICS_DESC}{North American Industry Classification System (NAICS) descriptor: 'general medical and surgical hospital' or 'specialty hospital'}
#'    \item{result_num}{145 0s XXX delete column?}
#'    \item{status}{145 OKs XXX delete column?}
#'    \item{formatted_}{formatted addresses - some are duplicates - XXX look into}
#'    \item{place_id}{identifier, based on address? - some are duplicates - XXX look into}
#'    \item{location_t}{categorical variable with additional details on location.}
#'    \item{Latitude}{geographic latitude}
#'    \item{Longitude}{geographic longitude}
#' }
#' @source \url{https://www.officialusa.com/stateguides/health/hospitals/iowa.html}
#' @examples
#' # Map of hospitals in Iowa  using ggplot2
#' library(ggplot2)
#' library(dplyr) # for the pipe
#'
#' hospitals %>%
#'   ggplot() +
#'     geom_point(aes(x = Longitude, y = Latitude))
#'
#' # leaflet map
#' library(leaflet)
#' library(sf)
#'
#' hospitals %>%
#'   leaflet() %>%
#'     addTiles() %>%
#' #    setView(-93.6498803, 42.0275751, zoom = 8) %>%
#'     addPolygons(data = st_transform(ia_counties, crs='+proj=longlat +datum=WGS84'),
#'                 weight = 1, color="#333333") %>%
#'     addCircleMarkers(lng = ~Longitude, lat = ~Latitude,
#'                      radius = 1, stroke = 0.1,
#'                      label = ~Hospital.N,
#'                      clusterOptions = markerClusterOptions())
"hospitals"



#' Location of rural health clinics in Iowa
#'
#' Dataset was scraped by Masoud Nosrati from the Iowa Association of Rural Health Clinics in Mar 2020, geocoding by Andrew Maloney through QGIS.
#' @format A data frame with 146 rows and 11 variables:
#' \describe{
#'    \item{ID}{identifier, not quite the row number}
#'    \item{NAME}{name of the clinic}
#'    \item{ADDRESS}{address of the health clinic}
#'    \item{COUNTY}{name of the county}
#'    \item{result_num}{146 0s XXX delete column?}
#'    \item{status}{146 OKs XXX delete column?}
#'    \item{formatted_}{formatted addresses - some are duplicates - XXX look into}
#'    \item{place_id}{identifier, based on address? - some are duplicates - XXX look into}
#'    \item{location_t}{categorical variable with additional details on location.}
#'    \item{Latitude}{geographic latitude}
#'    \item{Longitude}{geographic longitude}
#' }
#' @source \url{https://iarhc.org/find-a-rural-health-clinic?view=map}
#' @examples
#' # Map of rural health clinics in Iowa using ggplot2
#' library(ggplot2)
#' library(dplyr) # for the pipe
#'
#' health.clinics %>%
#'   ggplot() +
#'     geom_point(aes(x = Longitude, y = Latitude))
#'
#' # leaflet map
#' library(leaflet)
#' library(sf)
#'
#' health.clinics %>%
#'   leaflet() %>%
#'     addTiles() %>%
#' #    setView(-93.6498803, 42.0275751, zoom = 8) %>%
#'     addPolygons(data = st_transform(ia_counties, crs='+proj=longlat +datum=WGS84'),
#'                 weight = 1, color="#333333") %>%
#'     addCircleMarkers(lng = ~Longitude, lat = ~Latitude,
#'                      radius = 1, stroke = 0.1,
#'                      label = ~NAME)
"health.clinics"


#' Location of colleges and universities in Iowa
#'
#' Dataset was scraped by Masoud Nosrati from wikipedia in Mar 2020, geocoding by Heike Hofmann through Google API.
#' @format A data frame with 57 rows and 11 variables:
#' \describe{
#'    \item{SCHOOL}{name of school}
#'    \item{CITY}{name of the clinic}
#'    \item{CONTROL}{type of institution by funding}
#'    \item{TYPE}{type of institution by degree}
#'    \item{ENROLMENT}{number of students enrolled (in Spring 2012)}
#'    \item{FOUNDED}{year in which the institution was founded}
#'    \item{address}{address used in search string for Google geocoding}
#'    \item{Latitude}{geographic latitude}
#'    \item{Longitude}{geographic longitude}
#' }
#' @source \url{https://en.wikipedia.org/wiki/List_of_colleges_and_universities_in_Iowa}
#' @examples
#' # Map of rural health clinics in Iowa using ggplot2
#' library(ggplot2)
#' library(dplyr) # for the pipe
#'
#' colleges %>%
#'   ggplot() +
#'     geom_point(aes(x = Longitude, y = Latitude))
#'
#' # leaflet map
#' library(leaflet)
#' library(sf)
#'
#' colleges %>%
#'   leaflet() %>%
#'     addTiles() %>%
#'     addPolygons(data = st_transform(ia_counties, crs='+proj=longlat +datum=WGS84'),
#'                 weight = 1, color="#333333") %>%
#'     addCircleMarkers(lng = ~Longitude, lat = ~Latitude,
#'                      radius = 1, stroke = 0.1,
#'                      label = ~SCHOOL)
"colleges"

#' American Community Survey - Computer Presence
#'
#' Summary data of Iowa American Community Survey responses by computer presence and internet subscription status. Each row represents a combination of variables and the households variable representing the number of households estimated to be associated with that variable combination.
#' @format A data frame with 99 rows and 9 variables:
#' \describe{
#'   \item{Geography.Id}{geographic ID used by the U.S. census for the location associated with this record}
#'   \item{Type}{The type of location associated with this record. Categories are state, county, place, and tract}
#'   \item{Name}{Name of the location}
#'   \item{Variable}{Variable ID identified by the U.S. Census Bureau}
#'   \item{Variable.Description}{Description of the variable}
#'   \item{Computer.Present}{Classifies if a computer is present in those households. Categories are total, yes, and no}
#'   \item{Internet.Subscription}{Classifies what kind of internet subscription is present in those households. Categories are total, total w/computer, broadband, dial-up, and none}
#'   \item{Data.Collection.Period}{Period in which the data was collected}
#'   \item{Data.Collection.End.Date}{The date in which the data was done being collected}
#'   \item{Households}{The number of households estimated to have the specified characteristics in the record}
#'   \item{Row.ID}{Unique ID associated with the record}
#'   \item{geometry}{sf point object of geographic location}
#' }
#' @source \url{https://data.iowa.gov/Utilities-Telecommunications/Iowa-Households-by-Presence-of-a-Computer-and-Type/gz3j-hzab}
#' @examples
#' # county map of iowa in ggplot2
#' library(ggplot2)
#' library(dplyr) # for the pipe
#'
#' ia_counties %>%
#'   ggplot() + geom_sf(aes(fill = ACRES_SF)) +
#'   ggthemes::theme_map()
#'
#' # leaflet map
#' library(leaflet)
#' library(sf)
#' st_transform(ia_counties, crs='+proj=longlat +datum=WGS84') %>%
#'   leaflet() %>%
#'     addTiles() %>%
#'     addPolygons()
"acs"


#' Location of ASAC (Area Substance Abuse Counseling) in Iowa
#'
#' Dataset was scraped from the ASAC website.
#' This database contains ASAC location data for the State of Iowa
#' @format A data frame with 15 rows and 9 variables:
#' \describe{
#'   \item{Name}{Name of the facility}
#'   \item{Address}{Street Address for the facility}
#'   \item{City_State_Zip}{City, State, and Zip contained in one column separated by a space}
#'   \item{City}{Name of the city where the facility is located}
#'   \item{Zip}{5 digit Zip}
#'   \item{State}{State Abbreviation}
#'   \item{search_address}{address used in the Google API geocoding}
#'   \item{lon}{geographic Longitude}
#'   \item{lat}{geographic Latitude}
#' }
#' @source \url{http://www.asac.us/about/locations/}
#' @examples
#' library(ggplot2)
#' library(dplyr)
#' asac_locations %>%
#'  ggplot() +
#'  geom_point(aes(x = lon, y = lat))
#'
#' library(leaflet)
#' library(sf)
#' asac_locations %>%
#'  leaflet() %>%
#'  addTiles() %>%
#'  addPolygons(data = st_transform(ia_counties, crs='+proj=longlat +datum=WGS84'),
#'              weight = 1, color="#333333") %>%
#'  addCircleMarkers(lng = ~lon, lat = ~lat,
#'                   radius = 1, stroke = 0.1)
"asac_locations"


#' Community and Family Resources
#'
#' Dataset was scraped from the Community and Family Resources website.
#' This database contains Community and Family Resources location data for the State of Iowa.
#' @format A data frame with 10 rows and 8 variables:
#' \describe{
#'   \item{Address}{Street address for the facility}
#'   \item{City}{Character string containing city name}
#'   \item{State}{State Abbreviation}
#'   \item{Zip}{5 digit zip code}
#'   \item{Name}{Facility Name, only 3 locations have unique names}
#'   \item{search_address}{address used in the Google API geocoding}
#'   \item{lon}{geographic Longitude}
#'   \item{lat}{geographic Latitude}
#' }
#' @source \url{http://www.cfrhelps.org/our-locations}
#' @examples
#' library(ggplot2)
#' library(dplyr)
#' cf_resources %>%
#'  ggplot() +
#'  geom_point(aes(x = lon, y = lat))
#'
#' library(leaflet)
#' library(sf)
#' cf_resources %>%
#'  leaflet() %>%
#'  addTiles() %>%
#'  addPolygons(data = st_transform(ia_counties, crs='+proj=longlat +datum=WGS84'),
#'              weight = 1, color="#333333") %>%
#'  addCircleMarkers(lng = ~lon, lat = ~lat,
#'                   radius = 1, stroke = 0.1)
"cf_resources"

#' Alcoholic and Narcotics Anonymous Meetings in Iowa
#'
#' Dataset was scraped from the AA and NA websites of Iowa by Jessie Bustin.
#' @format A data frame with 1549 rows and 13 variables:
#' \describe{
#'   \item{Day}{day of the week}
#'   \item{Time}{time of the day}
#'   \item{AmPm}{morning or afternoon}
#'   \item{Meeting}{name of the meeting}
#'   \item{Location}{location}
#'   \item{Address}{address}
#'   \item{Format}{Format of the meeting - XXX this needs some additional work}
#'   \item{City}{city}
#'   \item{Type}{type of meeting}
#'   \item{State}{state}
#'   \item{lon}{geographic Longitude}
#'   \item{lat}{geographic Latitude}
#'   \item{schedule}{weekly schedule of meetings, starting with Monday at midnight.}
#' }
#' @source \url{https://www.aa-iowa.org/meetings/}, \url{https://www.na-iowa.org/meetings/}
#' @examples
#' # Location of meetings in Iowa
#' library(ggplot2)
#' library(dplyr)
#' meetings %>%
#'   ggplot(aes(x = lon, y = lat)) +
#'   geom_point(aes(colour = Type))
#'
#' # Leaflet map of meetings in Iowa
#' library(leaflet)
#' library(sf)
#' meetings %>%
#'  leaflet() %>%
#'  addTiles() %>%
#'  addPolygons(data = st_transform(ia_counties, crs='+proj=longlat +datum=WGS84'),
#'              weight = 1, color="#333333") %>%
#'  addCircleMarkers(meetings %>% filter(Type == "Narcotics Anonymous"),
#'                   lng = ~lon, lat = ~lat,
#'                   radius = 1, stroke = 0.1,
#'                   color = "darkorange",
#'                   label = ~Meeting, group="NA") %>%
#'  addCircleMarkers(meetings %>% filter(Type == "Alcoholics Anonymous"),
#'                   lng = ~lon, lat = ~lat,
#'                   radius = 1, stroke = 0.1,
#'                   color = "darkgreen",
#'                   label = ~Meeting, group="AA") %>%
#'  addLayersControl(overlayGroups = c("AA","NA"))
"meetings"

#' Southwest Iowa Region Mental Health & Disability Services
#'
#' Dataset was scraped from the MHDS website.
#' @format A data frame with 356 rows and 13 variables:
#' \describe{
#'   \item{Category}{Service type provided at facility}
#'   \item{County}{Iowa county name}
#'   \item{Related Records}{Currently Unknown}
#'   \item{Service Title}{Name of the facility}
#'   \item{Address}{Column containing location information: Street, City, State, Zip}
#'   \item{Phone}{Phone Number for the facility}
#'   \item{Description}{A description to help the viewer navigate which facility is best for them}
#'   \item{Website}{Facility website link}
#'   \item{Email}{Contact Email for facility}
#'   \item{Expiration}{Currently Unknown}
#'   \item{Last Updated}{Date at which website information was last updated}
#'   \item{lon}{geographic Longitude}
#'   \item{lat}{geographic Latitude}
#' }
#' @source \url{https://www.aa-iowa.org/meetings/}
#' @examples
#' # Location of MHDS in Iowa
#' library(ggplot2)
#' library(dplyr)
#' southwest_mhds %>%
#'  ggplot() +
#'  geom_point(aes(x = lon, y = lat))
#'
#' # Leaflet map of meetings in Iowa
#' library(leaflet)
#' library(sf)
#'
#' southwest_mhds %>%
#'  leaflet() %>%
#'  addTiles() %>%
#'  addPolygons(data = st_transform(ia_counties, crs='+proj=longlat +datum=WGS84'),
#'              weight = 1, color="#333333") %>%
#'  addCircleMarkers(lng = ~lon, lat = ~lat,
#'                   radius = 1, stroke = 0.1,
#'                   label = ~southwest_mhds)
"southwest_mhds"


#' Iowa Hospital Buildings
#'
#' Iowa hospital buildings listed in the federal Geographic Names Information System.
#' @format A data frame with 1709 rows and 11 variables:
#' \describe{
#'   \item{Feature.ID}{Unique identifier for each record}
#'   \item{Feature.Name}{Name of building}
#'   \item{Feature.Class}{Type of building. All records in this dataset will be "hospital".}
#'   \item{Primary.State}{State of the location}
#'   \item{Primary.County.Name}{County of the location}
#'   \item{Elevation..Meters.}{Elevation in meters above sea level of the location}
#'   \item{Elevation..Feet.}{Elevation in feet above sea level of the location}
#'   \item{USGS.Map.Name}{Name of the location of the building}
#'   \item{Date.Created}{Date that the feature was added to the database}
#'   \item{Date.Edited}{Date at which the record was last updated}
#'   \item{geometry}{sf point object of geographic location}
#' }
#' @source \url{https://data.iowa.gov/Physical-Geography/Iowa-Hospital-Buildings/ciqq-2z9p}
#' @examples
#' library(dplyr)
#'
#' # Leaflet map of hospital buildings in Iowa
#' library(leaflet)
#' library(sf)
#'
#' hospital_buildings %>%
#'  leaflet() %>%
#'  addTiles() %>%
#'  addPolygons(data = st_transform(ia_counties, crs='+proj=longlat +datum=WGS84'),
#'              weight = 1, color="#333333") %>%
#'  addCircleMarkers(radius = 1, stroke = 0.1)
"hospital_buildings"
