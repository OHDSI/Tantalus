source("functions.R")

# read data
# result <- readRDS(file.path("data","result.rds"))

# set the correct data types and colnames (can be removed once done in the R package)
results <- data.frame(testId = result$testId,
											testDescription = as.factor(result$testDescription),
											vocabularyTable = as.factor(result$vocabularyTable),
									    conceptId = as.character(result$conceptId),
									    conceptName = result$conceptName,
									    vocabularyId = as.factor(result$vocabularyId),
									 		domainId = as.factor(result$domainId),
									 		oldValue = result$oldValue,
									 		newValue = result$newValue,
									 		prevalence = as.numeric(formatC(result$prevalence * 100, digits = 3, format = "f")),
											stringDist = as.numeric(result$stringDist),

											# too time consuming to add here, will move to the result set generation side later
									 		# numCheck = apply(result,1,checkNumericValues),

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

