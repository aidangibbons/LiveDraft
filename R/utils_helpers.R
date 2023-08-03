#' helpers
#'
#' @description A utils function
#'
#' @return The return value, if any, from executing the utility.
#'
#' @noRd
load_global_variables <- function () {
  fpl_col <<- "#480442"
  fpl_accent <<- "#68F1B0"

  ## TODO update this

  is_live <<- F

  video_duration <<- 50

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


