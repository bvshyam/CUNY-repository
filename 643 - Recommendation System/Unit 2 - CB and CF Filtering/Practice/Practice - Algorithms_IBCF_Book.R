similarity_users <- similarity(MovieLense[1:4, ], method ="cosine", which = "users")
similarity_users

class(similarity_users)
as.matrix(similarity_users)


similarity_items <- similarity(MovieLense[, 1:4], method =
                                 "cosine", which = "items")
as.matrix(similarity_items)

recommender_models <- recommenderRegistry$get_entries(dataType =
                                                        "realRatingMatrix")

names(recommender_models)

lapply(recommender_models, '[[',"description")

recommender_models$IBCF_realRatingMatrix$parameters


MovieLense@data


vector_ratings <- as.vector(MovieLense@data)
table(vector_ratings)

vector_ratings <- vector_ratings[vector_ratings != 0]


if(!"ggplot2" %in% rownames(installed.packages())){
  install.packages("ggplot2")}

library(ggplot2)

qplot(vector_ratings) + ggtitle("Distribution of the ratings")


views_per_movie <- colCounts(MovieLense)

table_views <- data.frame(
  movie = names(views_per_movie),
  views = views_per_movie
)

table_views <- table_views[order(table_views$views, decreasing =
                                   TRUE), ]


average_ratings <- colMeans(MovieLense)

qplot(average_ratings) + stat_bin(binwidth = 0.1) +
ggtitle("Distribution of the average movie rating")


average_ratings_relevant <- average_ratings[views_per_movie > 100]

qplot(average_ratings_relevant) + stat_bin(binwidth = 0.1) +
ggtitle(paste("Distribution of the relevant average ratings"))

image(MovieLense, main = "Heatmap of the rating matrix")



min_n_movies <- quantile(rowCounts(MovieLense), 0.99)
min_n_users <- quantile(colCounts(MovieLense), 0.99)
min_n_movies

dim(MovieLense)


ratings_movies <- MovieLense[rowCounts(MovieLense) > 50,
                             colCounts(MovieLense) > 100] 
ratings_movies

min_movies <- quantile(rowCounts(ratings_movies), 0.98)
min_users <- quantile(colCounts(ratings_movies), 0.98)

image(ratings_movies[rowCounts(ratings_movies) > min_movies,
                     colCounts(ratings_movies) > min_users], main = "Heatmap of the top
users and movies")


average_ratings_per_user <- rowMeans(ratings_movies)

ratings_movies_norm <- normalize(ratings_movies)
ratings_movies_norm@data

dim(ratings_movies_norm)
sum(rowMeans(ratings_movies_norm) < 0.00001)


#Binary

ratings_movies_watched <- binarize(ratings_movies, minRating = 1)
ratings_movies_watched@data


min_movies_binary <- quantile(rowCounts(ratings_movies), 0.95)
min_users_binary <- quantile(colCounts(ratings_movies), 0.95)


image(ratings_movies_watched[rowCounts(ratings_movies) > min_movies_binary,colCounts(ratings_movies) > min_users_binary], main = "Heatmap
of the top users and movies")



#Item based CF

which_train <- sample(x = c(TRUE, FALSE), size = nrow(ratings_movies),
                      replace = TRUE, prob = c(0.8, 0.2))
head(which_train)

recc_data_train <- ratings_movies[which_train, ]
recc_data_test <- ratings_movies[!which_train, ]



which_set <- sample(x = 1:5, size = nrow(ratings_movies), replace =TRUE)

for(i_model in 1:5) {
  which_train <- which_set == i_model
  recc_data_train <- ratings_movies[which_train, ]
  recc_data_test <- ratings_movies[!which_train, ]
  # build the recommender
}



recc_model <- Recommender(data = recc_data_train, method = "IBCF",parameter = list(k = 30))
recc_model

model_details <- getModel(recc_model)

model_details$description
model_details$k

dim(model_details$sim)





n_items_top <- 20

image(model_details$sim[1:n_items_top, 1:n_items_top],
      main = "Heatmap of the first rows and columns")


col_sums <- colSums(model_details$sim > 0)

which_max <- order(col_sums, decreasing = TRUE)[1:6]
rownames(model_details$sim)[which_max]


#Test dataset
n_recommended <- 6
recc_predicted <- predict(object = recc_model, newdata = recc_data_test, n = n_recommended)
recc_predicted


recc_user_1 <- recc_predicted@items[[1]]
movies_user_1 <- recc_predicted@itemLabels[recc_user_1]
movies_user_1


recc_matrix <- sapply(recc_predicted@items, function(x){
  colnames(ratings_movies)[x]
})
dim(recc_matrix)


recc_matrix[, 1:4]


#Items list
number_of_items <- factor(table(recc_matrix))
number_of_items_sorted <- sort(number_of_items, decreasing = TRUE)
number_of_items_top <- head(number_of_items_sorted, n = 4)
table_top <- data.frame(names(number_of_items_top),number_of_items_top)
table_top












