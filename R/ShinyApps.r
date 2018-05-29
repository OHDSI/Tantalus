# Copyright 2018 Observational Health Data Sciences and Informatics
#
# This file is part of Tantalus
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#' Launch the comparison explorer
#'
#' @param results          The data object created by the \code{\link{compareVocabularies}}.
#' @param launch.browser   Should the app be launched in your default browser (TRUE), or in a Shiny
#'                         window (FALSE)?
#'
#' @details
#' Launches a Shiny app that allows the user to explore the results of a vocabulary comparison.
#'
#' @export
launchComparisonExplorer <- function(results, launch.browser = TRUE) {
  appDir <- system.file("shinyApps", "VocabCompareExplorer", package = "Tantalus")
  .GlobalEnv$results <- results
  on.exit(rm(results, envir = .GlobalEnv))
  shiny::runApp(appDir, display.mode = "normal", launch.browser = launch.browser)
}
