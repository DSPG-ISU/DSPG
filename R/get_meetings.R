#' Get set of meetings for a time range based on schedule
#'
#' The `meetings` object consist of a schedule of AA meetings and locations
#' in Iowa. This function creates a data frame of all available meetings and locations
#' for a specified time range.
#' @param from earliest date (and time, if specified)
#' @param to latest date
#' @param type type of meeting
#' @return data frame
#' @export
#' @importFrom lubridate now days wday weeks ymd_hms
#' @importFrom dplyr filter %>% between
#' @importFrom purrr map_df
#' @examples
#' library(leaflet)
#' library(sf)
#'
#' # AA meetings in Iowa for the next 24h from
#' lubridate::now()
#' # color locations by day
#' pal <- colorFactor(
#'          palette = RColorBrewer::brewer.pal(n=7, name="Paired"),
#'          domain = levels(meetings$Day)
#'        )
#' get_meetings() %>%
#'   leaflet() %>%
#'   addTiles() %>%
#'   addPolygons(data = st_transform(ia_counties, crs='+proj=longlat +datum=WGS84'),
#'               weight = 1, color="#888888") %>%
#'   addCircleMarkers(lng = ~lon, lat = ~lat, color=~pal(Day),
#'                    label=~Meeting,
#'                    radius = 1, stroke = 0.1) %>%
#'   addLegend(pal = pal, values = levels(meetings$Day))
get_meetings <- function(from = now(), to = now() + days(1), type = c("Alcoholics Anonymous", "Narcotics Anonymous")) {
  timestamp <- NULL

  # which weekday is the earliest date?
  days_since_monday <- 1 - wday(from, week_start = 1)

  # how many weeks between from and to?
  nweeks <- ceiling(as.numeric(to - from)/7)

  # repeat schedule for each week
  seqs <- seq_along(1:nweeks)
  schedule <- seqs %>% purrr::map_df(.f = function(i) {
    meetings$timestamp <- as.Date(from) + weeks(i-1) + meetings$schedule +
      days(days_since_monday)
    meetings
  })

  # reduce schedule to date range specified and type of meeting
  filter(schedule, between(ymd_hms(timestamp),
                           ymd_hms(from), ymd_hms(to)),
         Type %in% type)
}
