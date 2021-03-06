#' Get set of meetings for a time range based on schedule
#'
#' The `meetings` object consist of a schedule of AA meetings and locations
#' in Iowa. This function creates a data frame of all available meetings and locations
#' for a specified time range.
#' @param from earliest date (and time, if specified)
#' @param to latest date
#' @param type type of meeting see `unique(meetings$type)`
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
#'          domain = levels(meetings$day)
#'        )
#' get_meetings() %>%
#'   leaflet() %>%
#'   addTiles() %>%
#'   addPolygons(data = st_transform(ia_counties, crs='+proj=longlat +datum=WGS84'),
#'               weight = 1, color="#888888") %>%
#'   addCircleMarkers(lng = ~longitude, lat = ~latitude,
#'                    color=~pal(day), label=~meeting,
#'                    radius = 1, stroke = 0.1) %>%
#'   addLegend(pal = pal, values = levels(meetings$day))
get_meetings <- function(from = now(), to = now() + days(1), type = c("All", "Alcoholics Anonymous", "Narcotics Anonymous")) {
  timestamp <- NULL  # just to pass R CMD CHECK
#  type <- NULL

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

  # reduce schedule to date range specified
  schedule <- filter(schedule, between(ymd_hms(timestamp),
                           ymd_hms(from), ymd_hms(to)))

  # filter to type of meeting
  if (!("All" %in% type))
    schedule <- filter(schedule, type %in% type)

  schedule
}
