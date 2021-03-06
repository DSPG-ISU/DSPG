% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{va_medical_centers}
\alias{va_medical_centers}
\title{VA Medical Centers in Iowa}
\format{
A data frame with 19 rows and 10 variables:
\describe{
   \item{dataset}{name of the dataset}
   \item{classification}{type of services offered by datset}
   \item{station_id}{identification number of facility}
   \item{facility}{name of the facility}
   \item{address}{complete address of the facility}
   \item{county}{county of the facility}
   \item{state}{state of the facility}
   \item{phone}{phone number of the facility}
   \item{longitude}{geographic longitude}
   \item{latitude}{geographic latitude}
}
}
\source{
\url{https://www.va.gov/directory/guide/state.asp?STATE=IA&dnum=ALL}
}
\usage{
va_medical_centers
}
\description{
This dataset was scraped by Masoud Nosrati in July 2020 from va.org. The data includes locations in Iowa of Veterans Affairs Medical Centers.
The dataset was geocoded by Joel Von Behren in July 2020.
}
\keyword{datasets}
