#' Shapefiles of Iowa's counties
#'
#' provenance - Chris, I need some help with how we document these exports.
#' @format A data frame with 99 rows and 9 variables:
#' \describe{
#'   \item{co_number}{county number}
#'   \item{co_fips}{three-digit county fips code}
#'   \item{acres_sf}{square footage in acres}
#'   \item{acres}{county acreage, same as `ACRES_SF``}
#'   \item{fips}{five-digit fips code}
#'   \item{county}{county name (and it's `Obrien`)}
#'   \item{state}{two letter state abbreviation (`IA` all the way through)}
#'   \item{id}{identifier same as `CO_FIPS`}
#'   \item{census2010pop}{US Census Bureau count of 2010 county population.}
#'   \item{popestimate2019}{US Census Bureau estimate of 2019 county population.}
#'   \item{geometry}{simple feature object of polygons}
#' }
#' @source \url{some url?}
#' @examples
#' # county map of iowa in ggplot2
#' library(ggplot2)
#' library(dplyr) # for the pipe
#'
#' ia_counties %>%
#'   ggplot() +
#'   geom_sf(aes(fill = popestimate2019),
#'           colour = "grey80", size = 0.1) +
#'   ggthemes::theme_map() +
#'   theme(legend.position="right") +
#'   scale_fill_gradient("2019 Population\nEstimate", trans="log",
#'     low = "grey80", high="darkred")
#'
#' # leaflet map
#' library(leaflet)
#' library(sf)
#'
#' ia_counties %>%
#'   group_by(county) %>%
#'   mutate(
#'     hovertext = htmltools::HTML(paste0(county, "<br>",popestimate2019))
#'   ) %>%
#'   leaflet() %>%
#'     addTiles() %>%
#'     addPolygons(label=~hovertext)
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
#' ia_cities %>%
#'   mutate(
#'     growth = cut(percentChg,
#'                  breaks = c(-Inf, -2.5, 2.5, Inf),
#'                  labels = labels)) %>%
#'   leaflet() %>%
#'     addTiles() %>%
#'     addPolygons(data = ia_counties,
#'                 weight = 1, color="#333333") %>%
#'     addCircleMarkers(radius = 1, stroke = 0.1, color = ~pal(growth),
#'                      label = ~city) %>%
#'     addLegend(title = "% Change in Population", colors = colors, labels = labels)
"ia_cities"



#' Location of churches in Iowa
#'
#' Dataset was scraped by Masoud Nosrati from the IA Hometown Locator in Mar 2020.
#' @format A data frame with 5469 rows and 9 variables:
#' \describe{
#'    \item{name}{name of the church}
#'    \item{description}{closer description of the location, if available}
#'    \item{county}{name of the county}
#'    \item{geometry}{sf point object of geographic locations of churches in Iowa.}
#'    \item{classification}{column used for classifying the data set}
#' }
#' @source \url{https://iowa.hometownlocator.com/features/cultural,class,church.cfm}
#'
#' @examples
#' # Map of churches in Story county using ggplot2
#' library(ggplot2)
#' library(dplyr) # for the pipe
#'
#' churches %>%
#'  # filter(county == "Story county) %>%
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
#'     addPolygons(data = ia_counties,
#'                 weight = 1, color="#333333") %>%
#'     addCircleMarkers(radius = 1, stroke = 0.1,
#'                      label = ~name, clusterOptions = markerClusterOptions())
"churches"

