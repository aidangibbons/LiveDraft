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
    uiOutput(ns("uiVideo")),
    uiOutput(ns("uiCountdown"))
  )
}

#' countdown Server Functions
#'
#' @noRd
#' @importFrom lubridate as_datetime
mod_countdown_server <- function(id, league_id, dims){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    # set timer-related reactive values
    timer <- reactiveVal(3600)
    timer_active <- reactiveVal(F)
    video_trigger <- reactiveVal(F)
    countdown_trigger <- reactiveVal(F)
    livedraft_trigger <- reactiveVal(F)

    # render countdown text and FPL image
    output$uiCountdown <- renderUI({
      req(countdown_trigger())
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
            htmlOutput(ns("imgPrem"))
          )
        )
      )
    })

    # render output video
    output$uiVideo <- renderUI({
      req(video_trigger())
      fluidRow(
        column(
          width = 12,
          align = "center",
          htmlOutput(ns("htmlVideoOut")
          )
        )
      )
    })

    # initiate countdown once a league ID is entered
    observeEvent(league_id(), {
      req(!is.null(league_id()))
      start_time <- league_id() %>%
        url_league_details %>%
        get_url_data() %>%
        {.$league$draft_dt} %>%
        as_datetime()

      if (is_live) {
        timer(as.numeric(int_diff(c(Sys.time(), start_time))))
      } else {
        timer(vid_trigger_time + 10)
      }
      timer_active(T)
      countdown_trigger(T)
    })

    # observer that invalidates every second. If timer is active, decrease by one.
    # trigger the switch from countdown -> video -> countdown -> live draft
    observe({
      req(timer_active())
      invalidateLater(1000, session)
      isolate({
        timer(round(timer())-1)
        if (timer() > vid_trigger_time) {
          # continue running timer
        } else if (timer()<=vid_trigger_time & timer() >= video_added_duration) {
          if (timer() == vid_trigger_time) {
            print_dev("Time reached, triggering video.")
          }

          countdown_trigger(F)
          video_trigger(T)
        } else if (timer() > 0 & timer() <= video_added_duration) {
          if (timer() == video_added_duration) {
            print_dev("Video complete, triggering timer.")
          }
          video_trigger(F)
          countdown_trigger(T)
        } else {
          print_dev("Timer complete.")
          timer_active(F)
          video_trigger(F)
          countdown_trigger(F)
          livedraft_trigger(T)
        }
      })
    })

    # display the countdown timer
    output$txtTimeLeft <- renderUI({
      req(countdown_trigger())
      t <- format_time(timer())
      p(t, style = "font-size:180px")
    })


    output$imgPrem <- renderUI({
      req(countdown_trigger())
      tags$img(src = "https://4.bp.blogspot.com/-NyFdZN356io/UDXNuriTlVI/AAAAAAAAAXE/sx4HCOG4w0k/s1600/Barclays+Premier+League.png",
               width = 360)
      # list(src = "https://www.w3schools.com/images/lamp.jpg",
      #      contentType = 'image/png',
      #      width = 240,
      #      alt = "")
    })

    output$htmlVideoOut <- renderUI({
      req(video_trigger())
      window_width <- dims[1]
      window_height <- dims[2]
      window_w_calc <- window_height * 16 / 9
      window_h_calc <- window_width * 9 / 16

      window_width <- min(window_width, window_w_calc)
      window_height <- min(window_height, window_h_calc)

      HTML(glue('<iframe width="{window_width}" height="{window_height}" src="//www.youtube.com/embed/GqtlrXnMmug?autoplay=1&enable_js=1?vq=hd720p" frameborder="0" allow = "autoplay *; fullscreen *" allowfullscreen></iframe>'))

    })

    return(livedraft_trigger)
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
  hours = secs %/% 3600
  mins = secs %% 3600 %/% 60
  seconds = secs %% 60

  hours_text = if (hours < 10) {paste0("0", hours)} else hours
  mins_text = if (mins < 10) {paste0("0", mins)} else mins
  seconds_text = if (seconds < 10) {paste0("0", seconds)} else seconds
  if (hours > 0) {
    glue("{hours_text}:{mins_text}:{seconds_text}")
  } else if (mins > 0) {
    glue("{mins_text}:{seconds_text}")
  } else {
    glue("{seconds}")
  }
}
