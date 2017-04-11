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

if(!require("datasets", character.only = TRUE, quietly = TRUE)) {
  install.packages("datasets")
  library("datasets", character.only = TRUE)
}

mortality <- read.csv("https://raw.githubusercontent.com/charleyferrari/CUNY_DATA608/master/lecture3/data/cleaned-cdc-mortality-1999-2010-2.csv",header=TRUE,sep=",",na.strings = c("","NA"))

mortality$ICD.Chapter = as.character(mortality$ICD.Chapter)

states <- data.frame(State = state.abb,state.area,state.division,state.name,state.region,stringsAsFactors = FALSE)




# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Select the parameters to see mortality history"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(


       
       selectInput("cause",
                   "Cause for Mortality:",
                   choices = c(unique(mortality$ICD.Chapter)),selected = "Neoplasms"
                   ),
       
       selectInput("inputstate",
                   "Select states:",
                   choices = c(states$state.name),selected = "North Carolina"
       )

       
    ),
    
    # Show a plot of the generated distribution
    mainPanel(

      
      tabsetPanel(
        tabPanel("Plot", plotOutput("dotPlot"),plotOutput("dotPlot1")),
        tabPanel("Summary", dataTableOutput('table'))
        
      )
      
    )
  )
))
