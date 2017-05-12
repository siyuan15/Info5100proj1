library(readr)
library(boot)
library(caTools)


setwd("/Users/siyuan/Documents/Spring 2017/Orie 4740 - Data Mining")

corollas0 = read.csv("ToyotaCorolla.csv", header = T)
corollas = corollas0[, c("Price", "Age_08_04", "KM")]

sapply(corollas, class)
corollas = corollas[complete.cases(corollas), ]

set.seed(1)
train_id = sample(nrow(corollas0), nrow(corollas)/2)

test_id = corollas[-train_id,]

lm.fit1 = lm(Price~Age_08_04 + KM, data = corollas, subset = train_id)
lm.fit2 = lm(Price~poly(Age_08_04, 2) + poly(KM, 2), data = corollas, subset = train_id)
lm.fit3 = lm(Price~poly(Age_08_04, 3) + poly(KM,3), data = corollas, subset = train_id)

summary(lm.fit1)
summary(lm.fit2)
summary(lm.fit3)
mse = mean((test_id$Price-predict(lm.fit3,test_id))^2)

library(boot)
cv.error = rep(0, 5)
for (i in 1:5) {
  glm.fit = glm(Price~poly(Age_08_04, i) + poly(KM, i), data = corollas)
  cv.error[i] = cv.glm(corollas, glm.fit)$delta[1]
}
cv.error
plot(cv.error, type = "b")
summary(glm.fit)

#K-fold CV

cv.error = rep(0:5)
for (i in 1:5) {
  glm.fit = glm(Price~poly(Age_08_04, i)+poly(KM, i), data = corollas)
  cv.error[i] = cv.glm(corollas, glm.fit, K=10)$delta[1]
}
cv.error
plot(cv.error, type = "b")



n = 1000;
x1= runif(n)
x2= runif(n,-2,1)
z = (x1-0.2)*(x1-0.5)*25 -x2*(x2+1.2)*(x2-0.8)+rnorm(n)/3
y = as.integer(z>0)
plot(x1,x2,col=c("red","blue")[y+1])
DF = data.frame(x1,x2,y)

cv.error = rep(0, 5)
for (i in 1:5) {
  glm.fit = glm(y~poly(x1, i) + poly(x2, i), data = DF, family = binomial(link = "logit"))
  cv.error[i] = cv.glm(DF, glm.fit)$delta[1]
}
cv.error
plot(cv.error, type = "b")
summary(glm.fit)