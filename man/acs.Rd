% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{acs}
\alias{acs}
\title{American Community Survey - Computer Presence}
\format{
A data frame with 99 rows and 9 variables:
\describe{
  \item{geography_id}{geographic ID used by the U.S. census for the location associated with this record}
  \item{type}{The type of location associated with this record. Categories are state, county, place, and tract}
  \item{name}{Name of the location}
  \item{variable}{Variable ID identified by the U.S. Census Bureau}
  \item{variable_description}{Description of the variable}
  \item{computer_present}{Classifies if a computer is present in those households. Categories are total, yes, and no}
  \item{internet_subscription}{Classifies what kind of internet subscription is present in those households. Categories are total, total w/computer, broadband, dial-up, and none}
  \item{data_collection_period}{Period in which the data was collected}
  \item{data_collection_end_date}{The date in which the data was done being collected}
  \item{households}{The number of households estimated to have the specified characteristics in the record}
  \item{row_id}{Unique ID associated with the record}
  \item{geometry}{sf point object of geographic location}
}
}
\source{
\url{https://data.iowa.gov/Utilities-Telecommunications/Iowa-Households-by-Presence-of-a-Computer-and-Type/gz3j-hzab}
}
\usage{
acs
}
\description{
Summary data of Iowa American Community Survey responses by computer presence and internet subscription status. Each row represents a combination of variables and the households variable representing the number of households estimated to be associated with that variable combination.
}
\examples{
# county map of iowa in ggplot2
library(ggplot2)
library(dplyr) # for the pipe
library(ggthemes)

ia_counties \%>\%
  ggplot() + geom_sf(aes(fill = acres_sf)) +
  theme_map()

# leaflet map
library(leaflet)
library(sf)
ia_counties \%>\%
  leaflet() \%>\%
    addTiles() \%>\%
    addPolygons()
}
\keyword{datasets}
