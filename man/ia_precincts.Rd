% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{ia_precincts}
\alias{ia_precincts}
\title{2016 precincts of Iowa}
\format{
A data frame with 1690 rows and 16 variables:
\describe{
  \item{COUNTY}{county}
  \item{DISTRICT}{DISTRICT, precinct and NAME are used as names of a precinct.}
  \item{precinct}{DISTRICT, precinct and NAME are used as names of a precinct.}
  \item{NAME}{DISTRICT, precinct and NAME are used as names of a precinct.}
  \item{POPULATION}{population of the precinct.}
  \item{Votes16}{Total number of votes cast in the US general election for US President.}
  \item{PctRep16}{Percent of votes in the district cast for the candidate of the Republican Party}
  \item{PctDem16}{Percent of votes in the district cast for the candidate of the Democratic Party}
  \item{PctLib16}{Percent of votes in the district cast for the candidate of the Libertarian Party}
  \item{PctOther16}{Percent of votes in the district cast for a candidate of an other party.}
  \item{House_Dist}{House district affiliation}
  \item{Senate_Dis}{Senate district affiliation}
  \item{Congressio}{Congression district affiliation}
  \item{AREA}{Area of the district.}
  \item{Shape_Leng}{Numeric value derived from polygon.}
  \item{geometry}{sfc object of polygons describing each district.}
}
}
\source{
\url{https://sos.iowa.gov/elections/maps/shapefiles.html}
}
\usage{
ia_precincts
}
\description{
Precinct and district shapefiles are published by the Secretary of State.
Election results of the 2016 general election are added to each precinct.
}
\examples{
library(leaflet)
pal <- colorNumeric(palette=c("Darkred", "White", "Darkblue"),
                    reverse = TRUE,
                    domain = range(ia_precincts$PctRep16 - ia_precincts$PctDem16, na.rm=TRUE))

ia_precincts \%>\%
  leaflet() \%>\%
    addTiles() \%>\%
    addPolygons(fillColor = ~pal(PctRep16-PctDem16), fillOpacity = .75,
                stroke=0, opacity = 1, label=~NAME) \%>\%
    addLegend(pal=pal, values  = range(ia_precincts$PctRep16 - ia_precincts$PctDem16, na.rm=TRUE))
}
\keyword{datasets}
