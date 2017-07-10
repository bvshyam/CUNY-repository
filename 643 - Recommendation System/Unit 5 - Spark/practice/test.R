library(tidyverse)
library(data.table)

ratings <- read.csv("https://raw.githubusercontent.com/sureshgorakala/RecommenderSystems_R/master/movie_rating.csv",
                    stringsAsFactors = F,na.strings = NA)


movie_ratings = as.data.frame(acast(ratings, title~critic,value.var="rating"))

movie_ratings = ratings %>% spread(critic,rating)

sim_users = cor(movie_ratings[,1:6])

rating_critic = setDT(movie_ratings[colnames(movie_ratings)[6]],keep.rownames = TRUE)[]



#Content based

#Eclidean

x1 <- sample(30)
x2 <- sample(30)

dist(rbind(x1,x2),"euclidean")


dist(rbind(x1,x2),"manhattan")

#Cosine
install.packages("lsa")
library(lsa)
cosine(x1,x2)



#Jaccard
install.packages("clusteval")
library(clusteval)
cluster_similarity(x1,x2,similarity = "jaccard")

#Latent factors

library(recommenderlab)
data("MovieLense")
dim(MovieLense)
mat = as(MovieLense, "matrix")
mat[is.na(mat)]=0

res = nmf(mat,10)

install.packages("NMF")
library(NMF)


#SVD

sampleMat <- function(n) { i<- 1:n; 1/outer(i-1, i,"+") }
original.mat <- sampleMat(9)[,1:6]


(s <- svd(original.mat))

output <- s$u %*% diag(s$d) %*% t(s$v)

original.mat
output


U <- s$u %*% diag(s$d)

V <- diag(s$d) %*% t(s$v)

original.mat
U %*% V


Recommender(original.mat)

#Linear Regression
library(MASS)
data("Boston")



#SVM
install.packages('e1071')
library(e1071)

data("iris")
sample= iris[sample(nrow(iris)),]
train = sample[1:105,]
test =sample[106:150,]

tune = tune(svm, Species ~.,data=train,kernal="radial",scale = F, ranges = list(cost=c(.001,.01,0.1,1,5,100)))
tune$best.model

summary(tune)
model = svm(Species ~.,data=train,kernal="radial",scale = F, ranges = 1)
predict(model, test)



#Decision Tree
install.packages("tree")
library(tree)

model_tree <- tree(Species ~.,train)
summary(model_tree)


data(USArrests)

pca <- prcomp(USArrests,scale=T)
pca



#Term document matrix
install.packages("tm")
library(tm)

data(crude)
tdm <- TermDocumentMatrix(crude,control = list(weighting = function(x) weightTfIdf(x,normalize =TRUE), stopwords=TRUE))
inspect(tdm)

#Collabrative filter

data("Jester5k")

hist(getRatings(Jester5k))


which_train <- sample(x = c(TRUE,FALSE), size =nrow(Jester5k), replace=TRUE,prob=c(.8,.2))

data_train <- Jester5k[which_train,]
data_test <- Jester5k[!which_train,]


recommenderRegistry$get_entries(dataType="realRatingMatrix")


rec_model <- Recommender(data=data_train,method ="UBCF")
rec_model@model$data
rec_model@method

rec_prediction <- predict(object = rec_model, newdata=data_test, n =10)
rec_list <- sapply(rec_prediction@items, function(x){colnames(Jester5k)[x]})


number_ofitems <- sort(unlist(lapply(rec_list,length)),decreasing=TRUE)

table(number_ofitems)

table(rowCounts(Jester5k))


#1. Evaluate the ratings count
#2. Pick an optimal number and lessen the users who have rated more.
#3. Reduce the data who has given very low rating and high rating based on charts

image(Jester5k)
boxplot(rowMeans(Jester5k))

model_data <- Jester5k[rowMeans(Jester5k)< -5 & rowMeans(Jester5k) >7]



#Movie lens

movie_ratings <- read.csv("data/ratings.csv",header=TRUE,sep=",")


load("data/ratings.dat")

movie_ratings_readline <- readLines("data/ratings.dat")
movie_ratings_readline[1]