#' Location of parks in Iowa
#'
#' Dataset was scraped by Masoud Nosrati from MyCountyParks in Mar 2020, geocoding by Andrew Maloney through QGIS.
#' @format A data frame with 1645 rows and 15 variables:
#' \describe{
#'    \item{name}{name of the park}
#'    \item{county}{name of the county}
#'    \item{city}{name of the city}
#'    \item{state}{name of the state}
#'    \item{phone}{phone number}
#'    \item{zip}{5-digit zip code}
#'    \item{result_num}{1645 0s XXX delete column?}
#'    \item{status}{1645 OKs XXX delete column?}
#'    \item{address}{formatted addresses - some are duplicates - XXX look into}
#'    \item{latitude}{geographic latitude}
#'    \item{longitude}{geographic longitude}
#'    \item{classification}{column used to classify the data set}
#' }
#' @source \url{https://www.mycountyparks.com/County/Default.aspx}
#' @examples
#' # Map of parks in Iowa county using ggplot2
#' library(ggplot2)
#' library(dplyr) # for the pipe
#'
#' parks %>%
#'  # filter(county == "Story county) %>%
#'   ggplot() +
#'     geom_point(aes(x = longitude, y = latitude))
#'
#' # leaflet map
#' library(leaflet)
#' library(sf)
#'
#' parks %>%
#'   leaflet() %>%
#'     addTiles() %>%
#'     addPolygons(data = ia_counties,
#'                 weight = 1, color="#333333") %>%
#'     addCircleMarkers(lng = ~longitude, lat = ~latitude,
#'                      radius = 1, stroke = 0.1,
#'                      label = ~name)
"parks"


#' Location of Licensed Substance Use Disorder/Problem Gambling Programs in Iowa
#'
#' Dataset was scraped by Masoud Nosrati from the Iowa Department of Public Health Development in Mar 2020, geocoding by Andrew Maloney through QGIS.
#' @format A data frame with 123 rows and 15 variables:
#' \describe{
#'    \item{name}{name of the facility}
#'    \item{phone}{phone number}
#'    \item{street}{street address}
#'    \item{city}{city}
#'    \item{statename}{name of state}
#'    \item{zip}{5-digit zip code}
#'    \item{result_num}{0s XXX delete column?}
#'    \item{status}{OKs XXX delete column?}
#'    \item{address}{formatted addresses - some are duplicates - XXX look into}
#'    \item{latitude}{geographic latitude}
#'    \item{longitude}{geographic longitude}
#'    \item{state}{state abbreviation}
#'    \item{classification}{column used to classify the dataset}
#' }
#' @source \url{https://www.iowaworkforcedevelopment.gov/contact}
#' @examples
#' # Map of centers in Iowa  using ggplot2
#' library(ggplot2)
#' library(dplyr) # for the pipe
#'
#' sud %>%
#'   ggplot() +
#'     geom_point(aes(x = longitude, y = latitude))
#'
#' # leaflet map
#' library(leaflet)
#' library(sf)
#'
#' sud %>%
#'   group_by(name,address, phone) %>%
#'   mutate(
#'     hovertext = htmltools::HTML(paste0(name, "<br>",formatted_, '<br>', phone))
#'   ) %>%
#'   leaflet() %>%
#'     addTiles() %>%
#'     addPolygons(data = ia_counties,
#'                 weight = 1, color="#333333") %>%
#'     addCircleMarkers(lng = ~longitude, lat = ~latitude,
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
#'     addPolygons(data = ia_counties,
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
#'     addPolygons(data = ia_counties,
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
#'    \item{city}{name of the city}
#'    \item{name}{name of the hospital - XXX rename to NAME}
#'    \item{type}{type of hospital, one of 'critical access', 'general acute care', 'psychiatric', 'long term care', and 'military'}
#'    \item{website}{url if available}
#'    \item{beds}{number of BEDS}
#'    \item{naics_desc}{North American Industry Classification System (NAICS) descriptor: 'general medical and surgical hospital' or 'specialty hospital'}
#'    \item{result_num}{145 0s XXX delete column?}
#'    \item{status}{145 OKs XXX delete column?}
#'    \item{address}{formatted addresses - some are duplicates - XXX look into}
#'    \item{state}{state abbreviation}
#'    \item{zip}{zip code}
#'    \item{latitude}{geographic latitude}
#'    \item{longitude}{geographic longitude}
#'    \item{classification}{column used to classify the data set}
#' }
#' @source \url{https://www.officialusa.com/stateguides/health/hospitals/iowa.html}
#' @examples
#' # Map of hospitals in Iowa  using ggplot2
#' library(ggplot2)
#' library(dplyr) # for the pipe
#'
#' hospitals %>%
#'   ggplot() +
#'     geom_point(aes(x = longitude, y = latitude))
#'
#' # leaflet map
#' library(leaflet)
#' library(sf)
#'
#' hospitals %>%
#'   leaflet() %>%
#'     addTiles() %>%
#'     addPolygons(data = ia_counties,
#'                 weight = 1, color="#333333") %>%
#'     addCircleMarkers(lng = ~longitude, lat = ~latitude,
#'                      radius = 1, stroke = 0.1,
#'                      label = ~name,
#'                      clusterOptions = markerClusterOptions())
"hospitals"



