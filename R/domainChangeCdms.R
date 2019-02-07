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

runDomainChangeCdm <- function(connectionDetails,
                            targetDatabaseSchema,
                            oracleTempSchema = NULL,
                            domainChangeTable,
                            oldVocabSchema,
                            domainChangeCdmTable){

  #create the Db Eval tables
  conn <- DatabaseConnector::connect(connectionDetails)

  sql <- SqlRender::loadRenderTranslateSql(sqlFilename = "createDomainChangeCdm.sql",
                                           packageName = "vocabNative",
                                           dbms = connectionDetails$dbms,
                                           oracleTempSchema = oracleTempSchema,
                                           target_database_schema = targetDatabaseSchema,
                                           domain_change_cdm_table = domainChangeCdmTable)

  writeLines("Create domain change cdm table in scratch to insert data into")
  SqlRender::writeSql(sql,"output/createDomainChangeCdmOutput.sql")
  DatabaseConnector::executeSql(conn, sql, progressBar = TRUE, reportOverallTime = TRUE)


  databaseNum <- nrow(databases)
  #insert the data

  for(i in 1:databaseNum){

    sql <- SqlRender::loadRenderTranslateSql(sqlFilename = "domainChangeCdms.sql",
                                             packageName = "vocabNative",
                                             dbms = connectionDetails$dbms,
                                             oracleTempSchema = oracleTempSchema,
                                             cdm_database_schema = databases$cdmDatabaseSchema[i],
                                             domain_change_table = domainChangeTable,
                                             target_database_schema = targetDatabaseSchema,
                                             old_vocab_schema = oldVocabSchema,
                                             source_short_name = paste0("'",databases$shortName[i],"'"),
                                             domain_change_cdm_table = domainChangeCdmTable)

    SqlRender::writeSql(sql,"output/domainChangeCdmOutput.sql")
    writeLines(paste0("Running domain change vocab summary for ",databases$shortName[i]))
    DatabaseConnector::executeSql(conn, sql, progressBar = TRUE, reportOverallTime = TRUE)
  }
  DatabaseConnector::dbDisconnect(conn)

}
