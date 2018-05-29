# results <- readRDS("s:/temp/result.rds")
results$prevalence <- formatC(results$prevalence * 100, digits = 3, format = "f")
results$stringDist <- formatC(results$stringDist, digits = 1, format = "f")
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