#' Location of rural health clinics in Iowa
#'
#' Dataset was scraped by Masoud Nosrati from the Iowa Association of Rural Health Clinics in Mar 2020, geocoding by Andrew Maloney through QGIS.
#' @format A data frame with 146 rows and 11 variables:
#' \describe{
#'    \item{name}{name of the clinic}
#'    \item{address}{formatted addresses - some are duplicates - XXX look into}
#'    \item{state}{state abbreviation}
#'    \item{county}{name of the county}
#'    \item{zip}{zip code}
#'    \item{country}{country where facility is located}
#'    \item{result_num}{146 0s XXX delete column?}
#'    \item{status}{146 OKs XXX delete column?}
#'    \item{longitude}{geographic longitude}
#'    \item{latitude}{geographic latitude}
#'    \item{classification}{column used for classifying the data set}
#' }
#' @source \url{https://iarhc.org/find-a-rural-health-clinic?view=map}
#' @examples
#' # Map of rural health clinics in Iowa using ggplot2
#' library(ggplot2)
#' library(dplyr) # for the pipe
#'
#' health.clinics %>%
#'   ggplot() +
#'     geom_point(aes(x = longitude, y = latitude))
#'
#' # leaflet map
#' library(leaflet)
#' library(sf)
#'
#' health.clinics %>%
#'   leaflet() %>%
#'     addTiles() %>%
#'     addPolygons(data = ia_counties,
#'                 weight = 1, color="#333333") %>%
#'     addCircleMarkers(lng = ~longitude, lat = ~latitude,
#'                      radius = 1, stroke = 0.1,
#'                      label = ~name)
"health.clinics"


#' Location of colleges and universities in Iowa
#'
#' Dataset was scraped by Masoud Nosrati from wikipedia in Mar 2020, geocoding by Heike Hofmann through Google API.
#' @format A data frame with 57 rows and 11 variables:
#' \describe{
#'    \item{name}{name of school}
#'    \item{city}{name of the clinic}
#'    \item{type}{type of institution by degree}
#'    \item{enrolment}{number of students enrolled (in Spring 2012)}
#'    \item{address}{address used in search string for Google geocoding}
#'    \item{latitude}{geographic latitude}
#'    \item{longitude}{geographic longitude}
#'    \item{classification}{column used for classifying the data set}
#' }
#' @source \url{https://en.wikipedia.org/wiki/List_of_colleges_and_universities_in_Iowa}
#' @examples
#' # Map of rural health clinics in Iowa using ggplot2
#' library(ggplot2)
#' library(dplyr) # for the pipe
#'
#' colleges %>%
#'   ggplot() +
#'     geom_point(aes(x = longitude, y = latitude))
#'
#' # leaflet map
#' library(leaflet)
#' library(sf)
#'
#' colleges %>%
#'   leaflet() %>%
#'     addTiles() %>%
#'     addPolygons(data = ia_counties,
#'                 weight = 1, color="#333333") %>%
#'     addCircleMarkers(lng = ~longitude, lat = ~latitude,
#'                      radius = 1, stroke = 0.1,
#'                      label = ~name)
"colleges"

