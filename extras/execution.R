# install.packages(c("DT", "stringdist","shinydashboard","keyring"))
library(Tantalus)
library(DatabaseConnector)
library(keyring)

# key_set(service = "server_url", username="username")
# Sys.setenv(OLD_SCHEMA="VALUE")

cdmDatabaseSchema <- Sys.getenv("OLD_SCHEMA")
oldVocabularyDatabaseSchema <- cdmDatabaseSchema
newVocabularyDatabaseSchema <- Sys.getenv("NEW_SCHEMA")

connectionDetails <- createConnectionDetails(
	dbms      = "sql server",
	server    = Sys.getenv("AWS_VOCAB_DATABASE_SERVER"),
	user      = Sys.getenv("AWS_VOCAB_USERNAME"),
	password  = key_get(service = Sys.getenv("AWS_VOCAB_DATABASE_SERVER"), username = Sys.getenv("AWS_VOCAB_USERNAME")),
	port      = 1433
)

# test connection
# conn <- DatabaseConnector::connect(connectionDetails)
# DatabaseConnector::disconnect(conn)

result = compareVocabData(connectionDetails = connectionDetails,
													cdmDatabaseSchema = cdmDatabaseSchema,
													oldVocabularyDatabaseSchema = oldVocabularyDatabaseSchema,
													newVocabularyDatabaseSchema = newVocabularyDatabaseSchema,
													findPrevalences = FALSE)
Tantalus::saveComparisonResults(results = result)

diffSummary <- Tantalus::createDiffSummary(connectionDetails,oldVocabularyDatabaseSchema,newVocabularyDatabaseSchema)
Tantalus::saveDiffResults(diffSummary)

#launchComparisonExplorer(result)

# rmarkdown::render(
# 	input       = "inst/reports/GenerateDiffReport.Rmd",
# 	output_dir  = reportFileLoc,
# 	output_file = "diffSummary.html",
# 	params      = list(JSONFile=ResultSets$JSONFile)
# )



