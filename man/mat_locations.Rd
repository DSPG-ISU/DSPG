% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{mat_locations}
\alias{mat_locations}
\title{Location of MAT in Iowa}
\format{
A data frame with 107 rows and 14 variables:
\describe{
   \item{id}{identifier, not quite the row number}
   \item{doctor}{name of the medical personnel}
   \item{center}{MAT center}
   \item{address}{street address}
   \item{city}{city}
   \item{state}{state}
   \item{zip}{5-digit zip code}
   \item{phone}{phone number}
   \item{treatment}{treatment type}
   \item{dataset}{dataset name}
   \item{classification}{dataset domain}
   \item{search_address}{Full address}
   \item{longitude}{geographic Latitude}
   \item{latitude}{geographic Longitude}
}
}
\source{
\url{https://iowa.maps.arcgis.com/apps/LocalPerspective/index.html?appid=924e0f99711b406dbf22a34cf46fc6e1}
}
\usage{
mat_locations
}
\description{
This dataset provides doctors available in Medication Assisted Treatment (MAT) facilities in Iowa.
Dataset was scraped by Masoud Nosrati from the Iowa Department of Public Health in Mar 2020, geocoding by Andrew Maloney through QGIS.
}
\keyword{datasets}
