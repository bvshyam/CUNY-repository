---
title: "607 Project 3 : East West Crime Compare"
author: "Kumudini Bhave, Shyam BV, Mark Halpin, Upal Chowdhury"
date: "October 18, 2016"
output:
  html_document:
    fontsize: 17pt
    highlight: pygments
    theme: cerulean
    toc: yes
---


********

# **Crime DataSet Study : Crime Data Study , a comparison between East Coast city , New York City (NYC) and West Coast city San Francisco (SFO) and MidWest city Chicago (CHI)**

********

## Summary

This is an R Markdown document for providing documentation for performing **Data Exploration And Analysis Of the Crime  DataSet of publicly available crime data for New York City and San Francisco and Chicago**


********




## R Code :



### Loading Packages Used



```r
knitr::opts_chunk$set(message = FALSE, echo = FALSE)
# install.packages('grid') Library for string manipulation/regex operations
library(stringr)
# Library for data display in tabular format
library(DT)
# Library to read text file
library(RCurl)
# Library to gather (to long format) and spread (to wide format) data, to tidy data
library(tidyr)
# Library to filter, transform data
library(dplyr)
# Library to plot
library(ggplot2)
library(knitr)


# Library for db operations
library(RMySQL)


# Library for loading data
library(jsonlite)
library(XML)
library(xml2)


library(lubridate)
library(plotly)



library(bitops)

library(stringi)

library(ggmap)

library(grid)
```



Forming MYSQL DB Connection to Crime Schema
========================================================

Database MYSQL set up in cloud.
Connection and access to database can be obtained as follows through amazon web services.
@schema crimedb

The connection object 'conn' will further be used for querying and manipulating database tables.

