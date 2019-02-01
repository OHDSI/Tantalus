#This will run the vocab queries and put them on scratch

library(DatabaseConnector)
library(devtools)

## Update the database connection parameters
pathToCsv <- system.file("settings", "config.csv", package = "vocabNative")
config <- read.csv(pathToCsv, stringsAsFactors = FALSE, row.names = NULL)

## Update the database parameters (schema, etc.)
pathToCsv <- system.file("settings", "databases.csv", package = "vocabNative")
databases <- read.csv(pathToCsv, stringsAsFactors = FALSE)

## create the connectionDetails object

vocabConnectionDetails <- DatabaseConnector::createConnectionDetails(dbms = config[which(config$type=="vocab"),2],
                                                                server = config[which(config$type=="vocab"),5],
                                                                port = config[which(config$type=="vocab"),6]
                                                                )

cdmConnectionDetails <- DatabaseConnector::createConnectionDetails(dbms = config[which(config$type=="cdms"),2],
                                                                     server = config[which(config$type=="cdms"),5],
                                                                     port = config[which(config$type=="cdms"),6])

## Start with the domain changes
createDomainChangeTable(connectionDetails = vocabConnectionDetails,
                        targetDatabaseSchema = "Scratch.dbo",
                        domainChangeTable = "Vocab20190123_domainChanges",
                        oldVocab = "Vocabulary_20180609.dbo",
                        newVocab = "Vocabulary_20190123.dbo")


## Then find mappings that are new to this vocab version
newMaps <- createNewMapTable(connectionDetail = vocabConnectionDetails,
                             oldVocab = "Vocabulary_20180609.dbo",
                             newVocab = "Vocabulary_20190123.dbo",
                             targetDatabaseSchema = "Scratch.dbo",
                             newMapsTable = "Vocab20190123_newMaps")

## Then find mappings that have changed
mapSwitches <- createMapSwitchesTable(connectionDetails = vocabConnectionDetails,
                                      oldVocab = "Vocabulary_20180609.dbo",
                                      newVocab = "Vocabulary_20190123.dbo",
                                      targetDatabaseSchema = "Scratch.dbo",
                                      mapSwitchesTable = "Vocab20190123_mapSwitches")


## Run the code to find how the changes impact the cdms

runDomainChangeCdm(connectionDetails = cdmConnectionDetails,
                   targetDatabaseSchema = "Scratch.dbo",
                   oracleTempSchema = NULL,
                   domainChangeTable = "Vocab20190123_domainChanges",
                   oldVocabSchema = "Vocabulary_20180609.dbo",
                   domainChangeCdmTable = "Vocab20190123_domainChangesCdms")


runNewMapsCdm(connectionDetails = cdmConnectionDetails,
              targetDatabaseSchema = "Scratch.dbo",
              oracleTempSchema = NULL,
              newMapsCdmTable = "Vocab20190123_newMapsCdms",
              newVocabSchema = "Vocabulary_20190123.dbo",
              newMapsTable = "Vocab20190123_newMaps")


runMapSwitchesCdm(connectionDetails = cdmConnectionDetails,
                  targetDatabaseSchema = "Scratch.dbo",
                  oracleTempSchema = NULL,
                  mapSwitchesCdmTable = "Vocab20190123_mapSwitchesCdms",
                  newVocabSchema = "Vocabulary_20190123.dbo",
                  mapSwitchesTable = "Vocab20190123_mapSwitches")


