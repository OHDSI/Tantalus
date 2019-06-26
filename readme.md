Tantalus
=========

Introduction
============
This is an R package to help you expose differences between two vocabulary versions. 

Demo
====
A demo (under development) on the Synpuf data can be found here:

https://mi-erasmusmc.shinyapps.io/Tantalus/


Features
========
- Provides a Shiny app to allow you to visually inspect row level differences between vocabularies.
- Easily customizable; you can add additional SQL queries, the results of which will be displayed by the Shiny app.
- Provides detailed and summarized data.

Examples
========
To compare vocabularies using Tantalus, run the script extras/execution.R.
The script expects the following environment variables to be set: OLD_SCHEMA, NEW_SCHEMA, AWS_VOCAB_DATABASE_SERVER, AWS_VOCAB_USERNAME, DBMS, and PORT.

The example below shows how to compare two vocabulary versions and launch the Shiny app to visualize the results of the "comparison" queries. 
By defining findPrevalences = TRUE (in extras/execution.R) you can filter on those codes that appear in the CDM.  If the desire is to simply
compare vocabulary content (without reference to patient level data), then use the default findPrevalences = FALSE.

For this example the data reside in a Microsoft SQL Server dbms on a server called "db server", using default port 1433.  
The databases containing the vocabularies are called "db1" and "db2".  The database schema is "dbo".

```r
keyring::key_set(service = "db server",username = "some user")
Sys.setenv(OLD_SCHEMA="db1.dbo")
Sys.setenv(NEW_SCHEMA="db2.dbo")
Sys.setenv(DBMS="sql server")
Sys.setenv(AWS_VOCAB_DATABASE_SERVER="db server")
Sys.setenv(AWS_VOCAB_USERNAME="some user")
Sys.setenv(PORT=1433)
```

With the above variables set, you can run the script extras/execution.R.

Queries used by Tantalus are located in inst/sql/sql_server.  Details of these queries can be found in the SQL files.


Technology
============
The Tantalus package is an R package that makes use of Shiny and JSON for visualization.

System Requirements
===================
Running the package requires R with the packages SqlRender, DatabaseConnector, shiny, shinydashboard, DT, stringdist, keyring, plotly, and jsonlite, installed.


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

Once installed, you can try the following (see example above):

```r
library(Tantalus)
# set appropriate variables 
keyring::key_set(service = "db server",username = "some user")
Sys.setenv(OLD_SCHEMA="db1.dbo")
Sys.setenv(NEW_SCHEMA="db2.dbo")
Sys.setenv(DBMS="sql server")
Sys.setenv(AWS_VOCAB_DATABASE_SERVER="db server")
Sys.setenv(AWS_VOCAB_USERNAME="some user")
Sys.setenv(PORT=1433)

# Then run extras/execution.R

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

Beta. Still under development
