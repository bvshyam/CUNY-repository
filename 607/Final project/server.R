if(!require("leaflet", character.only = TRUE, quietly = TRUE)) {
  install.packages("leaflet")
  library("leaflet", character.only = TRUE)
}

if(!require("rvest", character.only = TRUE, quietly = TRUE)) {
  install.packages("rvest")
  library("rvest", character.only = TRUE)
}

if(!require("RColorBrewer", character.only = TRUE, quietly = TRUE)) {
  install.packages("RColorBrewer")
  library("RColorBrewer", character.only = TRUE)
}

if(!require("scales", character.only = TRUE, quietly = TRUE)) {
  install.packages("scales")
  library("scales", character.only = TRUE)
}

if(!require("lattice", character.only = TRUE, quietly = TRUE)) {
  install.packages("lattice")
  library("lattice", character.only = TRUE)
}

if(!require("dplyr", character.only = TRUE, quietly = TRUE)) {
  install.packages("dplyr")
  library("dplyr", character.only = TRUE)
}


if(!require("DT", character.only = TRUE, quietly = TRUE)) {
  install.packages("DT")
  library("DT", character.only = TRUE)
}

if(!require("sparklyr", character.only = TRUE, quietly = TRUE)) {
  install.packages("sparklyr")
  library("sparklyr", character.only = TRUE)
}



sc <- spark_connect(master = "local")

# Leaflet bindings are a bit slow; for now we'll just sample to compensate
set.seed(100)
#zipdata <- allzips[sample.int(nrow(allzips), 10000),]
# By ordering by centile, we ensure that the (comparatively rare) SuperZIPs
# will be drawn last and thus be easier to see
#zipdata <- zipdata[order(zipdata$centile),]

zipdata <- zipCode_df[order(zipCode_df$centile),]

cleantable <- zipdata %>%
  select(
    City = city.x,
    State = state.x,
    Zipcode = zipcode,
    QualityOfLife = quality_of_life_index,
    Traffic = traffic_index,
    Pollution = pollution_index,
    # Rank = rank,
    Score = centile,
    #Superzip = superzip,
    Population = adultpop,
    CollegeDeg = college,
    MedIncome = income,
    Lat = latitude,
    Long = longitude
    )

