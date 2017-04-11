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



mortality <- read.csv("https://raw.githubusercontent.com/charleyferrari/CUNY_DATA608/master/lecture3/data/cleaned-cdc-mortality-1999-2010-2.csv",header=TRUE,sep=",",na.strings = c("","NA"),stringsAsFactors = FALSE)

mortality$ICD.Chapter = as.character(mortality$ICD.Chapter)

states <- data.frame(State = state.abb,state.area,state.division,state.name,state.region,stringsAsFactors = FALSE)

states$state.division= as.character(states$state.division)
states$state.region= as.character(states$state.region)

mortality_us = inner_join(mortality,states,by="State")


#states[states$state.name==input$inputstate,1]

#unique(mortality_us[mortality_us$State=="NC",10])

state_ranking_avg= mortality_us %>%  group_by(Year,ICD.Chapter) %>% summarise(total_avg = mean(Crude.Rate))

#state_ranking_state= mortality_us %>%  group_by(State,Year,ICD.Chapter) %>% summarise(total_avg = mean(Crude.Rate))


# Define server logic required to draw a histogram
shinyServer(function(input, output,session) {
  
#General state mortality
  update_data <- reactive({
    
    state_ranking = filter(mortality_us,(state.name==input$inputstate) #| state.region==input$inputregion
                           ,ICD.Chapter==input$cause) %>% group_by(Year,ICD.Chapter) %>%  summarise(total_year = round(sum(Crude.Rate),2)) %>% 
      mutate(rank=dense_rank(desc(total_year))) %>% arrange(rank) %>% inner_join(state_ranking_avg,by=c("Year","ICD.Chapter"))

  })
  
  #General region mortality
  update_region_data <- reactive({
    
    region_ranking = filter(mortality_us,state.region==unique(mortality_us[mortality_us$state.name==input$inputstate,10])
                           ,ICD.Chapter==input$cause) %>% group_by(Year,ICD.Chapter) %>%  summarise(total_year = round(sum(Crude.Rate),2)) %>% 
      mutate(rank=dense_rank(desc(total_year))) %>% arrange(rank)
    
  })
  
  
  output$dotPlot <- renderPlot({
    
    update_data() %>% ggplot(aes(Year)) + geom_line(aes(y=total_year,color = "State Deaths")) + geom_line(aes(y=total_avg,color = "National Average")) + ylab("Deaths") +
    ggtitle(input$inputstate ,"State") +
      theme(plot.title = element_text(lineheight = 40,face="bold"))
  })
  
  
  output$dotPlot1 <- renderPlot({
    
update_region_data() %>% ggplot(aes(Year)) + geom_line(aes(y=total_year,color = "Region Deaths")) + ylab("Deaths") + 
      ggtitle(unique(mortality_us[mortality_us$state.name==input$inputstate,10]) ,"Region") +
      theme(plot.title = element_text(lineheight = 40,face="bold"))
  
  })
  

    output$table <- DT::renderDataTable({
      update_data() %>% select(-rank) %>% DT::datatable(colnames = c('Year','Cause','Total Deaths','Average Deaths'))
  })


})
