#install.packages("sqldf")
library(shiny)
library(sqldf)


source("Amigo_main.R")



#uti<- read.csv(file = "uti.csv", na.strings =c("", "NA"))
#uti <- uti[,c(2,3,4,5)]
#call <- data.frame(uti)
#colnames(uti) <- c("userID","isbn","title","moviesrecommended")

#predictionsContentCat  <- uti
#predictionsContent <- uti # change to content one later


shinyServer(
function(input, output) {


 
  # get data here for dropdown ISBN
  # also add validation for errors
  # datasetInputState <- reactive({
  # 
  #   # removed preceeding zeros from ISBN
  # 
  #   print("inside reactive")
  #   recommendations <-  return_output("content_category",26,2)
  # 
  # })

  
  #recommendations <- return_output("content_category",26,2)
  
  output$viewisbn <- renderTable({

    if(input$submitButton == 0){
      return()
    }
    return_output(input$recommender,input$stateuser,input$obs)
    
    #return_output("content_category",26,2)
   # isolate(recommendations)
    })

  
})