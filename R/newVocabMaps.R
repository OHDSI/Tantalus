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

createNewMapTable <- function(connectionDetails,
                                    oldVocab,
                                    newVocab,
                                    targetDatabaseSchema,
                                    newMapsTable){

  sqlFile = "newVocabMaps.sql"

  #create the Db Eval drug summary table
  conn <- DatabaseConnector::connect(connectionDetails)

  sql <- SqlRender::loadRenderTranslateSql(sqlFilename = sqlFile,
                                           packageName = "vocabNative",
                                           dbms = connectionDetails$dbms,
                                           oldVocabSchema = oldVocab,
                                           newVocabSchema = newVocab,
                                           target_database_schema = targetDatabaseSchema,
                                           new_maps_table = newMapsTable)

  writeLines("Run new map vocab table")
  SqlRender::writeSql(sql,"newMapOutput.sql")
  DatabaseConnector::executeSql(connection = conn, sql = sql)
  DatabaseConnector::dbDisconnect(conn)
}
