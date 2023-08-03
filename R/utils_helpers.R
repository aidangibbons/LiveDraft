#' helpers
#'
#' @description A utils function
#'
#' @return The return value, if any, from executing the utility.
#'
#' @noRd
load_global_variables <- function () {
  # is the app live or in production
  is_live <<- F
  is_local <<- T

  # colours
  fpl_col <<- "#480442"
  fpl_accent <<- "#68F1B0"

  # FPL variables
  url_bootstrap_dynamic <<- "https://draft.premierleague.com/api/game"
  url_bootstrap_static <<- "https://draft.premierleague.com/api/bootstrap-static"


  # timer variables
  video_duration <<- 45
  video_added_duration <<- 10
  vid_trigger_time <<- video_duration + video_added_duration
  wait_timer <<- 2
}

t_col <- function(colour, percent = 10, name = NULL) {
  #      color = color name
  #    percent = % transparency
  #       name = an optional name for the color

  ## Get RGB values for named color
  rgb.val <- col2rgb(colour)

  ## Make new color using input color as base and alpha set by transparency
  t.col <- rgb(rgb.val[1], rgb.val[2], rgb.val[3],
               max = 255,
               alpha = (100 - percent) * 255 / 100,
               names = name)

  ## Save the color
  t.col
}

darker.col = function(color, how.much = 20){
  colorRampPalette(c(color, "black"))(100)[how.much]
}

print_dev <- function(p) {
  if (is_local) {
    print(p)
  }
}
