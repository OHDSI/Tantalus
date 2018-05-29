library(shiny)
library(DT)

shinyServer(function(input, output, session) {

  filteredData <- reactive({
    if (input$filterZeroPrevalence) {
      return(results[results$Prevalence != "0.000", ])
    } else {
      return(results)
    }
  })

  keyToRows <- reactive({
    formula <- as.formula(paste("ID ~", input$aggregateKey))
    aggregate(formula, data = filteredData(), length)
  })

  output$allResultsTable <- renderDataTable({
    table <- filteredData()
    selected <- input$perAggregateKey_rows_selected
    if (!is.null(selected)) {
      keys <- keyToRows()[, 1]
      table <- table[table[, input$aggregateKey] == keys[selected], ]
    }
    return(table)
  }, options = list(lengthChange = FALSE,
                    pageLength = 10,
                    searching = FALSE), selection = "single", rownames = FALSE)

  output$perAggregateKey <- renderDataTable({
    table <- keyToRows()
    names(table)[2] <- "rows"
    return(table)
  }, options = list(lengthChange = FALSE,
                    searching = FALSE), selection = "single", rownames = FALSE)
})