function(input, output, session) {

  ## Interactive Map ###########################################
  
  # Create the map
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(
        urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
        attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
        ) %>%
      setView(lng = -93.85, lat = 37.45, zoom = 4)
    })
  

  # A reactive expression that returns the set of zips that are
  # in bounds right now
  zipsInBounds <- reactive({
    if (is.null(input$map_bounds))
      return(zipdata[FALSE,])
    bounds <- input$map_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)
    
    subset(zipdata,
           latitude >= latRng[1] & latitude <= latRng[2] &
             longitude >= lngRng[1] & longitude <= lngRng[2])
  })
  
  # Precalculate the breaks we'll need for the two histograms
  centileBreaks <- hist(plot = FALSE, zipdata$quality_of_life_index, breaks = 20)$breaks
  
  output$histCentile <- renderPlot({
    # If no zipcodes are in view, don't plot
    if (nrow(zipsInBounds()) == 0)
      return(NULL)
    
    hist(zipsInBounds()$quality_of_life_index,
         breaks = centileBreaks,
         main = "Quality of Life",
         xlab = "Percentile",
         xlim = range(zipdata$quality_of_life_index),
         col = '#00DD00',
         border = 'white')
  })
  
  output$scatterCollegeIncome <- renderPlot({
    # If no zipcodes are in view, don't plot
    if (nrow(zipsInBounds()) == 0)
      return(NULL)
    
    print(xyplot(income ~ college, data = zipsInBounds(), xlim = range(zipdata$college), ylim = range(zipdata$income)))
  })
  
  # This observer is responsible for maintaining the circles and legend,
  # according to the variables the user has chosen to map to color and size.
  observe({
    # rankBy <- input$rankby
    sizeBy <- input$ranked_index
    
    radius <- zipdata[["adultpop"]]/2
    colorBy <- input$color_by
    
   
    if (colorBy == "traffic_index") {
      # Color and palette are treated specially in the "superzip" case, because
      # the values are categorical instead of continuous.
      colorData <- zipdata[["traffic_index"]]
      
      pal <- colorBin("Spectral",zipdata[["traffic_index"]],7,pretty = FALSE)
    } 
  
  else {
    colorData <- zipdata[[colorBy]]
    
    pal <- colorBin("Spectral",zipdata[[colorBy]],7,pretty = FALSE)
  }
    
# Size by population    
    if (sizeBy == "traffic_index") {

      radius <- zipdata[[sizeBy]] / max(zipdata[[sizeBy]]) * 30000

      print("Inside traffic_index")

      zipdata_new_rank <- collect(zipCode_df_sc %>% mutate(rank_new = dense_rank(desc(traffic_index))) %>% select(zipcode,city_x,state_x,rank_new))

       print(head(zipdata_new_rank))

    }

  else if (sizeBy == "pollution_index") {

    radius <- zipdata[[sizeBy]] / max(zipdata[[sizeBy]]) * 30000

   # print("Inside pollution_index")

    #zipdata_new_rank <- collect(zipCode_df_sc %>% mutate(rank_new = dense_rank(desc(pollution_index))) %>% select(zipcode,pollution_index,city_x,state_x,rank_new))

#    print(head(zipdata_new_rank))

  }

  else if (sizeBy == "health_care_index") {

    radius <- zipdata[[sizeBy]] / max(zipdata[[sizeBy]]) * 30000

  }

  else if (sizeBy == "college") {

    radius <- zipdata[[sizeBy]] / max(zipdata[[sizeBy]]) * 50000

  }

  else if (sizeBy == "income") {

    radius <- zipdata[[sizeBy]] / max(zipdata[[sizeBy]]) * 60000

  }

  else if (sizeBy == "adultpop") {

    radius <- zipdata[[sizeBy]] / max(zipdata[[sizeBy]]) * 70000

  }

  else {

   # zipdata_new_rank <- collect(zipCode_df_sc %>% mutate(rank_new = dense_rank(desc(traffic_index))) %>% select(zipcode,city_x,state_x,rank_new))

    radius <- zipdata[[sizeBy]] / max(zipdata[[sizeBy]]) * 30000

  }

    leafletProxy("map", data = zipdata) %>%
      clearShapes() %>%
      addCircles(~longitude, ~latitude, radius=radius, layerId=~zipcode,
                 stroke=FALSE, fillOpacity=0.4, fillColor=pal(colorData)) %>%
      addLegend("bottomleft", pal=pal, values=colorData, title=colorBy,
                layerId="colorLegend")
  })
  
  
  
  
  # Show a popup at the given location
  showZipcodePopup <- function(zipcode1, inputparam,lat, lng) {
    
    selectedZip_parent <- collect(zipCode_df_sc)
    
    if (input$ranked_index %in% colnames(selectedZip_parent[,14:ncol(selectedZip_parent)]) == FALSE) {
      
      if(input$ranked_index=="college"){
        selectedZip_parent <- collect(zipCode_df_sc %>% mutate(college_index = dense_rank(desc(college)))) %>%
          unique()
      }
      
      else if(input$ranked_index=="income"){
        selectedZip_parent <- collect(zipCode_df_sc %>% mutate(income_index = dense_rank(desc(income)))) %>%
          unique()
      }
      
      else if (input$ranked_index == "adultpop") {
        selectedZip_parent <- collect(zipCode_df_sc %>% mutate(population_index = dense_rank(desc(adultpop)))) %>% 
          unique()
      }
      
      else {
        selectedZip_parent <- collect(zipCode_df_sc %>% mutate(new_ = dense_rank(desc(input$ranked_index)))) %>% 
          unique()
      }
      }
    
    selectedZip <- selectedZip_parent[selectedZip_parent$zipcode == zipcode1,]
    
    print(inputparam)
    print(head(selectedZip))
    
    indeed_link <- sprintf("http://www.indeed.com/salary?q1=%s&l1=%s",
                            gsub("\\s+", "%20", input$job, perl = TRUE), selectedZip$zipcode)
    
    salary <- read_html(indeed_link) %>%
        html_node(xpath = '//*[(@id = "salary_display_table")]//*[contains(concat( " ", @class, " " ), concat( " ", "salary", " " ))]') %>%
        html_text(trim = TRUE)
    
    zillow_url = sprintf("https://www.zillow.com/homes/for_rent/%s/condo,apartment_duplex,townhouse_type/%d-_beds/0-%d_mp",
                         selectedZip$zipcode, input$bedrooms, round(as.numeric(gsub("\\D", "", salary, perl = TRUE))/40,0))
    
    rank_list <- selectedZip[,14:ncol(selectedZip)]
    main_col <- ifelse(ncol(rank_list) == 11, 11, which(colnames(rank_list) == input$ranked_index))
    main_val <- rank_list[,main_col]
    
    colnames(rank_list) <- gsub("_index", " Rank:", colnames(rank_list), perl = TRUE)
    colnames(rank_list) <- gsub("_", " ", colnames(rank_list), perl = TRUE)
    colnames(rank_list) <- gsub("(?<=\\b)([a-z])", "\\U\\1", tolower(colnames(rank_list)), perl=TRUE)
    
    main_name <- colnames(rank_list[,main_col])
    rank_list[,main_col] <- NULL
    
    content <- as.character(tagList(
      tags$h4(
        HTML(sprintf("%s, %s %s",
                     selectedZip$city_x, selectedZip$state_x, selectedZip$zipcode)
        )),
      
      tags$h4(main_name, as.integer(main_val)),
      tags$h4(sprintf("%s - Average Salary: %s", input$job, salary)),tags$br(),
      tags$a(href=zillow_url, "Click to View Affordable Rentals"),tags$br(),
      
      sprintf("%s %s", colnames(rank_list[1]), as.integer(rank_list[,1])), tags$br(),
      sprintf("%s %s", colnames(rank_list[2]), as.integer(rank_list[,2])), tags$br(),
      sprintf("%s %s", colnames(rank_list[3]), as.integer(rank_list[,3])), tags$br(),
      sprintf("%s %s", colnames(rank_list[4]), as.integer(rank_list[,4])), tags$br(),
      sprintf("%s %s", colnames(rank_list[5]), as.integer(rank_list[,5])), tags$br(),
      sprintf("%s %s", colnames(rank_list[6]), as.integer(rank_list[,6])), tags$br(),
      sprintf("%s %s", colnames(rank_list[7]), as.integer(rank_list[,7])), tags$br(),
      sprintf("%s %s", colnames(rank_list[8]), as.integer(rank_list[,8])), tags$br(),
      sprintf("%s %s", colnames(rank_list[9]), as.integer(rank_list[,9])), tags$br()
    ))
    
    leafletProxy("map") %>% addPopups(lng, lat, content, layerId = zipcode1)
    }
  
  
  observe({
    leafletProxy("map") %>% clearPopups()
    event <- input$map_shape_click
    if (is.null(event))
      return()
    
    isolate({
      showZipcodePopup(event$id, input$ranked_index, event$lat, event$lng)
    })
  })
  
  

  ## Data Explorer ###########################################
  
  observe({
    cities <- if (is.null(input$states)) character(0) else {
      #cleantable to zipdata change
      filter(cleantable, State %in% input$states) %>%
        `$`('City') %>%
        unique() %>%
        sort()
    }
    stillSelected <- isolate(input$cities[input$cities %in% cities])
    updateSelectInput(session, "cities", choices = cities,
                      selected = stillSelected)
  })
  
  observe({
    zipcodes <- if (is.null(input$states)) character(0) else {
      cleantable %>%
        filter(State %in% input$states,
               is.null(input$cities) | City %in% input$cities) %>%
        `$`('Zipcode') %>%
        unique() %>%
        sort()
    }
    stillSelected <- isolate(input$zipcodes[input$zipcodes %in% zipcodes])
    updateSelectInput(session, "zipcodes", choices = zipcodes,
                      selected = stillSelected)
  })
  
  observe({
    if (is.null(input$goto))
      return()
    isolate({
      map <- leafletProxy("map")
      map %>% clearPopups()
      dist <- 0.5
      zip <- input$goto$zip
      lat <- input$goto$lat
      lng <- input$goto$lng
      showZipcodePopup(zip, lat, lng)
      map %>% fitBounds(lng - dist, lat - dist, lng + dist, lat + dist)
    })
  })
  
  
  observe({
  output$ranking <- DT::renderDataTable({
    
    if(input$ranked_index=="traffic_index") {
        df_ranking <-   collect(zipCode_df_sc %>% mutate(rank = dense_rank(desc(traffic_index)))) %>%
          select(rank,city_x,state_x) %>%  
          unique()
        }
    
    else if(input$ranked_index=="pollution_index"){
      df_ranking <-   collect(zipCode_df_sc %>% mutate(rank = dense_rank(desc(pollution_index)))) %>%
        select(rank,city_x,state_x) %>%
        unique()
      }
    
    else if(input$ranked_index=="health_care_index"){
      df_ranking <-   collect(zipCode_df_sc %>% mutate(rank = dense_rank(desc(health_care_index)))) %>%
          select(rank,city_x,state_x) %>%
          unique()
        }
    else if(input$ranked_index=="college"){
      df_ranking <-   collect(zipCode_df_sc %>%   mutate(rank = dense_rank(desc(college)))) %>%
        select(rank,city_x,state_x) %>%
        unique()
      }
    
    else if(input$ranked_index=="income"){
      df_ranking <-   collect(zipCode_df_sc %>% mutate(rank = dense_rank(desc(income)))) %>%
        select(rank,city_x,state_x) %>%
        unique()
      }
    
    else if (input$ranked_index == "adultpop") {
    df_ranking <-   collect(zipCode_df_sc %>% mutate(rank = dense_rank(desc(adultpop)))) %>% 
      select(rank,city_x,state_x) %>%
      unique()
    }
    
    else {
      df_ranking <-   collect(zipCode_df_sc %>% mutate(rank = dense_rank(desc(input$ranked_index)))) %>% 
        select(rank,city_x,state_x) %>%
        unique()
    }
    
    DT::datatable(df_ranking)
  })
  
  })
  
  
  output$ziptable <- DT::renderDataTable({
    df <- cleantable %>%
      filter(
        Score >= input$minScore,
      Score <= input$maxScore,
        is.null(input$states) | State %in% input$states,
        is.null(input$cities) | City %in% input$cities,
        is.null(input$zipcodes) | Zipcode %in% input$zipcodes
      ) %>%
      mutate(Action = paste('<a class="go-map" href="" data-lat="', Lat, '" data-long="', Long, '" data-zip="', Zipcode, '"><i class="fa fa-crosshairs"></i></a>', sep=""))
    action <- DT::dataTableAjax(session, df)
    
    DT::datatable(df, options = list(ajax = list(url = action)), escape = FALSE)
  })
}