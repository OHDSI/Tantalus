library(shiny)
library(DT)
library(htmlwidgets)
library(shinydashboard)

shinyServer(function(input, output, session) {
	filteredData <- reactive({
		if (input$filterZeroPrevalence) {
			return(results[results$Prevalence != "0",])
		} else {
			return(results)
		}
	})

	keyToRows <- reactive({
		formula <- as.formula(paste("ID ~", input$aggregateKey))
		aggregate(formula, data = filteredData(), length)
	})

	output$allResultsTable <- renderDT({
		table <- filteredData()
		selected <- input$perAggregateKey_rows_selected
		if (!is.null(selected)) {
			keys <- keyToRows()[, 1]
			table <- table[table[, input$aggregateKey] == keys[selected], ]
		}
		return(table)
	},
	server = TRUE,
	caption = paste0(
		"Table 1: Comparison of ",
		oldVersion,
		" (Old) versus ",
		newVersion,
		" (New)"
	),
	filter = list(position = 'top'),
	extensions = 'Buttons',
	rowname = FALSE,
	selection = 'single',
	options = list(
		autoWidth = FALSE,
		lengthMenu = c(10, 25, 50, 75, 100),
		searchHighlight = TRUE,
		dom = 'Blfrtip',
		buttons = I('colvis'),

		columnDefs = list(list(
			targets = 3,
			render = JS(
				"function(data, type, row, meta) {",
				"return type === 'display' && data.length > 0 ?",
				"'<a target = \"_blank\" href=\"http://athena.ohdsi.org/search-terms/terms/' + data + '\" >' + data + ' </a>' : data;",
				"}"
			)
		))
	))

	output$perAggregateKey <- renderDataTable({
		table <- keyToRows()
		color <- "green"
		names(table)[2] <- "rows"
		return(table)
	}, options = list(lengthChange = FALSE,
										searching = FALSE), selection = "single", rownames = FALSE)

	output$label = renderPrint({
		s = input$perAggregateKey_row_last_clicked
		if (length(s)) {
			cat('These rows were selected:\n\n')
			print(s)
			print(keyToRows()[s, 1])
		}
	})
})