#' American Community Survey - Computer Presence
#'
#' Summary data of Iowa American Community Survey responses by computer presence and internet subscription status. Each row represents a combination of variables and the households variable representing the number of households estimated to be associated with that variable combination.
#' @format A data frame with 99 rows and 9 variables:
#' \describe{
#'   \item{geography.Id}{geographic ID used by the U.S. census for the location associated with this record}
#'   \item{type}{The type of location associated with this record. Categories are state, county, place, and tract}
#'   \item{name}{Name of the location}
#'   \item{variable}{Variable ID identified by the U.S. Census Bureau}
#'   \item{variable_description}{Description of the variable}
#'   \item{computer_present}{Classifies if a computer is present in those households. Categories are total, yes, and no}
#'   \item{internet_subscription}{Classifies what kind of internet subscription is present in those households. Categories are total, total w/computer, broadband, dial-up, and none}
#'   \item{data_collection_period}{Period in which the data was collected}
#'   \item{data_collection_end_date}{The date in which the data was done being collected}
#'   \item{households}{The number of households estimated to have the specified characteristics in the record}
#'   \item{row_id}{Unique ID associated with the record}
#'   \item{geometry}{sf point object of geographic location}
#' }
#' @source \url{https://data.iowa.gov/Utilities-Telecommunications/Iowa-Households-by-Presence-of-a-Computer-and-Type/gz3j-hzab}
#' @examples
#' # county map of iowa in ggplot2
#' library(ggplot2)
#' library(dplyr) # for the pipe
#'
#' ia_counties %>%
#'   ggplot() + geom_sf(aes(fill = acres_sf)) +
#'   ggthemes::theme_map()
#'
#' # leaflet map
#' library(leaflet)
#' library(sf)
#' ia_counties %>%
#'   leaflet() %>%
#'     addTiles() %>%
#'     addPolygons()
"acs"


#' Location of ASAC (Area Substance Abuse Counseling) in Iowa
#'
#' Dataset was scraped from the ASAC website.
#' This database contains ASAC location data for the State of Iowa
#' \describe{
#'   \item{name}{Name of the facility}
#'   \item{address}{Street Address for the facility}
#'   \item{city_state_zip}{City, State, and Zip contained in one column separated by a space}
#'   \item{city}{Name of the city where the facility is located}
#'   \item{zip}{5 digit Zip}
#'   \item{state}{State Abbreviation}
#'   \item{search_address}{address used in the Google API geocoding}
#'   \item{geometry}{sf object of geographic locations}
#'   \item{classification}{column used for identification for filtering}
#' }
#' @source \url{http://www.asac.us/about/locations/}
#' @examples
#' library(ggplot2)
#' library(dplyr)
#' asac_locations %>%
#'  ggplot() +
#'  geom_sf(data = ia_counties) + # iowa county shapes
#'  geom_sf() # add points
#'
#' library(leaflet)
#' library(sf)
#' asac_locations %>%
#'  leaflet() %>%
#'  addTiles() %>%
#'  addPolygons(data = ia_counties,
#'              weight = 1, color="#333333") %>%
#'  addCircleMarkers(radius = 1, stroke = 0.1, label=~name)
"asac_locations"


#' Community and Family Resources
#'
#' Dataset was scraped from the Community and Family Resources website.
#' This database contains Community and Family Resources location data for the State of Iowa.
#' @format A data frame with 10 rows and 8 variables:
#' \describe{
#'   \item{address}{Street address for the facility}
#'   \item{city}{Character string containing city name}
#'   \item{state}{State Abbreviation}
#'   \item{zip}{5 digit zip code}
#'   \item{name}{Facility Name, only 3 locations have unique names}
#'   \item{search_address}{address used in the Google API geocoding}
#'   \item{longitude}{geographic Longitude}
#'   \item{latitude}{geographic Latitude}
#'   \item{classification}{classification column}
#' }
#' @source \url{http://www.cfrhelps.org/our-locations}
#' @examples
#' library(ggplot2)
#' library(dplyr)
#' cf_resources %>%
#'  ggplot() +
#'  geom_point(aes(x = longitude, y = latitude))
#'
#' library(leaflet)
#' library(sf)
#' cf_resources %>%
#'  leaflet() %>%
#'  addTiles() %>%
#'  addPolygons(data = ia_counties,
#'              weight = 1, color="#333333") %>%
#'  addCircleMarkers(lng = ~longitude, lat = ~latitude,
#'                   radius = 1, stroke = 0.1)
"cf_resources"

