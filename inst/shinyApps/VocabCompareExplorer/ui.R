library(shiny)
library(DT)
library(htmlwidgets)
library(shinydashboard)
library(markdown)

ui <- dashboardPage(
	dashboardHeader(title = "Tantalus",  titleWidth = 120),
	dashboardSidebar(
		width = 120,
		sidebarMenu(
			menuItem("Home", tabName = "home", icon = icon("home")),
			menuItem("Tabular", tabName = "tabular", icon = icon("table")),
			menuItem(
				"Graphical",
				tabName = "graphical",
				icon = icon("bar-chart-o")
			),
			menuItem("Feedback", icon = icon("comment"), href = "https://github.com/mi-erasmusmc/Tantalus/issues")
		),
		tags$footer(
			align = "right",
			style = "
			position:absolute;
			bottom:0;
			width:100%;
			height:175px;
			color: black;
			padding: 10px;
			text-align:center;
			background-color: #eee;
			z-index: 1000;",
			HTML(
				"<a href=\"https://www.apache.org/licenses/LICENSE-2.0\">Apache 2.0</a>
				<div style=\"margin-bottom:10px;\">open source software</div>
				<div>provided by</div>
				<div><a href=\"http://www.ohdsi.org\"><img src=\"images/ohdsi_color.png\" height=42 width = 100></a></div>
				<div><a href=\"http://www.ohdsi.org\">join the journey</a> </div>
				<div>"
			)
			)
		),

	dashboardBody(
		tabItems(
			tabItem(tabName = "home",
							includeMarkdown(file.path("man", "readme.md"))),

			tabItem(tabName = "tabular",
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
									#,
									#verbatimTextOutput('label')
								),
								column(
									width = 10,
									offset = 0,
									DTOutput("allResultsTable")
								)
							)),

		tabItem(tabName = "graphical", h3("Coming soon!"))

	))
)
