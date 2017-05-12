# Part (a)
titanic <- read.csv('titanic.csv', header = T, na.strings='')
#remove covariates not needed.
titanic <- titanic[, !colnames(titanic) %in% c('PassengerId', 'Name', 'Ticket', 'Cabin')]

#remove instances missing age information
titanic <- titanic[complete.cases(titanic), ]
#Or, alternatively, replace missing data with the mean/median:
#titanic$Age[is.na(titanic$Age)] = median(titanic$Age)

train_ind <- sample(1:nrow(titanic), 2/3*nrow(titanic))
titanic_train <- titanic[train_ind, ]
titanic_test <- titanic[-train_ind, ]

#check if the factor variables are actually factors
sapply(titanic, class)

titanic_logit <- glm(Survived~., data = titanic_train, family = binomial)
titanic_pred <- predict(titanic_logit, titanic_test, type = "response")

# summary of fitted model
summary(titanic_logit)

#Get binary prediction with threshold 0.5
titanic_bin <- as.numeric(titanic_pred >= 0.5)

#Get the accuracy of our model
table(titanic_bin, titanic_test$Survived)

########################################################
# Part (b)
# K-Nearest Neighbors

library(class)

titanic <- read.csv('titanic.csv', header = T, na.strings='')
#remove covariates not needed.
titanic <- titanic[, !colnames(titanic) %in% c('PassengerId', 'Name', 'Ticket', 'Cabin')]

#remove instances missing age information
titanic <- titanic[complete.cases(titanic), ]
#Or, alternatively, replace missing data with the mean/median:
#titanic$Age[is.na(titanic$Age)] = median(titanic$Age)

#check for factor variable and convert them into numeric
sapply(titanic,class)
titanic$Sex <- model.matrix( ~ Sex - 1, data=titanic )
titanic$Embarked <- model.matrix( ~ Embarked - 1, data=titanic )

#Generate training data set and test data set 
set.seed(1)
train_ind <- sample(1:nrow(titanic), 2/3*nrow(titanic))

#Normalization
titanic_normal <- scale(titanic[,!names(titanic) %in% 'Survived'])
titanic.train <- titanic_normal[train_ind, ]
titanic.test <- titanic_normal[-train_ind, ]

#Store the outcome colomn seperately 
train.survive=titanic$Survived[train_ind]
test.survive=titanic$Survived[-train_ind]

#Implement the KNN algorithm
knn.pred=knn(titanic.train,titanic.test,train.survive,k=1)
table(knn.pred,test.survive)
mean(knn.pred==test.survive)

#Performance of different value of K
error <- rep(0,20)
K <- c(1:20)
for (i in (1:20)){
  set.seed(1);
  knn.pred=knn(titanic.train,titanic.test,train.survive,k=i);
  error[i] <- 1-mean(knn.pred==test.survive)
}
plot(K,error,main="With Normalization", xlab="K",ylab="error rate", type="b")

# Without normalization
train.X <- titanic[train_ind,!names(titanic) %in% 'Survived']
test.X <- titanic[-train_ind,!names(titanic) %in% 'Survived']
error.without <- rep(0,20)
K.without <- c(1:20)
for (j in (1:20)){
  set.seed(1);
  knn.pred.without=knn(train.X,test.X,train.survive,k=j);
  error.without[j] <- 1-mean(knn.pred.without==test.survive)
}
plot(K.without,error.without,main="Without Normalization", xlab="K",ylab="error rate",type="b")
