#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  load_global_variables()
  trigger <- reactiveVal(F)

  league_id <- mod_splash_page_server("splash")
  video_trigger <- mod_countdown_server("countdown", league_id)
  mod_video_server("video", video_trigger)
  mod_main_server("main", trigger)
}
