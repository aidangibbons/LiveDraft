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
        p("To find team ID, got to the 'Status' tab on the draft website."),
        p("On the right-hand sidebar, there is the 'Transactions' section. Click 'View Transactions'."),
        p("Your team ID should be visible in your URL in the format 'https://draft.premierleague.com/entry/TEAM_ID/transactions'"),
        textInput(ns("txtLeagueID"), "League ID:"),
        p("OR"),
        textInput(ns("txtTeamID"), "Team ID:"),
        if (failed)
          p("One of League ID or Team ID must be provided.",
            style = "color: red; font-weight: bold; padding-top: 5px;",
            class = "text-center"),
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

