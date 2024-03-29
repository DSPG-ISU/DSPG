% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{regional_MHDS}
\alias{regional_MHDS}
\title{Iowa Mental Health and Disability Services}
\format{
A data frame with 79 rows and 15 variables:
\describe{
   \item{classification}{the type of service provided}
   \item{dataset}{the dataset in which the observation is}
   \item{regional_org}{the name of the MHDS region of the observation}
   \item{source}{the website that has information about the location}
   \item{address}{the street address of the location}
   \item{unit_num}{the unit number of the location, if it exists}
   \item{city}{the city of the location}
   \item{state}{the state of the location}
   \item{zip}{the five-digit zip code of the location}
   \item{phone}{the location's phone number}
   \item{longitude}{geographic longitude}
   \item{latitude}{geographic latitude}
   \item{street_address}{the full street address used for geocoding}
   \item{name}{the name of the location}
}
}
\source{
sources can be found in the dataset column "source"
}
\usage{
regional_MHDS
}
\description{
This dataset includes mental health and disability service regional access points in Iowa.
The dataset was collected and geocoded by Matthew Voss in July 2020. It includes access points for 11 of the 14 MHDS regions.
}
\keyword{datasets}
