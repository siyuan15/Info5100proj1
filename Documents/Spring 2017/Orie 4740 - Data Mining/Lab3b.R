setwd("/Users/siyuan/Documents/Spring 2017/Orie 4740 - Data Mining")
pros <- read.csv('pros.csv', header = T, na.strings='')
#remove covariates not needed.
#titanic <- titanic[, !colnames(titanic) %in% c('PassengerId', 'Name', 'Ticket', 'Cabin')]

#remove instances missing age information
pros <- pros[complete.cases(pros), ]
pros <- subset(pros, VOL != 0)
#Or, alternatively, replace missing data with the mean/median:
#titanic$Age[is.na(titanic$Age)] = median(titanic$Age)

train_ind <- sample(1:nrow(pros), 2/3*nrow(pros))
pros_train <- pros[train_ind, ]
pros_test <- pros[-train_ind, ]

#check if the factor variables are actually factors
sapply(pros, class)

pros_logit <- glm(CAPSULE~., data = pros_train, family = binomial)
pros_pred <- predict(pros_logit, pros_test, type = "response")

# summary of fitted model
summary(pros_logit)

out <- capture.output(summary(pros_logit))

cat("My title", out, file="pros_logit.pdf", sep="n", append=TRUE)

##############
library(class)

pros <- read.csv('pros.csv', header = T, na.strings='')

#remove instances missing age information
pros <- pros[complete.cases(pros), ]
pros <- subset(pros, VOL != 0)
#Or, alternatively, replace missing data with the mean/median:
#titanic$Age[is.na(titanic$Age)] = median(titanic$Age)

#check for factor variable and convert them into numeric

#Generate training data set and test data set 
set.seed(1)
train_ind <- sample(1:nrow(pros), 2/3*nrow(pros))

#Normalization
pros_normal <- scale(pros[,!names(pros) %in% 'CAPSULE'])
pros.train <- pros_normal[train_ind, ]
pros.test <- pros_normal[-train_ind, ]

#Store the outcome colomn seperately 
train.capsule=pros$CAPSULE[train_ind]
test.capsule=pros$CAPSULE[-train_ind]

#Implement the KNN algorithm
knn.pred=knn(pros.train,pros.test,train.capsule,k=1)
table(knn.pred,test.capsule)
mean(knn.pred==test.capsule)

#Performance of different value of K
error <- rep(0,20)
K <- c(1:20)
for (i in (1:20)){
  set.seed(1);
  knn.pred=knn(pros.train,pros.test,train.capsule,k=i);
  error[i] <- 1-mean(knn.pred==test.capsule)
}
plot(K,error,main="With Normalization", xlab="K",ylab="error rate", type="b")
as.data.frame(error)

# Without normalization
train.X <- pros[train_ind,!names(pros) %in% 'CAPSULE']
test.X <- pros[-train_ind,!names(pros) %in% 'CAPSULE']
error.without <- rep(0,20)
K.without <- c(1:20)
for (j in (1:20)){
  set.seed(1);
  knn.pred.without=knn(train.X,test.X,train.capsule,k=j);
  error.without[j] <- 1-mean(knn.pred.without==test.capsule)
}
plot(K.without,error.without,main="Without Normalization", xlab="K",ylab="error rate",type="b")
as.data.frame(error)

