#' splash_page UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_splash_page_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' splash_page Server Functions
#'
#' @noRd 
mod_splash_page_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_splash_page_ui("splash_page_1")
    
## To be copied in the server
# mod_splash_page_server("splash_page_1")
