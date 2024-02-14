#' Shapefiles of places in IA in 2020
#'
#' The shapefiles are based on places in Iowa in 2020. The names of places and its population numbers are based on
#' the decennial census counts for 2020, 2010, and 2000.
#' Note that the US Census Bureau used differential privacy estimates for the 2020 Census, which might impact the
#' exact numbers below county levels. In particular, for small areas, these estimates might differ from the actual
#' population numbers.
#' @format A tibble with 1030 rows and 7 columns
#' \describe{
#'   \item{geoid}{character}
#'   \item{name}{character}
#'   \item{geometry}{sfc_MULTIPOLYGON, based on the PL 94-171 Redistricting Data Summary File}
#'   \item{pop2020}{numeric, 2020 Census Variable P1_001N}
#'   \item{pop2010}{numeric, 2010 Census Variable P001001}
#'   \item{pop2000}{numeric, 2000 Census Variable PL001001}
#' }
#' @source US Census Bureau Decennial Census 2020, 2010, 2000
#' @examples
#' # three geometries on top of each other
#' library(leaflet)
#' library(sf)
#' ia_cities %>%
#'   leaflet() %>%
#'   addTiles() %>%
#'   addPolygons(data = ia_counties,
#'              weight = 1, color="#333333") %>%
#'   addPolygons(data = ia_places, weight = 1, color="maroon") %>%
#'   addCircleMarkers(radius = 0,
#'                    label = ~city)
"ia_places"
