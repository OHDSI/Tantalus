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

#' Compare two vocabularies
#'
#' @description
#' This function enables you to compare two vocabularies at the row level.
#'
#' @param connectionDetails             An R object of type\cr\code{connectionDetails} created using
#'                                      the function \code{createConnectionDetails} in the
#'                                      \code{DatabaseConnector} package.
#' @param cdmDatabaseSchema             The name of the database schema that contains the OMOP CDM
#'                                      instance.  Requires read permissions to this database. On SQL
#'                                      Server, this should specifiy both the database and the schema,
#'                                      so for example 'cdm_instance.dbo'.
#' @param oldVocabularyDatabaseSchema   The name of the database schema that contains the old
#'                                      vocabulary instance.  Requires read permissions to this
#'                                      database. On SQL Server, this should specifiy both the database
#'                                      and the schema, so for example 'cdm_vocab.dbo'.
#' @param newVocabularyDatabaseSchema   The name of the database schema that contains the ewvocabulary
#'                                      instance.  Requires read permissions to this database. On SQL
#'                                      Server, this should specifiy both the database and the schema,
#'                                      so for example 'cdm_vocab.dbo'.
#' @param findPrevalences               A boolean flag to indicate whether or not run
#'                                      FetchPrevalences.sql
#' @param oracleTempSchema              For Oracle only: the name of the database schema where you want
#'                                      all temporary tables to be managed. Requires create/insert
#'                                      permissions to this database.
#'
#' @export
compareVocabData <- function(connectionDetails,
                                cdmDatabaseSchema,
                                oldVocabularyDatabaseSchema = cdmDatabaseSchema,
                                newVocabularyDatabaseSchema,
                                findPrevalences = FALSE,
                                oracleTempSchema = NULL) {
  conn <- DatabaseConnector::connect(connectionDetails)
  writeLines("Running vocabulary comparisons")
  pathToSql <- system.file("sql/sql_server", package = "Tantalus")
  sqlFiles <- list.files(pathToSql, pattern = "Test.*.sql")
  sqlMapFiles <- list.files(pathToSql, pattern = "MapSource.*.sql")
  tempTableNames <- paste0("#temp_", 1:length(sqlFiles))
  hasData <- rep(FALSE, length(sqlFiles))

  for (i in 1:length(sqlMapFiles)) {
    writeLines(paste("- Running", sqlMapFiles[i]))
    sql <- SqlRender::loadRenderTranslateSql(sqlFilename = sqlMapFiles[i],
                                             packageName = "Tantalus",
                                             dbms = connectionDetails$dbms,
                                             oracleTempSchema = oracleTempSchema,
                                             old_vocabulary_database_schema = oldVocabularyDatabaseSchema,
                                             new_vocabulary_database_schema = newVocabularyDatabaseSchema)
    DatabaseConnector::executeSql(conn, sql, progressBar = FALSE, reportOverallTime = TRUE)
  }

  for (i in 1:length(sqlFiles)) {
    writeLines(paste("- Running", sqlFiles[i]))
    sql <- SqlRender::loadRenderTranslateSql(sqlFilename = sqlFiles[i],
                                             packageName = "Tantalus",
                                             dbms = connectionDetails$dbms,
                                             oracleTempSchema = oracleTempSchema,
                                             old_vocabulary_database_schema = oldVocabularyDatabaseSchema,
                                             new_vocabulary_database_schema = newVocabularyDatabaseSchema,
                                             result_temp_table = tempTableNames[i])
    DatabaseConnector::executeSql(conn, sql, progressBar = FALSE, reportOverallTime = TRUE)
    sql <- "SELECT COUNT(*) FROM @result_temp_table"
    sql <- SqlRender::renderSql(sql, result_temp_table = tempTableNames[i])$sql
    sql <- SqlRender::translateSql(sql,
                                   targetDialect = connectionDetails$dbms,
                                   oracleTempSchema = oracleTempSchema)$sql
    count <- DatabaseConnector::querySql(conn, sql)
    hasData[i] <- (count > 0)
  }
  if (any(hasData)) {
    tablesWithData <- tempTableNames[hasData]

    # Pulling all concept IDs into temp table ----------------
    sql <- paste0("SELECT concept_id\nINTO #concept_ids\nFROM (\n",
                  paste0(paste0("  SELECT concept_id FROM ", tablesWithData),
                         collapse = "\n  UNION\n"),
                  "\n) temp\nWHERE concept_id != 0;")
    sql <- SqlRender::translateSql(sql = sql,
                                   targetDialect = connectionDetails$dbms,
                                   oracleTempSchema = oracleTempSchema)$sql
    DatabaseConnector::executeSql(conn, sql, progressBar = FALSE, reportOverallTime = FALSE)

    if (findPrevalences) {

      # Get prevalences for relevant concept IDs ---------------
      writeLines("Fetching prevalences of relevant concept IDs")
      sql <- SqlRender::loadRenderTranslateSql(sqlFilename = "FetchPrevalences.sql",
                                               packageName = "Tantalus",
                                               dbms = connectionDetails$dbms,
                                               oracleTempSchema = oracleTempSchema,
                                               cdm_database_schema = cdmDatabaseSchema)
      DatabaseConnector::executeSql(conn, sql, progressBar = FALSE, reportOverallTime = TRUE)

      # Fetch all data from server -------------------------------
      sql <- paste("SELECT results.*, prevalences.prevalence FROM #prevalences prevalences RIGHT JOIN (",
                   paste(paste("SELECT * FROM", tablesWithData), collapse = "\nUNION ALL\n"),
                   ") results ON prevalences.concept_id = results.concept_id")
    } else {

      sql <- paste("SELECT results.* FROM (",
                   paste(paste("SELECT * FROM", tablesWithData), collapse = "\nUNION ALL\n"),
                   ") results")
    }

    sql <- SqlRender::translateSql(sql = sql,
                                   targetDialect = connectionDetails$dbms,
                                   oracleTempSchema = oracleTempSchema)$sql
    result <- DatabaseConnector::querySql(conn, sql)
    colnames(result) <- SqlRender::snakeCaseToCamelCase(colnames(result))

    # Add a string comparison metric
    result$stringDist <- stringdist::stringdist(result$oldValue, result$newValue)
  } else {
    result <- data.frame()
  }

  # Drop temp tables ----------------------------------
  if (findPrevalences) {
    allTempTables <- c(tempTableNames, "#concept_ids", "#prevalences")
  } else {
    allTempTables <- c(tempTableNames, "#concept_ids")
  }

  sql <- paste0("TRUNCATE TABLE ", allTempTables, "; DROP TABLE ", allTempTables, ";")
  sql <- paste(sql, collapse = "\n")
  sql <- SqlRender::translateSql(sql = sql,
                                 targetDialect = attr(conn, "dbms"),
                                 oracleTempSchema = oracleTempSchema)$sql
  DatabaseConnector::executeSql(conn, sql, progressBar = FALSE, reportOverallTime = FALSE)
  DatabaseConnector::disconnect(conn)

  # Run additional checks in R
  result <- runRChecks(result)

  return(result)
}

#' @export
runRChecks <- function(result) {
	# Check to find differences between the two vocabularies in numbers in the string
	# This is useful to find for example drug strength or unit changes

	result$numCheck = apply(result,1,checkNumericDifference)

	return(result)
}
