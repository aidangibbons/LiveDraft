#' main UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_main_ui <- function(id){
  ns <- NS(id)
  tagList(
    uiOutput(ns("uiMain"))
  )
}

#' main Server Functions
#'
#' @noRd
#' @importFrom gt gt_output render_gt gt
#' @importFrom tibble tibble
mod_main_server <- function(id, trigger){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    output$uiMain <- renderUI({
      req(trigger())
      tagList(
        fluidRow(
          column(
            width = 5, align = "center",
            gt_output(ns("gtPicks"))
          ),
          column(
            width = 2, align = "center",
            imageOutput(ns("imgLatestPick"))
          ),
          column(
            width = 5, align = "center",
            gt_output(ns("gtPicksPosition"))
          )
        )
      )
    })

    output$gtPicks <- render_gt({
      gt(tibble())
    })

    output$imgLatestPlayer <- renderImage({

    })

    output$gtPicksPosition <- render_gt({
      gt(tibble())
    })
  })
}

## To be copied in the UI
# mod_main_ui("main_1")

## To be copied in the server
# mod_main_server("main_1")
