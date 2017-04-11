#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#


if(!require("leaflet", character.only = TRUE, quietly = TRUE)) {
  install.packages("leaflet")
  library("leaflet", character.only = TRUE)
}

if(!require("shiny", character.only = TRUE, quietly = TRUE)) {
  install.packages("shiny")
  library("shiny", character.only = TRUE)
}

mortality <- read.csv("https://raw.githubusercontent.com/charleyferrari/CUNY_DATA608/master/lecture3/data/cleaned-cdc-mortality-1999-2010-2.csv",header=TRUE,sep=",",na.strings = c("","NA"))

mortality$ICD.Chapter = as.character(mortality$ICD.Chapter)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Select the parameters to rank states"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(

       sliderInput("year",
                   "Select the Year:",
                   min = 2000,
                   max = 2010,
                   value = 2010,sep = ""),
       
       selectInput("cause",
                   "Cause for Mortality:",
                   choices = c(unique(mortality$ICD.Chapter)),selected = "Neoplasms"
                   
                   )
       
    ),
    
    # Show a plot of the generated distribution
    mainPanel(

      tabsetPanel(
        tabPanel("Plot", plotlyOutput("dotPlot1")),
        tabPanel("Summary", dataTableOutput('table'))
      )
      
      
    )
  )
))
