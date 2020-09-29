roxify <- function(data) {
  items <- names(data)
  classes <- data %>% purrr::map_chr(.f = function(x) class(x)[1])
  itemlist <- paste0("#\'   \\item{",items,"}{", classes,"}", sep="", collapse="\n")
  cat(sprintf("#\' @format A tibble with %s rows and %s columns
#\' \\describe{
%s
#\' }
", nrow(data), ncol(data), itemlist))
}


