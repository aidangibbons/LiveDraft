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
#' @importFrom gt gt_output render_gt gt cols_align tab_style cell_fill cells_body cell_text cells_column_labels
#' @importFrom tibble tibble
#' @importFrom purrr map_chr
#' @importFrom dplyr everything across
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
            uiOutput(ns("txtLatestPick")),
            uiOutput(ns("imgLatestPick"))
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
        mutate(across(everything(), ~ifelse(is.na(.), "", .))) %>%
        gt() %>%
        tab_style(style = cell_text(weight = "bold"),
                  locations = cells_column_labels())
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

    output$imgLatestPick <- renderUI({
      req(picksList()$last_change)

      tags$img(src = picksList()$img,
               width = 240)

    })

    output$gtPicksPosition <- render_gt({
      req(picksList())

      pal <- c("#aecfb7", "#aec6cf", "#cfaec6", "#cfb7ae") %>%
        map_chr(t_col)

      picksList()$positions %>%
        select(-Pos) %>%
        mutate(across(everything(), ~ifelse(is.na(.), "", .))) %>%
        gt() %>%
        cols_align(
          align = "center",
          columns = c(everything())
        ) %>%
        tab_style(style = cell_text(weight = "bold"),
                  locations = cells_column_labels()) %>%
        tab_style(
          style = cell_fill(color = pal[1]),
          locations = cells_body(rows = 1:2)
        ) %>%
        tab_style(
          style = cell_fill(color = pal[2]),
          locations = cells_body(rows = 3:7)
        ) %>%
        tab_style(
          style = cell_fill(color = pal[3]),
          locations = cells_body(rows = 8:12)
        ) %>%
        tab_style(
          style = cell_fill(color = pal[4]),
          locations = cells_body(rows = 13:15)
        )

    })
  })
}

