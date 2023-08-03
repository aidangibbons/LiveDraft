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
mod_main_server <- function(id, livedraft_trigger, league){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    player_details <- url_bootstrap_static %>%
      get_url_data() %>%
      {.$elements} %>%
      tibble %>%
      select(web_name, id, first_name, second_name)

    output$uiMain <- renderUI({
      req(livedraft_trigger())
      tagList(
        fluidRow(
          column(
            width = 5, align = "center",
            gt_output(ns("gtPicks"))
          ),
          column(
            width = 2, align = "center",
            # imageOutput(ns("imgLatestPick")),
            htmlOutput(ns("txtLatestPick"))
          ),
          column(
            width = 5, align = "center",
            gt_output(ns("gtPicksPosition"))
          )
        )
      )
    })

    picksList <- reactive({
      req(livedraft_trigger())
      req(!is.null(league()))
      invalidateLater(wait_timer * 1000)

      table_live_draft_picks(league())
    })

    output$gtPicks <- render_gt({
      req(picksList())

      picksList()$picks %>%
        gt
    })

    output$txtLatestPick <- renderUI({
      req(picksList())

      HTML(
        paste0(
          "<div><h1><center>",
          #"<div style='background-color:",bg_col,"'>",
          picksList()$latest,
          "</h1></center></div>"
        )
      )
    })

    # output$imgLatestPick <- renderImage({
    #   req(livedraft_trigger())
    #   invalidator()
    #
    # })

    output$gtPicksPosition <- render_gt({
      req(picksList())

      pos_df <- picksList()$positions

      color.gkp <- which(pos_df$Pos == "GKP")
      color.def <- which(pos_df$Pos == "DEF")
      color.mid <- which(pos_df$Pos == "MID")
      color.fwd <- which(pos_df$Pos == "FWD")

      # if (ncol(pos_df) == 2) {
      #   return(
      #     tibble() %>%
      #       kbl %>%
      #       kable_styling
      #   )
      # }

      picksList()$positions %>%
        select(-Pos) %>%
        gt
        # kbl %>%
        # kable_styling %>%
        # row_spec(color.gkp, color = darker.col(fpl_accent, 100), background = t_col("#aecfb7")) %>%
        # row_spec(color.def, color = darker.col(fpl_accent, 100), background = t_col("#aec6cf")) %>%
        # row_spec(color.mid, color = darker.col(fpl_accent, 100), background = t_col("#cfaec6")) %>%
        # row_spec(color.fwd, color = darker.col(fpl_accent, 100), background = t_col("#cfb7ae"))
    })
  })
}

