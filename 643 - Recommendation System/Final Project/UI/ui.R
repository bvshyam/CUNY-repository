library(shiny)
#options(shiny.error = browser) # to view errors

# Replace all these files once we have the prediction datasets
# load the necessary data (user item title books)
preddataColla <- read.csv(file = "uti.csv", na.strings =c("", "NA"),sep=",")
call <- data.frame(preddataColla)
preddataColla <- preddataColla[,c(2,3,4,5)]
colnames(preddataColla) <- c("userID","isbn","title","moviesrecommended")

users <- unique(books_recommend$User.ID)
titles <- unique(preddataColla$title)
# isbns <- unique(preddataColla$isbn)
# moviesR <- unique(preddataColla$moviesrecommended)

category_vars <- c(
  "Content Category Filter" = "content_category",
  "Collabrative Filter" ="collabrative",
  "Content Decade Filter" = "content_decade"
)


# Define UI for dataset viewer application
fluidPage(
  tags$style(HTML("
                  @import url('//fonts.googleapis.com/css?family=Lobster|Cabin:400,700');
                  
                  h1 {
                  font-family: 'Lobster', cursive;
                  font-weight: 500;
                  line-height: 1.1;
                  color: #48ca3b;
                  }
                  
                  ")),
  # Application title
  headerPanel("Amigo De Libro"),
  
  # Sidebar with controls to provide a caption, select a dataset,
  # and specify the number of observations to view. Note that
  # changes made to the caption in the textInput control are
  # updated in the output area immediately as you type
  sidebarLayout(
    sidebarPanel(
      selectInput("recommender", "Recommender:", 
                  choices = category_vars,selected = "content_category"),
      

      # Selectize lets you create a default option for Title
      selectInput(
        'stateuser', 'Choose a User:', choices = users
        # ,options = list(
        #   placeholder = 'Please select an option below',
        #   onInitialize = I('function() { this.setValue(""); }')
        
      ),

      # how many rows to view
      numericInput("obs", "Number of books to view:", 2)
      
      ,actionButton("submitButton","Submit")
    ),
    
    
    # Show the caption, a summary of the dataset and an HTML 
    # table with the requested number of observations
    mainPanel(
      h3(textOutput("Please wait for a few seconds for the tables to load <br><br>")),
      
      # dummy
      # view the recommender by ISBN
      tableOutput("viewisbn")
      
    )
  )
  )