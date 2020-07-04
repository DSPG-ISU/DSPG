#' Shapefiles of Iowa's counties
#'
#' provenance - Chris, I need some help with how we document these exports.
#' @format A data frame with 99 rows and 9 variables:
#' \describe{
#'   \item{CO_NUMBER}{county number}
#'   \item{CO_FIPS}{three-digit county fips code}
#'   \item{ACRES_SF}{square footage in acres}
#'   \item{ACRES}{county acreage}
#'   \item{FIPS}{five-digit fips code}
#'   \item{COUNTY}{county name (and it's `Obrien`)}
#'   \item{ST}{two letter state abbreviation (`IA` all the way through)}
#'   \item{ID}{identifier same as `CO_FIPS`}
#'   \item{geometry}{sfc of polygons}
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
#'                      label = ~NAME)
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
#'    \item{GNIS_ID}{identifier}
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
#' # Map of rural health clinics in Iowa county using ggplot2
#' library(ggplot2)
#' library(dplyr) # for the pipe
#'
#' health.clinics %>%
#'  # filter(COUNTY == "Story county) %>%
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
