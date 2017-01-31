if(!require("leaflet", character.only = TRUE, quietly = TRUE)) {
  install.packages("leaflet")
  library("leaflet", character.only = TRUE)
}


# Choices for drop-downs
vars <- c(
  "Traffic" = "traffic_index",
 # "School" ="school",
  "Pollution" = "pollution_index",
  "Health care"="health_care_index",
#  "Plesant Climate"="climate",
  
# "Is SuperZIP?" = "superzip",
#  "Centile score" = "centile",
  "College education" = "college",
  "Median income" = "income",
  "Population" = "adultpop"
)

navbarPage("Search your State", id="nav",
           
           tabPanel("Interactive map",
                    div(class="outer",
                        
                        tags$head(
                          includeCSS("scripts\styles.css"),
                          includeScript("scripts\gomap.js")
                          ),
                        leafletOutput("map", width="100%", height="100%"),
                        
                        # Shiny versions prior to 0.11 should use class="modal" instead.
                        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                      draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                                      width = 400, height = "auto",
                                      
                                      h2("Select Parameters"),
                                      
                                      textInput("job", label= "Fill your desired job",value="Developer"),
                                      
                                      numericInput("bedrooms", label= "# of Bedrooms",value=2),
                                      
                                      #numericInput("otherincome", label= "Other income in family",value="Eg. 1000,50000",min=0,max=1000000),
                                      
                                      selectInput("ranked_index", "Rank By Index", vars, selected = "traffic_index"),
                                      
                                      selectInput("color_by", "Color by Index", vars),
                                      
                                      DT::dataTableOutput("ranking")
                                      
                                      #plotOutput("histCentile", height = 200),
                                      #  plotOutput("scatterCollegeIncome", height = 250)
                                      ),
                        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                      draggable = TRUE, top = 60, left = "20", right = "auto",
                                      bottom = "auto", width = 330, height = "auto",
                                      plotOutput("histCentile", height = 200),
                                      plotOutput("scatterCollegeIncome", height = 250)
                                      ),
                        tags$div(id="cite",
                                 'Data compiled for ',
                                 tags$em('Coming Apart: The State of White America, 1960–2010'), ' by Charles Murray (Crown Forum, 2012).'
                                 )
                        )
                    ),
           
           tabPanel("Data explorer",
                    fluidRow(
                      column(
                        3,
                        selectInput(
                          "states",
                          "States",
                          c("All states"="", structure(state.abb, names=state.name)), multiple=TRUE)
                        ),
                      column(
                        3,
                        conditionalPanel(
                          "input.states",
                          selectInput("cities", "Cities", c("All cities"=""), multiple=TRUE)
                          )
                        ),
                      column(
                        3,
                        conditionalPanel(
                          "input.states",
                          selectInput("zipcodes", "Zipcodes", c("All zipcodes"=""), multiple=TRUE)
                          )
                        )
                      ),
                    fluidRow(
                      column(
                        1,
                        numericInput("minScore", "Min score", min=0, max=100, value=0)
                        ),
                      column(
                        1,
                        numericInput("maxScore", "Max score", min=0, max=100, value=100)
                        )
                      ),
                    hr(),
                    DT::dataTableOutput("ziptable")
                    )
           #  conditionalPanel("false", icon("crosshair"))
           )