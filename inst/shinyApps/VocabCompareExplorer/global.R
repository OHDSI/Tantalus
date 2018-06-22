source("functions.R")

# read data
# results <- readRDS(file.path("data","result.rds"))

# set the correct data types and colnames (can be removed once done in the R package)
results <- data.frame(testId = results$testId,
		      testDescription = as.factor(results$testDescription),
		      vocabularyTable = as.factor(results$vocabularyTable),
		      conceptId = as.character(results$conceptId),
		      conceptName = results$conceptName,
		      vocabularyId = as.factor(results$vocabularyId),
		      domainId = as.factor(results$domainId),
		      oldValue = results$oldValue,
		      newValue = results$newValue,
		      prevalence = as.numeric(formatC(results$prevalence * 100, digits = 3, format = "f")),					
		      stringDist = as.numeric(results$stringDist),
		      stringsAsFactors = FALSE
)
colnames(results)[colnames(results) == "testId"] <- "ID"
colnames(results)[colnames(results) == "testDescription"] <- "Description"
colnames(results)[colnames(results) == "vocabularyTable"] <- "Table"
colnames(results)[colnames(results) == "conceptId"] <- "Concept ID"
colnames(results)[colnames(results) == "conceptName"] <- "Concept name"
colnames(results)[colnames(results) == "vocabularyId"] <- "Vocabulary"
colnames(results)[colnames(results) == "domainId"] <- "Domain"
colnames(results)[colnames(results) == "oldValue"] <- "Old value"
colnames(results)[colnames(results) == "newValue"] <- "New value"
colnames(results)[colnames(results) == "prevalence"] <- "Prevalence"
colnames(results)[colnames(results) == "stringDist"] <- "Value difference"

# retrieve the version information from the result set
versions <- results[results$ID == 1.01,]
oldVersion <- versions$`Old value`
newVersion <- versions$`New value`

