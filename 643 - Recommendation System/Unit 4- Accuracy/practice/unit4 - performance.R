library(recommenderlab)
library(ggplot2)
library(dplyr)

data(MovieLense)
ratings_movies <- MovieLense[rowCounts(MovieLense) > 50,colCounts(MovieLense) > 100]
ratings_movies

min(rowCounts(ratings_movies))


test <- as(MovieLense, "matrix")

#Regular testing
percentage_training <- 0.8

items_to_keep <- 15

rating_threshold <- 3

n_eval <- 1

eval_sets <- evaluationScheme(data = ratings_movies, method = "split",
                              train = percentage_training, given = items_to_keep, goodRating =
                                rating_threshold, k = n_eval) 
eval_sets

qplot(rowCounts(getData(eval_sets, "unknown"))) + 
  geom_histogram(binwidth = 10) + ggtitle("unknown items by the users")

##Bootstrapping

percentage_training <- 0.8
items_to_keep <- 15
rating_threshold <- 3
n_eval <- 1
eval_sets <- evaluationScheme(data = ratings_movies, method =
                                "bootstrap", train = percentage_training, given = items_to_keep,
                              goodRating = rating_threshold, k = n_eval)

eval_sets

nrow(getData(eval_sets, "train")) / nrow(ratings_movies)

#Total split
perc_test <- nrow(getData(eval_sets, "known")) / nrow(ratings_movies)
perc_test


perc_train <- length(unique(eval_sets@runsTrain[[1]])) / nrow(ratings_movies)

perc_train + perc_test


#Validate
table_train <- table(eval_sets@runsTrain[[1]])
n_repetitions <- factor(as.vector(table_train))
qplot(n_repetitions) + ggtitle("Number of repetitions in the training
set")


#K-fold validation
n_fold <- 4
eval_sets <- evaluationScheme(data = ratings_movies, method = "cross-validation",
                              k = n_fold, given = items_to_keep, goodRating = rating_threshold)


size_sets <- sapply(eval_sets@runsTrain, length)
size_sets




#Realvalidation starts
n_fold <- 4
items_to_keep <- 15
rating_threshold <- 3
eval_sets <- evaluationScheme(data = ratings_movies, method = "cross-validation",
                              k = n_fold, given = items_to_keep, goodRating = rating_threshold)



model_to_evaluate <- "IBCF"
model_parameters <- NULL


eval_recommender <- Recommender(data = getData(eval_sets, "train"),
                                method = model_to_evaluate, parameter = model_parameters)


items_to_recommend <- 10


eval_prediction <- predict(object = eval_recommender, newdata =getData(eval_sets, "known"), 
                           n = items_to_recommend, type = "ratings")
class(eval_prediction)



qplot(rowCounts(eval_prediction)) + geom_histogram(binwidth = 10) +
  ggtitle("Distribution of movies per user")


eval_accuracy <- calcPredictionAccuracy(
  x = eval_prediction, data = getData(eval_sets, "unknown"), byUser =
    TRUE)
head(eval_accuracy)
  
qplot(eval_accuracy[, "RMSE"]) + geom_histogram(binwidth = 0.1) +
  ggtitle("Distribution of the RMSE by user")
  
  
  
#Overall accuracy

eval_accuracy <- calcPredictionAccuracy(
  x = eval_prediction, data = getData(eval_sets, "unknown"), byUser =FALSE)



eval_accuracy



  

#Summarized confusion matrix from 4 k-fold validation on only 1

results <- evaluate(x = eval_sets, method = model_to_evaluate, n =seq(10, 100, 10))
class(results)


head(getConfusionMatrix(results)[[1]])

#Summarized confusion matrix from 4 k-fold validation

columns_to_sum <- c("TP", "FP", "FN", "TN")
indices_summed <- Reduce("+", getConfusionMatrix(results))[, columns_to_sum]
head(indices_summed)

plot(results, annotate = TRUE, main = "ROC curve")


plot(results, "prec/rec", annotate = TRUE, main = "Precision-recall")


#Comparing models

models_to_evaluate <- list(
  IBCF_cos = list(name = "IBCF", param = list(method =
                                                "cosine")),
  IBCF_cor = list(name = "IBCF", param = list(method =
                                                "pearson")),
  UBCF_cos = list(name = "UBCF", param = list(method =
                                                "cosine")),
  UBCF_cor = list(name = "UBCF", param = list(method =
                                                "pearson")),
  SVD = list(name = "SVD",param=NULL),
  SVDF = list(name = "SVDF",param=NULL),
  random = list(name = "RANDOM", param=NULL)
)


n_recommendations <- c(1, 5, seq(10, 100, 10))


list_results <- evaluate(x = eval_sets, method = models_to_evaluate, n = n_recommendations)
class(list_results)


#sapply(list_results, class) == "evaluationResults"


avg_matrices <- lapply(list_results, avg)


#head(avg_matrices$IBCF_cos[, 5:8])


#Identify the suitable model

plot(list_results, annotate = 1, legend = "topleft")
title("ROC curve")


plot(list_results, "prec/rec", annotate = 1, legend = "bottomright")
title("Precision-recall")

# Optimizing a numeric parameter

vector_k <- c(5, 10, 20, 30, 40)

models_to_evaluate <- lapply(vector_k, function(k){
  list(name = "IBCF", param = list(method = "cosine", k = k))
})

names(models_to_evaluate) <- paste0("IBCF_k_", vector_k)


n_recommendations <- c(1, 5, seq(10, 100, 10))
list_results <- evaluate(x = eval_sets, method = models_to_evaluate, n
                         = n_recommendations)


plot(list_results, annotate = 1, legend = "topleft") 
title("ROC curve")



plot(list_results, "prec/rec", annotate = 1, legend = "bottomright")
title("Precision-recall")





