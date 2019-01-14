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

	formattedCountConceptDomainChanges <- diffResults$CountConceptDomainChanges$CNT
	formattedCountConceptDomainChanges <- format(formattedCountConceptDomainChanges, big.mark = ",")

	output$domainChangeBox <- renderUI({
		infoBox(
			"Domain Changes", formattedCountConceptDomainChanges, icon = icon("receipt"),
			color = "yellow", width = 6
		)
	})

	output$countSummaryDiff <- renderDataTable(
		diffResults$CountSummaryDiff
	)

	output$countConceptDiffsByDandV <- renderDataTable(
		diffResults$CountConceptDiffsByDandV
	)

	output$countConceptDiffsByClass <- renderDataTable(
		diffResults$CountConceptDiffsByClass
	)

	output$countConceptDiffsByDomain <- renderDataTable(
		diffResults$CountConceptDiffsByDomain
	)

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
		lengthMenu = list( c(5,10, 25, 50, 75, 100, -1), c(5,10,25,50,75,100,"All")),
		searchHighlight = TRUE,
		dom = 'Blfrtip',
		buttons =
				list(I('colvis'), "copy", list(
					extend = "collection"
					, buttons = c("csv", "excel")
					, text = "Download"
		)),

		columnDefs = list(
			list(targets = c(0,2), visible = FALSE),
			list(
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

	output$testPlot <- renderPlot({
		plot(1:10)
	})

	output$testPlotly <- renderPlotly({
		plot_ly(
			type = "sankey",
			orientation = "h",

			node = list(
				label = c("Condition V1", "Drug V1", "Observation V1", "Measurement V1", "Condition V2", "Drug V2", "Observation V2", "Measurement V2"),
				color = c("blue", "blue", "blue", "blue", "red", "red", "red", "red"),
				pad = 15,
				thickness = 20,
				line = list(
					color = "black",
					width = 0.5
				)
			),

			link = list(
				source = c(0,0,0,0,1,1),
				target = c(5,5,5,5,4,4),
				value =  c(8,4,2,8,4,2)
			)
		) %>%
			layout(
				title = "Basic Sankey Diagram",
				font = list(
					size = 10
				)
			)
	})
})
