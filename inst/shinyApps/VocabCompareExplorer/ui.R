library(shiny)
library(DT)


shinyUI(fluidPage(titlePanel("OHDSI Vocabulary Comparator"),
                  fluidRow(column(2,
                                  checkboxInput("filterZeroPrevalence", "Remove issues with zero prevalence"),
                                  h3("Summaries"),
                                  selectInput("aggregateKey", label = "Aggregation key", choices = c("Domain", "Vocabulary", "Description")),
                                  dataTableOutput("perAggregateKey")), column(10, dataTableOutput("allResultsTable")))))
