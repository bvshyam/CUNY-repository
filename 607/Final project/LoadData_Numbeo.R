# Data 607 Final Project
# Fall 2016
# Load Data File

#--------------Packages--------------#

if(!require("RCurl", character.only = TRUE, quietly = TRUE)) {
  install.packages("RCurl")
  library("RCurl", character.only = TRUE)
}

if(!require("jsonlite", character.only = TRUE, quietly = TRUE)) {
  install.packages("jsonlite")
  library("jsonlite", character.only = TRUE)
}

# For web scraping
if(!require("rvest", character.only = TRUE, quietly = TRUE)) {
  install.packages("rvest")
  library("rvest", character.only = TRUE)
}

# For spark
if(!require("sparklyr", character.only = TRUE, quietly = TRUE)) {
  install.packages("sparklyr")
  library("sparklyr", character.only = TRUE)
}

# For dplyr
if(!require("dplyr", character.only = TRUE, quietly = TRUE)) {
  install.packages("dplyr")
  library("dplyr", character.only = TRUE)
}


#------------Spark SC install------------#

sc <- spark_connect(master = "local")



#--------------Get City Data--------------#

#Get city listings in the US from the Numbeo API

numbeo.url <- "https://www.numbeo.com/api/"
numbeo.key <- "api_key=vjd4t3rcp6nc50"

numbeo.query.term <- "cities?"
numbeo.query.search <- "&country=United%20States"

json_file <- getURL(paste0(numbeo.url, numbeo.query.term, numbeo.key, numbeo.query.search))

cities <- data.frame(fromJSON(json_file,simplifyDataFrame= TRUE))



colnames(cities) <- gsub("cities.", "", colnames(cities), perl = TRUE)

#--------------Get City Indexes--------------#

#Get city indexes from the Numbeo API

numbeo.query.term = "indices?"

for (city in 1:nrow(cities)) {
  
  tmp_list <- fromJSON(
    getURL(
      paste0(
        numbeo.url, numbeo.query.term, numbeo.key,
        numbeo.query.search,"&city_id=",
        cities$city_id[city])
    )
  )
  
  n <- names(tmp_list)
  for (i in 1:length(n)) {
    cities[city, n[i]] <- tmp_list[[i]]
  }
}

#Drop unused indexes
cities <- cities[,-c(1, 4, 11, 13, 14, 15, 18, 19, 20)]

#--------------Rank City Indexes--------------#

city_rank <- subset(cities, select = c(1:3, order(names(cities[,4:ncol(cities)]))+3))

# Remove isolated duplicated cities.
city_rank <- subset(city_rank, !duplicated(city_rank$city))

neg_val <- c(6, 9)

# Resolve NAs by coercing value to city with nearest lat & long
for (j in 4:ncol(city_rank)) {
  tmp <- subset(city_rank, !is.na(city_rank[j]), select = c(2, 3, j))
  for (k in 1:nrow(city_rank)) {
    min_dist <- Inf
    tmp_ind <- 0
    if (is.na(city_rank[k,j])) {
      for (l in 1:nrow(tmp)) {
        if (sqrt((city_rank[k,2] - tmp[l,1])^2 + (city_rank[k,3] - tmp[l,2])^2) < min_dist) {
          min_dist <- sqrt((city_rank[k,2] - tmp[l,1])^2 + (city_rank[k,3] - tmp[l,2])^2)
          tmp_ind <- tmp[l,3]
        }
      }
      city_rank[k,j] <- tmp_ind
    }
  }
}


for (i in 4:ncol(city_rank)) {
  city_rank[,colnames(city_rank[i])] <- dense_rank(
    ifelse(i %in% neg_val,-1, 1)*city_rank[,colnames(city_rank[i])]
  )
}



#--------------Append to SuperZip and store in Spark--------------#

# Read rds file and merge data, where applicable
zipCode_url <- "https://github.com/shyambv/cuny_607_final_project/blob/master/superzip.rds?raw=true"

zipCode_df <- readRDS(gzcon(url(zipCode_url)))

zipCode_df[,13:14] <- NULL

for (i in 1:nrow(zipCode_df)) {
  city_tmp <- paste0(zipCode_df[i, "city.x"], ", ", zipCode_df[i, "state.x"])
  if (city_tmp %in% city_rank$city) {
    for (j in 4:ncol(city_rank)) {
      zipCode_df[i, colnames(city_rank)[j]] <- city_rank[city_rank$city == city_tmp, j]
    }
  }
}

# Will only keep cities that we have index information for
zipCode_df <- subset(zipCode_df, !is.na(cpi_index))

zipCode_df$zipcode <- sprintf("%05d", zipCode_df$zipcode)
zipCode_df_sc <- copy_to(sc,zipCode_df)

#Save df as csv in working directory.
#write.table(zipCode_df, "cityData.csv", quote = FALSE, sep = ",", row.names = FALSE)

#****END****#