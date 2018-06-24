Tantalus
=========

Introduction
============
This is an R package to help you expose differences between two CDMs.  Tantalus allows you to both "compare" two CDMs (that is, visually inspect data differences)
and "diff" two vocabularies (that is, generate a report of numeric summaries representing differences between them). 


Features
========
- Provides a Shiny app to allow you to visually inspect row level differences between CDMs.
- Easily customizable; you can add additional SQL queries, the results of which will be displayed by the Shiny app.
- Provides an optional report (also customizable) consisting of numeric summaries (differences) between two vocabularies within CDMs.
- Provides functionality to download the results as csv or excel file.

Examples
========
The first example shows how to compare the data within two CDMs and launch the Shiny app to visualize the results of the "comparison" queries. By defining findPrevalences = TRUE you can filter on those codes that appear in the database.
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

result = compareVocabData(connectionDetails = connectionDetails,
                             cdmDatabaseSchema = cdmDatabaseSchema,
                             oldVocabularyDatabaseSchema = oldVocabularyDatabaseSchema,
                             newVocabularyDatabaseSchema = newVocabularyDatabaseSchema,
                             findPrevalences = TRUE)

launchComparisonExplorer(result)
```

Queries used by compareVocabData() are located in inst/sql/sql_server.  Details of these queries can be found in the SQL files.
By default, only "Test" and "Map" queries are executed.  This can be modified by adjusting sqlFiles and sqlMapFiles in compareVocabData():

```r
sqlFiles    <- list.files(pathToSql, pattern = "Test.*.sql")
sqlMapFiles <- list.files(pathToSql, pattern = "MapSource.*.sql")
```

The next example shows how to create a summary (diffSummary.html) of the differences between two vocabularies. 
The SQL files for the summary can by adjusting sqlFiles in createDiffSummary():

```r
sqlFiles <- list.files(pathToSql, pattern = "Count.*.sql")
```

Using the same variables as above, we call createDiffSummary() which creates diffSummary.html via rmarkdown.  
A JSON file containing the results of the numeric summaries is also created.

```r
JSONPath <- "C:\\Temp"

createDiffSummary(connectionDetails,oldVocabularyDatabaseSchema,newVocabularyDatabaseSchema,JSONPath)
```

The above calls will create diffSummary.html in JSONPath, unless otherwise specified.


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

Once installed, you can try follow the examples above to invoke the Shiny app to inspect row level differences and create a summary diff report:

```r
library(Tantalus)
# set appropriate variables 
output <- compareVocabData( ... ) # Compare CDMs
launchComparisonExplorer(output)     # View the results of the comparison queries via Shiny
createDiffSummary( ... )             # Create a high level summary of the differences between the two vocabs
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