#' Alcoholic and Narcotics Anonymous Meetings in Iowa
#'
#' Dataset was scraped from the AA and NA websites of Iowa by Jessie Bustin.
#' @format A data frame with 1549 rows and 13 variables:
#' \describe{
#'   \item{day}{day of the week}
#'   \item{time}{time of the day}
#'   \item{ampm}{morning or afternoon}
#'   \item{meeting}{name of the meeting}
#'   \item{address}{address}
#'   \item{street}{stree name}
#'   \item{state}{state}
#'   \item{format}{Format of the meeting - XXX this needs some additional work}
#'   \item{city}{city}
#'   \item{type}{type of meeting}
#'   \item{longitude}{geographic Longitude}
#'   \item{latitude}{geographic Latitude}
#'   \item{schedule}{weekly schedule of meetings, starting with Monday at midnight.}
#'   \item{classification}{column used to classify the data set}
#' }
#' @source \url{https://www.aa-iowa.org/meetings/}, \url{https://www.na-iowa.org/meetings/}
#' @examples
#' # Location of meetings in Iowa
#' library(ggplot2)
#' library(dplyr)
#' meetings %>%
#'   ggplot(aes(x = longitude, y = latitude)) +
#'   geom_point(aes(colour = type))
#'
#' # Leaflet map of meetings in Iowa
#' library(leaflet)
#' library(sf)
#' meetings %>%
#'  leaflet() %>%
#'  addTiles() %>%
#'  addPolygons(data = ia_counties,
#'              weight = 1, color="#333333") %>%
#'  addCircleMarkers(meetings %>% filter(Type == "Narcotics Anonymous"),
#'                   lng = ~longitude, lat = ~latitude,
#'                   radius = 1, stroke = 0.1,
#'                   color = "darkorange",
#'                   label = ~Meeting, group="NA") %>%
#'  addCircleMarkers(meetings %>% filter(Type == "Alcoholics Anonymous"),
#'                   lng = ~longitude, lat = ~latitude,
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
#'   \item{category}{Service type provided at facility}
#'   \item{county}{Iowa county name}
#'   \item{related records}{Currently Unknown}
#'   \item{service title}{Name of the facility}
#'   \item{address}{Column containing location information: Street, City, State, Zip}
#'   \item{phone}{Phone Number for the facility}
#'   \item{description}{A description to help the viewer navigate which facility is best for them}
#'   \item{website}{Facility website link}
#'   \item{email}{Contact Email for facility}
#'   \item{expiration}{Currently Unknown}
#'   \item{last updated}{Date at which website information was last updated}
#'   \item{longitude}{geographic Longitude}
#'   \item{latitude}{geographic Latitude}
#' }
#' @source \url{https://www.aa-iowa.org/meetings/}
#' @examples
#' # Location of MHDS in Iowa
#' library(ggplot2)
#' library(dplyr)
#' southwest_mhds %>%
#'  ggplot() +
#'  geom_point(aes(x = longitude, y = latitude))
#'
#' # Leaflet map of meetings in Iowa
#' library(leaflet)
#' library(sf)
#'
#' southwest_mhds %>%
#'  leaflet() %>%
#'  addTiles() %>%
#'  addPolygons(data = ia_counties,
#'              weight = 1, color="#333333") %>%
#'  addCircleMarkers(lng = ~longitude, lat = ~latitude,
#'                   radius = 1, stroke = 0.1,
#'                   label = ~southwest_mhds)
"southwest_mhds"


