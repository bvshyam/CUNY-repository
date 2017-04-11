#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

# Question 1:
#   As a researcher, you frequently compare mortality rates from particular causes across
# different States. You need a visualization that will let you see (for 2010 only) the crude
# mortality rate, across all States, from one cause (for example, Neoplasms, which are
# effectively cancers). Create a visualization that allows you to rank States by crude mortality
# for each cause of death.

if(!require("leaflet", character.only = TRUE, quietly = TRUE)) {
  install.packages("leaflet")
  library("leaflet", character.only = TRUE)
}

if(!require("shiny", character.only = TRUE, quietly = TRUE)) {
  install.packages("shiny")
  library("shiny", character.only = TRUE)
}

if(!require("dplyr", character.only = TRUE, quietly = TRUE)) {
  install.packages("dplyr")
  library("dplyr", character.only = TRUE)
}

if(!require("DT", character.only = TRUE, quietly = TRUE)) {
  install.packages("DT")
  library("DT", character.only = TRUE)
}

if(!require("plotly", character.only = TRUE, quietly = TRUE)) {
  install.packages("plotly")
  library("plotly", character.only = TRUE)
}

if(!require("datasets", character.only = TRUE, quietly = TRUE)) {
  install.packages("datasets")
  library("datasets", character.only = TRUE)
}


mortality <- read.csv("https://raw.githubusercontent.com/charleyferrari/CUNY_DATA608/master/lecture3/data/cleaned-cdc-mortality-1999-2010-2.csv",header=TRUE,sep=",",na.strings = c("","NA"))

mortality$ICD.Chapter = as.character(mortality$ICD.Chapter)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  

  update_data <- reactive({
    
    state_ranking = filter(mortality,Year==input$year,ICD.Chapter==input$cause) %>% group_by(State) %>%  summarise(total = sum(Crude.Rate)) %>% 
      mutate(rank=dense_rank(desc(total))) %>% arrange(rank) %>% mutate(hover=paste("State:",State, '<br>',"Deaths:",total, '<br>',"Rank:",rank, "<br>"))
    

  })

  
  output$dotPlot <- renderPlot({
   
    leaflet(unique(mortality$State)) %>% addTiles(
      urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
      attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
      
    ) %>%  setView(lng = -93.85, lat = 37.45, zoom = 4)
    
  })
  
  output$dotPlot1 <- renderPlotly({
    
    
    # give state boundaries a white border
    l <- list(color = toRGB("white"), width = 2)
    # specify some map projection/options
    g <- list(
      scope = 'usa',
      projection = list(type = 'albers usa'),
      showlakes = TRUE,
      lakecolor = toRGB('white')
    )
    
    p <- plot_geo(update_data(), locationmode = 'USA-states') %>%
      add_trace(
        z = ~total, text = ~hover, locations = ~State,
        color = ~total, colors = 'Blues'
      ) %>%
      colorbar(title = "Death counts") %>%
      layout(
        title = 'Mortality in US and Rank',
        geo = g
      )
    
  })
  
  
  
    output$table <- DT::renderDataTable({

      update_data() %>% select(-hover) %>% DT::datatable()

  })
})
