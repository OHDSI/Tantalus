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

#' @title
#' Generate a diff between two specified vocabularies.
#'
#' @description
#' This function finds high level differences between two specified vocabularies. The return value,
#' ResultSets, is just a list of results from the specified queries (as well as the name of the JSON
#' file created).  The list ResultSets is used to create a JSON object that is written out to a file
#' and is later called by GenerateDiffReport.Rmd.
#'
#' @details  In an effort to assess the vocabulary proper (rather than the entire CDM), only the following
#'           tables are considered:
#'            1. CONCEPT 
#'            2. CONCEPT_SYNONYM 
#'            3. CONCEPT_ANCESTOR 
#'            4. CONCEPT_RELATIONSHIP 
#'            5. CONCEPT_CLASS 
#'            6. DOMAIN 
#'            7. RELATIONSHIP
#'
#' @param connectionDetails             An R object of type\cr\code{connectionDetails} created using
#'                                      the function \code{createConnectionDetails} in the
#'                                      \code{DatabaseConnector} package.
#' @param oldVocabularyDatabaseSchema   The name of the database schema that contains the old
#'                                      vocabulary instance.  Requires read permissions to this
#'                                      database. On SQL Server, this should specify both the database
#'                                      and the schema, so for example 'cdm_vocab.dbo'.
#' @param newVocabularyDatabaseSchema   The name of the database schema that contains the new
#'                                      vocabulary instance.  Requires read permissions to this
#'                                      database. On SQL Server, this should specify both the database
#'                                      and the schema, so for example 'cdm_vocab.dbo'.
#' @param JSONFileLoc                   Location of the JSON file created by the function.
#' @param oracleTempSchema              For Oracle only: the name of the database schema where you want
#'                                      all temporary tables to be managed. Requires create/insert
#'                                      permissions to this database.
#'
#' @export


diffVocabularies <- function(connectionDetails,
                             oldVocabularyDatabaseSchema,
                             newVocabularyDatabaseSchema,
                             JSONFileLoc,
                             oracleTempSchema = NULL) {


  # List to hold the query results
  ResultSets <- list()

  pathToSql <- system.file("sql/sql_server", package = "Tantalus")
  sqlFiles <- list.files(pathToSql, pattern = "Count*.*sql")
  sqlFiles[length(sqlFiles)+1] <- "GetVocabVersion.sql" 

  invisible(capture.output({
    conn <- DatabaseConnector::connect(connectionDetails)
  }))


  # Execute queries: 

  for (k in 1:length(sqlFiles)) {

    sql <- SqlRender::loadRenderTranslateSql(sqlFilename = sqlFiles[k],
                                             packageName = "Tantalus",
                                             dbms = connectionDetails$dbms,
                                             oracleTempSchema = oracleTempSchema,
                                             old_vocabulary_database_schema = oldVocabularyDatabaseSchema,
                                             new_vocabulary_database_schema = newVocabularyDatabaseSchema)

    queryName <- substr(sqlFiles[k], 1, nchar(sqlFiles[k]) - 4)

    print(paste0("Processing query: ", queryName))

    queryResults <- DatabaseConnector::querySql(conn, sql)

    # Use the name of the query to build list attributes (and identify the the results of the query):
    # ResultSets$CountSummaryDiff ResultSets$CountConceptDomainChanges etc...

    ResultSets[[queryName]] <- queryResults

  }

  DatabaseConnector::disconnect(conn)


  # Create json file using the list of query result sets

  ResultSetJSON <- jsonlite::toJSON(ResultSets, pretty = TRUE)


  # Write out json file to be used later by markdown Use the vocab names in the name of the JSON file

  JSONFileName <- paste0(JSONFileLoc,
                         "VocabDiffReport-",
                         ResultSets$GetVocabVersion$CURRENT_VOCAB,
                         "-",
                         ResultSets$GetVocabVersion$PRIOR_VOCAB,
                         ".json")

  ResultSets$JSONFile <- JSONFileName

  write(ResultSetJSON, ResultSets$JSONFile)

  return(ResultSets)

}


