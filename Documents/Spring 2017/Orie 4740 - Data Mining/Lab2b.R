titanic = read.csv(file = "/Users/siyuan/Documents/Spring 2017/Orie 4740 - Data Mining/titanic.csv", header = T, na.strings = '')
titanic <- titanic[, !colnames(titanic) %in% c('PassengerId', 'Name', 'Ticket', 'Cabin')]
titanic <- titanic[complete.cases(titanic),]

sapply(titanic, class)

titanic$Sex <- model.matrix( ~ Sex - 1, data = titanic)
titanic$Embarked <- model.matrix( ~ Embarked - 1, data = titanic)

set.seed(1)
train_ind <- sample(1:nrow(titanic), 2/3 * nrow(titanic))
titanic_train <- titanic[train_ind, ]
titanic_test <- titanic[-train_ind, ]

train.survive = titanic$Survived[train_ind]
test.survive = titanic$Survived[-train_ind]
knn.pred = knn(titanic_train, titanic_test, train.survive, k = 1)
error <- rep(0, 20)
k <- c(1:20)
for (i in (1:20)) {
  knn.pred = knn(titanic_train, titanic_test, train.survive, k = i);
  error[i] <- 1-mean(knn.pred==test.survive)
}


titanic_logit <- glm(Survived~., data = titanic_train, family = binomial)
# predict.glm type = response returns the predicted p, rather than log scaled p
titanic_pred <- predict(titanic_logit, titanic_test, type = "response")

summary(titanic_logit)
titanic_bin <- as.numeric(titanic_pred >= 0.5)

table(titanic_bin, titanic_test$Survived)
