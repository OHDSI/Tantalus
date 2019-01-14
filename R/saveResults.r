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

#' Save results to Shiny App
#'
#' @param results          The data object created by the \code{\link{compareVocabularies}}.

#' @details
#' Saves results out to a data frame for use in a published shiny app.
#'
#' @export
saveComparisonResults <- function(results) {
	dataDirectory <- system.file("shinyApps", "VocabCompareExplorer", "data", package = "Tantalus")
	resultsFile <- file.path(dataDirectory,"results.rds")
	saveRDS(results, resultsFile)
}


#' Save json diff Results to Shiny App
#'
#' @param jsonResults          The data object created by the \code{\link{createDiffSummary}}.

#' @details
#' Saves results out to json file for use in a published shiny app.
#'
#' @export
saveDiffResults <- function(diffResults) {
	dataDirectory <- system.file("shinyApps", "VocabCompareExplorer", "data", package = "Tantalus")
	resultsFile <- file.path(dataDirectory,"diffResults.json")
	jsonlite::write_json(diffResults, resultsFile)
}
