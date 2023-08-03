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
  livedraft_trigger <- mod_countdown_server("countdown", league_id, dims = input$dimension)
  # livedraft_trigger <- reactive({T})
  mod_main_server("main", livedraft_trigger, league = league_id)
}
