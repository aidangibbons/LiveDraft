#' countdown UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_countdown_ui <- function(id){
  ns <- NS(id)
  tagList(
    uiOutput(ns("uiCountdown"))
  )
}

#' countdown Server Functions
#'
#' @noRd
#' @importFrom lubridate as_datetime
mod_countdown_server <- function(id, league_id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    timer <- reactiveVal(3600)
    timer_active <- reactiveVal(F)
    video_trigger <- reactiveVal(F)

    output$uiCountdown <- renderUI({
      req(!is.null(league_id()))
      req(timer_active())
      # req(!video_trigger())

      tagList(
        fluidRow(
          column(
            width = 12, align = "center",
            htmlOutput(ns("txtTimeLeft"))
          )
        ),
        fluidRow(
          column(
            width = 12, align = "center",
            imageOutput(ns("imgPrem"))
          )
        )
      )
    })

    observeEvent(league_id(), {
      req(!is.null(league_id()))
      start_time <- league_id() %>%
        url_league_details %>%
        get_url_data() %>%
        {.$league$draft_dt} %>%
        as_datetime()
      # TODO uncomment this for live
      if (is_live) {
        # timer(as.numeric(int_diff(c(Sys.time(), start_time))))
      } else {
        timer(60)
      }
      timer_active(T)
    })

    # observer that invalidates every second. If timer is active, decrease by one.
    observe({
      req(timer_active())
      invalidateLater(1000, session)
      isolate({
        if(timer_active())
        {
          timer(timer()-1)
          if(timer()<=video_duration + 3)
          {
            print("Timer complete, triggering video")
            video_trigger(T)
            timer_active(F)
          }
        }
      })
    })

    output$txtTimeLeft <- renderUI({
      req(!is.null(league_id()))
      req(timer_active())
      format_time(timer())
    })


    output$imgPrem <- renderImage(deleteFile = T, {
      req(timer_active())
      outfile <- tempfile(fileext='.png')

      # Generate a png
      png(outfile, width=400, height=400)
      hist(rnorm(100))
      dev.off()

      # Return a list
      list(src = outfile,
           alt = "This is alternate text")
    })

    return(video_trigger)
  })
}

#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param secs PARAM_DESCRIPTION
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @rdname format_time
#' @export
#' @importFrom glue glue
format_time <- function(secs) {
  if (secs >= 3600) {
    glue("{secs %/% 3600}h{secs %% 3600 %/% 60}m{secs %% 60}s")
  } else if (secs >= 60) {
    glue("{secs %% 3600 %/% 60}m{secs %% 60}s")
  } else {
    glue("{secs %% 60}s")
  }
}
