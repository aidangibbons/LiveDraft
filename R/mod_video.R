#' video UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_video_ui <- function(id){
  ns <- NS(id)
  tagList(
    uiOutput(ns("uiVideo"))
  )
}

#' video Server Functions
#'
#' @noRd
mod_video_server <- function(id, trigger){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    output$uiVideo <- renderUI({
      req(trigger())
      fluidRow(
        column(
          width = 12,
          align = "center",
          htmlOutput(ns("htmlVideoOut")
          )
        )
      )
    })

    output$htmlVideoOut <- renderUI({
      HTML(
        "test"
      )
    })

  })
}

## To be copied in the UI
# mod_video_ui("video_1")

## To be copied in the server
# mod_video_server("video_1")
