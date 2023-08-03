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
    uiOutput(ns("uiSplash"))
  )
}

#' splash_page Server Functions
#'
#' @noRd
mod_splash_page_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    output$uiSplash <- renderUI({
      tagList(

      )
    })

    splashModal <- function (failed = F) {
      modalDialog(
        h1("Enter league ID (if known), or team ID"),
        p("TODO - enter explanation to get team ID here."),
        p("Note - Team ID text box doesn't work. It will just assume you've entered a league ID."),
        textInput(ns("txtLeagueID"), "League ID:"),
        textInput(ns("txtTeamID"), "Team ID:"),
        if (failed)
          p("TODO - make this red. One of League ID or Team ID must be provided."),
        footer = actionButton(ns("btnConfirm"), "Confirm")
      )
    }

    league_id <- reactiveVal(NULL)

    # TODO copy final showModal example here, showing on startup, and closing on success
    observe({
      req(is.null(league_id()))

      showModal(splashModal())
    })

    observeEvent(input$btnConfirm, {

      lg <- input$txtLeagueID %>% clean_numeric_input
      tm <- input$txtTeamID %>% clean_numeric_input

      if (!is.null(lg) & !is.na(lg)) {
        league_id(lg)
        removeModal()
      } else if (!is.null(tm) & !is.na(tm)) {
        league_id(
          team_id_to_league_id(tm)
        )
        removeModal()
      } else {
        # TODO make error text appear
        updateTextInput(session, ns("txtLeagueID"), value = "")
        updateTextInput(session, ns("txtTeamID"), value = "")
        showModal(splashModal(failed=T))
      }
    })

    return(league_id = league_id)
  })
}

clean_numeric_input <- function(t) {
  tryCatch({
    as.numeric(t)
  }, error = function(e) {
    return(NULL)
  })
}

team_id_to_league_id <- function (t) {
  # TODO do this
  t
}
