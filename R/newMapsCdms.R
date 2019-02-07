# Copyright 2019 Observational Health Data Sciences and Informatics
#
# This file is part of DatabaseEvaluation
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

#' Return the vocab domain changes table
#'
#'
#' @param oldVocab  The name of the old vocabulary to be compared. On SQL
#'                                     Server, this should specifiy both the database and the schema,
#'                                     so for example 'target_instance.dbo'.
#' @param newVocab             The name of the new vocabulary to be compared.
#'
#' @export
#'

runNewMapsCdm <- function(connectionDetails,
                            targetDatabaseSchema,
                            oracleTempSchema = NULL,
                            newMapsCdmTable,
                            newVocabSchema,
                            newMapsTable){

  #create the Db Eval tables
  conn <- DatabaseConnector::connect(connectionDetails)

  sql <- SqlRender::loadRenderTranslateSql(sqlFilename = "createNewMapsCdm.sql",
                                           packageName = "vocabNative",
                                           dbms = connectionDetails$dbms,
                                           oracleTempSchema = oracleTempSchema,
                                           target_database_schema = targetDatabaseSchema,
                                           new_maps_cdm_table = newMapsCdmTable)

  writeLines("Create new maps cdm table in scratch to insert data into")
  SqlRender::writeSql(sql,"output/createNewMapsCdmOutput.sql")
  DatabaseConnector::executeSql(conn, sql, progressBar = TRUE, reportOverallTime = TRUE)


  databaseNum <- nrow(databases)
  #insert the data

  for(i in 1:databaseNum){

    sql <- SqlRender::loadRenderTranslateSql(sqlFilename = "newVocabMapsCdms.sql",
                                             packageName = "vocabNative",
                                             dbms = connectionDetails$dbms,
                                             oracleTempSchema = oracleTempSchema,
                                             source_short_name = paste0("'",databases$shortName[i],"'"),
                                             cdm_database_schema = databases$cdmDatabaseSchema[i],
                                             target_database_schema = targetDatabaseSchema,
                                             new_vocab_schema = newVocabSchema,
                                             new_maps_table = newMapsTable,
                                             new_maps_cdm_table = newMapsCdmTable)

    SqlRender::writeSql(sql,"output/newMapsCdmOutput.sql")
    writeLines(paste0("Running new map vocab summary for ",databases$shortName[i]))
    DatabaseConnector::executeSql(conn, sql, progressBar = TRUE, reportOverallTime = TRUE)
  }
  DatabaseConnector::dbDisconnect(conn)

}
