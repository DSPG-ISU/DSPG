url <- "/Users/heike/Documents/DSPG REU program/shiny-apps/rosc/Reco_Data.csv"
recovery <- read_csv(url)

head(recovery)
use_data(recovery)

roxify(recovery)

roxify <- function(data) {
  items <- names(data)
  classes <- data %>% purrr::map_chr(.f = class)
  itemlist <- paste0("#\'   \\item{",items,"}{", classes,"}", sep="", collapse="\n")
  cat(sprintf("#\' @format A tibble with %s rows and %s columns
#\' \\describe{
%s
#\' }
", nrow(data), ncol(data), itemlist))
}
