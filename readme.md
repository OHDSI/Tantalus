Tantalus
=========

Introduction
============
This is an R package to help you expose differences between two CDMs.  Tantalus allows you to both "compare" two CDMs (that is, visually inspect data differences)
and "diff" two vocabularies (that is, generate a report of numeric summaries representing differences between them). 


Features
========
- Provides a Shiny app to allow you to visually inspect data differences between CDMs.
- Easily customizable; you can add additional SQL queries, the results of which will be displayed by the Shiny app.
- Provides an optional report (also customizable) consisting of numeric summaries (differences) between two vocabularies within CDMs.

Examples
========
The first example shows how to compare the data within two CDMs and launch the Shiny app to visualize the results of the "comparison" queries.
For this example the data reside in a Microsoft PDW dbms on a server called X, using default port 17001.  
The databases containing the CDMs are called "db1" and "db2".  The database schema is "dbo".


```r
library(Tantalus)
cdmDatabaseSchema <- "db1.dbo"
oldVocabularyDatabaseSchema <- cdmDatabaseSchema
newVocabularyDatabaseSchema <- "db2.dbo"

connectionDetails <- createConnectionDetails(dbms = "pdw",
                                             server = "X",
                                             user = "some user",
                                             password = "some pw",
                                             port = 17001)

result = compareVocabularies(connectionDetails = connectionDetails,
                             cdmDatabaseSchema = cdmDatabaseSchema,
                             oldVocabularyDatabaseSchema = oldVocabularyDatabaseSchema,
                             newVocabularyDatabaseSchema = newVocabularyDatabaseSchema)

launchComparisonExplorer(result)
```

Queries used by compareVocabularies() are located in inst/sql/sql_server.  Details of these queries can be found in the SQL files.
By default, only "Test" and "Map" queries are executed.  This can be modified in the following lines in compareVocabularies():

```r
pathToSql <- system.file("sql/sql_server", package = "Tantalus")
sqlFiles <- list.files(pathToSql, pattern = "Test.*.sql")
sqlMapFiles <- list.files(pathToSql, pattern = "MapSource.*.sql")
```

The next example shows how to create a report (GenerateDiffReport.html) of differences between two vocabularies. 
The SQL files for for a diff can be controlled via these lines in diffVocabularies():

```r
pathToSql <- system.file("sql/sql_server/vocabDiff", package = "Tantalus")
sqlFiles <- list.files(pathToSql, pattern = "*.sql")
```

Using the same variables as above, we call diffVocabularies() to create a markdown (reports/GenerateDiffReport.Rmd) which is then passed to rmarkdown::render() 
to create the html file.  While the SQL files for compareVocabularies() are located in inst/sql/sql_server, the SQL files for diffVocabularies()
are located in inst/sql/sql_server/vocabDiff.  

```r
JSONPath <- "C:\\Temp"

results <- diffVocabularies(connectionDetails,oldVocabularyDatabaseSchema,newVocabularyDatabaseSchema,JSONPath)

# Generate diff report and provide the JSON file created from diffVocabularies()
rmarkdown::render(input="reports\\GenerateDiffReport.Rmd",output_dir = JSONPath,params=list(JSONFile=results$JSONFile))
```

The above calls will create GenerateDiffReport.html in output_dir.


Technology
============
The Tantalus package is an R package that makes use of Shiny, R Markdown, and JSON for visualization.

System Requirements
===================
Running the package requires R with the packages SqlRender, DatabaseConnector, shiny, DT, stringdist, and jsonlite, installed.


Dependencies
============
 * There are no dependencies.

Getting Started
===============
## R package
  
To install the latest development version, install from GitHub:

```r
install.packages("devtools")
devtools::install_github("ohdsi/Tantalus")
```

Once installed, you can try follow the examples above to invoke the Shiny app and create a diff report:

```r
library(Tantalus)
# set appropriate variables 
output <- compareVocabularies( ... ) # Compare CDMs
launchComparisonExplorer(output)     # View the results of the comparison queries via Shiny
results <- diffVocabularies( ... )   # Create a diff report
rmarkdown::render( ... )             # Render the markdown into an html file for easy browsing
```

Getting Involved
=============
* Package manual: [Tantalus manual](https://raw.githubusercontent.com/OHDSI/Tantalus/master/extras/Tantalus.pdf) 
* Developer questions/comments/feedback: <a href="http://forums.ohdsi.org/c/developers">OHDSI Forum</a>
* We use the <a href="../../issues">GitHub issue tracker</a> for all bugs/issues/enhancements

License
=======
Tantalus is licensed under Apache License 2.0

Development
===========
Tantalus is being developed in R Studio.

### Development status

Stable. The code is actively being used in several projects.