#' Iowa Hospital Buildings
#'
#' Iowa hospital buildings listed in the federal Geographic Names Information System.
#' @format A data frame with 1709 rows and 11 variables:
#' \describe{
#'   \item{name}{Name of building}
#'   \item{feature_class}{Type of building. All records in this dataset will be "hospital".}
#'   \item{state}{State of the location}
#'   \item{county}{County of the location}
#'   \item{elevation_meters}{Elevation in meters above sea level of the location}
#'   \item{elevation__feet}{Elevation in feet above sea level of the location}
#'   \item{usgs_map_name}{Name of the location of the building}
#'   \item{date_created}{Date that the feature was added to the database}
#'   \item{date_edited}{Date at which the record was last updated}
#'   \item{geometry}{sf point object of geographic location}
#'   \item{classification}{column used for classifying the data set}
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
#'  addPolygons(data = ia_counties,
#'              weight = 1, color="#333333") %>%
#'  addCircleMarkers(radius = 1, stroke = 0.1)
"hospital_buildings"

#' Cross Mental Health Data
#'
#' CROSS has designated access points for adult mental health and disability services that are listed here
#' @format A data frame with 36 rows and 5 variables:
#' \describe{
#'   \item{name}{Name of the accesss point}
#'   \item{address}{Address of the building}
#'   \item{state}{state abbreviation}
#'   \item{zip}{zip code}
#'   \item{phone}{Phone number of the building}
#'   \item{longitude}{geographic Longitude}
#'   \item{latitude}{geographic Latitude}
#'   \item{classification}{column used for classifying the data set}
#' }
#' @source \url{https://crossmentalhealth.org/wp-content/uploads/2020/03/Access-Points.pdf}
#' @examples
#' library(dplyr)
#'
#' # Leaflet map of Cross Mental Health buildings in Iowa
#' library(leaflet)
#' library(sf)
#'
#' cross_mental_health %>%
#'  leaflet() %>%
#'  addTiles() %>%
#'  addPolygons(data = ia_counties,
#'              weight = 1, color="#333333") %>%
#'  addCircleMarkers(radius = 1, stroke = 0.1)
"cross_mental_health"


