library(shiny)
library(DT)
library(htmlwidgets)
library(shinydashboard)
library(markdown)

ui <- dashboardPage(
	dashboardHeader(title = "Tantalus",  titleWidth = 200),
	dashboardSidebar(
		width = 200,
		sidebarMenu(
			menuItem("Home", tabName = "home", icon = icon("home")),
			menuItem("Summary", tabName = "summary", icon = icon("receipt")),
			menuItem("Details", tabName = "details", icon = icon("table")),
			#menuItem("Graphical",tabName = "graphical",icon = icon("bar-chart-o")),
			menuItem("Feedback", icon = icon("comment"), href = "https://github.com/OHDSI/Tantalus/issues")
		)
	),

	dashboardBody(
		tabItems(
			tabItem(tabName = "home",
							includeMarkdown(file.path("man", "readme.md"))),

			tabItem(tabName = "details",
							fluidRow(
								column(
									width = 2,
									selectInput(
										"aggregateKey",
										label = "Aggregation key",
										choices = c("Domain", "Vocabulary", "Description")
									),
									checkboxInput("filterZeroPrevalence", "Remove issues with zero prevalence"),
									dataTableOutput("perAggregateKey", width = 150)
								),
								column(
									width = 10,
									offset = 0,
									DTOutput("allResultsTable")
								)
							)),
			tabItem(tabName = "summary",
							fluidRow(
								column(
									width = 12,
									uiOutput("domainChangeBox")
								)
							),
							fluidRow(
								column(
									width = 12,
									titlePanel("General Summary"),
									wellPanel("This is the description of the general summary table."),
									dataTableOutput("countSummaryDiff"),
									titlePanel("Domain & Vocabulary Changes"),
									dataTableOutput("countConceptDiffsByDandV"),
									titlePanel("Concept Class Changes"),
									dataTableOutput("countConceptDiffsByClass"),
									titlePanel("Domain Changes"),
									wellPanel("The change in the number of rows per domain between the old and new vocabulary version."),
									dataTableOutput("countConceptDiffsByDomain")
								)
							))
		#tabItem(tabName = "graphical", plotOutput("testPlot"))
	))
)
