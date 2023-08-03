#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param url PARAM_DESCRIPTION
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @rdname get_url_data
#' @export
#' @importFrom curl curl
#' @importFrom jsonlite fromJSON
get_url_data <- function (url) {
  url %>%
    curl %>%
    fromJSON(simplifyVector = T)
}


url_league_details <- function (league) {paste0("https://draft.premierleague.com/api/league/", league, "/details")}
