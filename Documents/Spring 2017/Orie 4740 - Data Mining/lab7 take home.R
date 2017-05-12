library(tree)
library(ISLR)
attach(Carseats)
library(randomForest)

# Create qualitative response "High"
High=ifelse(Sales<=8,"No","Yes")
Carseats=data.frame(Carseats,High)

# Generate training set and test set of equal sizes
set.seed(2)
train=sample(1:nrow(Carseats), 200)
Carseats.test=Carseats[-train,]
High.test=High[-train]

# Bagging with 10 Trees
set.seed(2)
bag.carseats=randomForest(High~.-Sales,data=Carseats,subset=train,mtry=10,
                        ntree=10,importance=TRUE)
bag.carseats

# Calculate test classification error rate
High.pred=predict(bag.carseats,Carseats.test)
table(High.pred,High.test)

importance(bag.carseats)
varImpPlot(bag.carseats)

# Bagging with 500 trees
set.seed(2)
bag.carseats=randomForest(High~.-Sales,data=Carseats,subset=train,mtry=10,
                          ntree=500,importance=TRUE)
bag.carseats

# Calculate test classification error rate
High.pred = predict(bag.carseats,Carseats.test)
table(High.pred,High.test)

# Bagging with 500 trees and 3 random features 
set.seed(2)
bag.carseats=randomForest(High~.-Sales,data=Carseats,subset=train,mtry=3,
                          ntree=500,importance=TRUE)
bag.carseats

# Calculate test classification error rate
High.pred = predict(bag.carseats,Carseats.test)
table(High.pred,High.test)