#' Physical and Cultural Geographic Features in Iowa
#'
#' This dataset consists of all named physical and cultural geographic features in Iowa that are part of the
#' Geographic Names Information System (GNIS) as developed by the US Geological Survey.
#' The data was downloaded from the Iowa Data Portal in July 2020.
#' It encompasses various aspects of Iowa's infrastructure, including hospital buildings and parks.
#' @format A data frame with 40,473 rows and 11 variables:
#' \describe{
#'   \item{name}{Official feature name as defined in INCITS 446-2008.}
#'   \item{class}{Type of feature, one of Airport, Arch, Area, Bar, Bay, Beach, Bend, Bridge, Building, Canal, Cape, Cemetery, Census, Channel, Church, Civil, Cliff, Crossing, Dam, Falls, Flat, Forest, Gut, Harbor, Hospital, Island, Lake, Levee, Locale, Military, Mine, Oilfield, Park, Pillar, Plain, Populated Place, Post Office, Range, Reserve, Reservoir, Ridge, School, Spring, Stream, Summit, Swamp, Tower, Trail, Tunnel, Valley, and Woods..}
#'   \item{state}{state abbreviation}
#'   \item{county}{County of the primary location of the feature.}
#'   \item{elevation_m}{Elevation in meters above sea level of the feature.}
#'   \item{elevation_ft}{Elevation in feet above sea level of the feature.}
#'   \item{usgs_map_name}{Name of the location of the building}
#'   \item{date_created}{Date that the feature was added to the database}
#'   \item{date_edited}{Date at which the record was last updated}
#'   \item{geometry}{sf point object of geographic location}
#' }
#' @source \url{https://data.iowa.gov/Physical-Geography/Iowa-Physical-and-Cultural-Geographic-Features/uedc-2fk7}
#' @examples
#' library(dplyr)
#' library(ggplot2)
#' iowa_features %>%
#'   filter(class == "Park") %>%
#'   ggplot() +
#'   geom_sf() +
#'   xlim(c(-97,-89.75)) +
#'   ylim(c(40, 45))
#'
#' # The Bridges of Madison County
#'   library(leaflet)
#'   library(sf)
#'
#'  iowa_features %>%
#'    filter(county == "Madison",
#'           class == "Bridge") %>%
#'    leaflet() %>%
#'    addTiles() %>%
#'    setView(-94.0530854, 41.3409121, zoom = 9) %>%
#'  #  addPolygons(data = ia_counties,
#'  #              weight = 1, color="#333333") %>%
#'    addCircleMarkers(radius = 1, stroke = 0.1, label=~class)
#'
#' # Leaflet map of top ten feature maps in Iowa
#'  topten <- iowa_features %>% count(class) %>%
#'              arrange(desc(n)) %>% head(10)
#'
#'  pal <- colorFactor(
#'           palette=RColorBrewer::brewer.pal(n=10, name="Paired"),
#'           domain = topten$class
#'         )
#'  iowa_features %>%
#'    filter(class %in% topten$class) %>%
#'    leaflet() %>%
#'    addTiles() %>%
#'    setView(-94, 42, zoom = 6) %>%
#'    addPolygons(data = ia_counties,
#'                weight = 1, color="#333333") %>%
#'    addCircleMarkers(radius = .5, stroke = 0.1,
#'                     color =~pal(class),
#'                     label=~class) %>%
#'    addLegend(pal = pal, values = topten$class)
#'
#'  # Iowa is flat. Is it? Yes, but ...
#'  elev_pal <- colorNumeric(
#'           palette="Blues",
#'           domain = c(0,600),
#'           reverse=TRUE
#'         )
#'
#'  iowa_features %>%
#'    filter(class %in% topten$feature) %>%
#'    leaflet() %>%
#'    addTiles() %>%
#'    setView(-94, 42, zoom = 6) %>%
#'    addPolygons(data = ia_counties,
#'                weight = 1, color="#333333") %>%
#'    addCircleMarkers(radius = .5, stroke = 0.1,
#'                     color =~elev_pal(elevation_m),
#'                     label=~feature) %>%
#'    addLegend(pal=elev_pal, values=c(0,600))
"iowa_features"


#' Comprehensive Substance Abuse Prevention Grant Facilities
#'
#' This dataset includes all facilities managed under the Iowa Comprehensive Substance Abuse Prevention Grant regional centers. These 19 regional organizations manage prevention, inpatient, and outpatient substance use facilities in their respective regions of Iowa. The data was collected by Matthew Voss in July 2020.
#' @format A data frame with 129 rows and 11 variables:
#' \describe{
#'   \item{classification}{The systems of care infrastructure category under which the facility falls; all in this dataset are considered substance use treatment}
#'   \item{dataset}{For possible future use, all data are in the regional_substance_treatment dataset}
#'   \item{regional_org}{The regional organization that manages the specific facility in the observation}
#'   \item{source}{The link from which the data was obtained}
#'   \item{location_name}{The name of the specific treatment facility}
#'   \item{address}{The street address of the treatment facility}
#'   \item{unit_num}{The unit or suite number of the office, if it has one}
#'   \item{city}{The city of the treatment facility}
#'   \item{state}{The state of the treatment facility}
#'   \item{zip}{The zip code of the treatment facility}
#'   \item{phone}{The phone number for the treatment facility}
#' }
#' @source \url{https://idph.iowa.gov/Portals/1/userfiles/55/FY18%20Comprehensive%20Substance%20Abuse%20Prevention%20Service%20Areas%20Map.pdf}
"regional_substance_treatment"


