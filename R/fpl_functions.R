#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param url PARAM_DESCRIPTION
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @rdname get_url_data
#' @export
#' @importFrom curl curl
#' @importFrom jsonlite fromJSON
get_url_data <- function (url) {
  url %>%
    curl %>%
    fromJSON(simplifyVector = T)
}


url_league_details <- function (league) {paste0("https://draft.premierleague.com/api/league/", league, "/details")}
url_league_draft_picks <- function (league) {paste0("https://draft.premierleague.com/api/draft/", league, "/choices")}

#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param league PARAM_DESCRIPTION, Default: league_id
#' @param plot_table PARAM_DESCRIPTION, Default: F
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @rdname table_live_draft_picks
#' @export
#' @importFrom dplyr mutate select filter slice pull arrange group_by ungroup first rename left_join n
#' @importFrom stringr str_sub
#' @importFrom tibble tibble
#' @importFrom tidyr pivot_wider
#' @importFrom lubridate as_datetime hours int_diff
table_live_draft_picks <- function (league, plot_table = F) {
  bs_static <- url_bootstrap_static %>%
    get_url_data()

  current_picks <- league %>%
    url_league_draft_picks %>%
    get_url_data() %>%
    {.$choices} %>%
    tibble

  player_details <- get_player_details(bs_static) %>%
    select(web_name, id, first_name, second_name, position)

  picks_with_players <- current_picks %>%
    mutate(player_name = paste(player_first_name, str_sub(player_last_name, 1, 1))) %>%
    left_join(player_details %>%
                select(web_name, id, position), by = c("element" = "id"))

  chosen_players <- picks_with_players %>%
    arrange(index) %>%
    group_by(entry) %>%
    mutate(pick_order = first(index)) %>%
    ungroup %>%
    select(player_name, web_name, round) %>%
    rename("R" = round) %>%
    pivot_wider(names_from = player_name,
                values_from = web_name)

  # table of which positions have been taken
  bootstrap_squad <- bs_static$settings$squad

  req_pos_df <- tibble(position =
                         c(rep("GKP", bootstrap_squad$select_GKP),
                           rep("DEF", bootstrap_squad$select_DEF),
                           rep("MID", bootstrap_squad$select_MID),
                           rep("FWD", bootstrap_squad$select_FWD))
  ) %>%
    group_by(position) %>%
    mutate(selection = 1:n()) %>%
    ungroup

  players_position_picks <- picks_with_players %>%
    group_by(player_name, position) %>%
    mutate(selection = 1:n()) %>%
    ungroup %>%
    select(player_name, position, selection, web_name) %>%
    pivot_wider(names_from = player_name,
                values_from = web_name)

  positions_df <- req_pos_df %>%
    left_join(players_position_picks,
              by = c("position", "selection")) %>%
    rename("Pos" = position) %>%
    select(-selection)

  last_pick <- picks_with_players %>%
    filter(!is.na(element)) %>%
    slice(n()) %>%
    left_join(player_details %>%
                select(first_name, second_name, id), by = c("element" = "id"))

  last_change <- picks_with_players %>%
    filter(!is.na(choice_time)) %>%
    slice(n()) %>%
    pull(choice_time) %>%
    as_datetime()


  calc_time_diff <- abs(as.numeric(int_diff(c(Sys.time(), last_change + hours(1)))))

  last_pick_text <- glue("{toupper(last_pick$player_first_name)} chose {toupper(last_pick$web_name)}")


  if (plot_table) {

    return(grid.arrange(chosen_players %>% tableGrob(),
                        last_pick_text %>% tableGrob(),
                        calc_time_diff %>% tableGrob()))
  }

  # get the image file for the latest address
  latest_player_id <- picks_with_players %>%
    filter(!is.na(choice_time)) %>%
    slice(n()) %>%
    pull(element)

  next_player <- picks_with_players %>% filter(is.na(choice_time)) %>% slice(1) %>%
    pull(player_name)

  next_pick <- if (length(next_player) != 0) {
    paste0("Next Pick:<br/>", next_player)
  } else {
    "Draft is complete!"
  }

  latest_player_img_file <- "TODO"

  return(list("picks" = chosen_players,
              "latest" = last_pick_text,
              "positions" = positions_df,
              "last_change" = calc_time_diff,
              "img" = latest_player_img_file,
              "next_pick" = next_pick))
}

#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param type PARAM_DESCRIPTION, Default: c("general", "gw")[1]
#' @param extra_cols PARAM_DESCRIPTION, Default: c("sample", "sample")
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @rdname get_player_details
#' @export
#' @importFrom dplyr select rename left_join
#' @importFrom tibble tibble
get_player_details <- function (bs_static) {

  # select only constant columns if "general" is chosen
  player_details <- bs_static$elements %>%
    tibble %>%
    select(id, code, element_type, first_name, second_name, web_name, team)

  # bind on team information
  player_details_team <- player_details %>%
    left_join(bs_static$teams %>%
                select(id, code, name, short_name) %>%
                rename("team_name" = "name",
                       "team_name_short" = "short_name",
                       "team_code" = "code"),
              by = c("team" = "id"))

  # bind on position information
  player_details_position <- player_details_team %>%
    left_join(bs_static$element_types %>%
                select(id, singular_name_short) %>%
                rename("position" = "singular_name_short"),
              by = c("element_type" = "id"))

  player_details_position %>%
    tibble()
}
