# Building a Prod-Ready, Robust Shiny Application.
#
# README: each step of the dev files is optional, and you don't have to
# fill every dev scripts before getting started.
# 01_start.R should be filled at start.
# 02_dev.R should be used to keep track of your development during the project.
# 03_deploy.R should be used once you need to deploy your app.
#
#
###################################
#### CURRENT FILE: DEV SCRIPT #####
###################################

# Engineering

## Dependencies ----
## Amend DESCRIPTION with dependencies read from package code parsing
## install.packages('attachment') # if needed.
attachment::att_amend_desc()

## Add modules ----
## Create a module infrastructure in R/
golem::add_module(name = "splash_page", with_test = TRUE, open = F) # Name of the module
golem::add_module(name = "countdown", with_test = TRUE, open = F) # Name of the module
golem::add_module(name = "video", with_test = TRUE, open = F)
golem::add_module(name = "main", with_test = T, open = F)

## Add helper functions ----
## Creates fct_* and utils_*
golem::add_fct("helpers", with_test = TRUE, open = F)
golem::add_utils("helpers", with_test = TRUE, open = F)

## External resources
## Creates .js and .css files at inst/app/www
golem::add_js_file("script", open = F)
golem::add_js_handler("handlers", open = F)
golem::add_css_file("custom", open = F)
golem::add_sass_file("custom", open = F)
golem::add_resource_path( 'img', system.file('app/www/img', package = 'golex') )

## Add internal datasets ----
## If you have data in your package
# usethis::use_data_raw(name = "my_dataset", open = FALSE)

## Tests ----
## Add one line by test you want to create
usethis::use_test("app", open = F)

# Documentation

## Vignette ----
usethis::use_vignette("FPLDraftWatchlist")
devtools::build_vignettes()


## CI ----
## Use this part of the script if you need to set up a CI
## service for your application
##
## (You'll need GitHub there)
usethis::use_github()

# GitHub Actions
usethis::use_github_action_check_standard()
# Chose one of the three
# See https://usethis.r-lib.org/reference/use_github_action.html
# usethis::use_github_action_check_release()
# usethis::use_github_action_check_standard()
# usethis::use_github_action_check_full()
# Add action for PR
# usethis::use_github_action_pr_commands()

## Code Coverage----
## Set the code coverage service ("codecov" or "coveralls")
usethis::use_coverage()

## Use Pipe
usethis::use_pipe()


# You're now set! ----
# go to dev/03_deploy.R
rstudioapi::navigateToFile("dev/03_deploy.R")