#' US presidential election 2016 precinct level results for Iowa
#'
#' Precinct level results from the 2016 general election for all Iowa precincts.
#' This data was modified from the data provided by MIT Election Data and Science Lab by
#' focussing on Iowa precinct results from the general presidential election in 2016.
#' @format A data frame with 36,960 rows and 15 variables:
#' \describe{
#'   \item{year}{Year of the election.}
#'   \item{state}{State of election (here, `Iowa`).}
#'   \item{county_name}{Name of the county.}
#'   \item{county_fips}{FIPS code of county.}
#'   \item{county_ansi}{ANSI code of the county.}
#'   \item{jurisdiction}{County of jurisdiction.}
#'   \item{precinct}{Precinct name}
#'   \item{candidate}{Name of the candidate}
#'   \item{candidate_normalized}{Normalized name of the candidate.}
#'   \item{writein}{Is candidate a write-in?}
#'   \item{party}{Party affiliation of the candidate.}
#'   \item{mode}{How was vote cast? Absentee or at Polling station.}
#'   \item{votes}{Number of votes cast in precinct.}
#'   \item{candidate_fec}{Federal Election identifier of the candidate's campaign.}
#'   \item{candidate_fec_name}{Name associated with the campaign.}
#' }
#' @author MIT Election Data and Science Lab (Massachusetts Institute of Technology)
#' @source \url{https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/LYWX3D}
#' @examples
#' library(ggplot2)
#' library(dplyr)
#'
#' ia_election_2016 %>%
#'   ggplot() +
#'     geom_bar(aes(x = candidate, weight = votes)) +
#'     coord_flip()
"ia_election_2016"

#' 2016 precincts of Iowa
#'
#' Precinct and district shapefiles are published by the Secretary of State.
#' Election results of the 2016 general election are added to each precinct.
#' @format A data frame with 1690 rows and 16 variables:
#' \describe{
#'   \item{COUNTY}{county}
#'   \item{DISTRICT}{DISTRICT, precinct and NAME are used as names of a precinct.}
#'   \item{precinct}{DISTRICT, precinct and NAME are used as names of a precinct.}
#'   \item{NAME}{DISTRICT, precinct and NAME are used as names of a precinct.}
#'   \item{POPULATION}{population of the precinct.}
#'   \item{Votes16}{Total number of votes cast in the US general election for US President.}
#'   \item{PctRep16}{Percent of votes in the district cast for the candidate of the Republican Party}
#'   \item{PctDem16}{Percent of votes in the district cast for the candidate of the Democratic Party}
#'   \item{PctLib16}{Percent of votes in the district cast for the candidate of the Libertarian Party}
#'   \item{PctOther16}{Percent of votes in the district cast for a candidate of an other party.}
#'   \item{House_Dist}{House district affiliation}
#'   \item{Senate_Dis}{Senate district affiliation}
#'   \item{Congressio}{Congression district affiliation}
#'   \item{AREA}{Area of the district.}
#'   \item{Shape_Leng}{Numeric value derived from polygon.}
#'   \item{geometry}{sfc object of polygons describing each district.}
#' }
#' @source \url{https://sos.iowa.gov/elections/maps/shapefiles.html}
#' @examples
#' library(leaflet)
#' pal <- colorNumeric(palette=c("Darkred", "White", "Darkblue"),
#'                     reverse = TRUE,
#'                     domain = range(ia_precincts$PctRep16 - ia_precincts$PctDem16, na.rm=TRUE))
#'
#' ia_precincts %>%
#'   leaflet() %>%
#'     addTiles() %>%
#'     addPolygons(fillColor = ~pal(PctRep16-PctDem16), fillOpacity = .75,
#'                 stroke=0, opacity = 1, label=~NAME) %>%
#'     addLegend(pal=pal, values  = range(ia_precincts$PctRep16 - ia_precincts$PctDem16, na.rm=TRUE))
"ia_precincts"
