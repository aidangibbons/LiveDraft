#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    fluidPage(
      mod_splash_page_ui("splash"),
      mod_countdown_ui("countdown"),
      mod_video_ui("video"),
      mod_main_ui("main")
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @importFrom bslib bs_theme
#' @importFrom scroller use_scroller
#' @importFrom shinyjs useShinyjs
#' @noRd
golem_add_external_resources <- function() {
  fpl_col <<- "#480442"
  fpl_accent <<- "#68F1B0"

  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "LiveDraft"
    ),
    tags$style(type="text/css", ".recalculating {opacity: 1.0;}"),
    use_scroller(),
    useShinyjs(),
    theme = bs_theme(bg = fpl_col, fg = fpl_accent, bootswatch = "flatly")
  )
}
