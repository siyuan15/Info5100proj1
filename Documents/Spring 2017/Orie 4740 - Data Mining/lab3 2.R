

library(readr)
library(boot)
library(caTools)

ToyotaCorolla <- read_csv("C:/Users/shuying/Desktop/ToyotaCorolla(1).csv");
corollas <- ToyotaCorolla[, c("Price","Age_08_04", "KM")];
cor <- corollas[complete.cases(corollas), ];
#View(cor)

set.seed(1)
train_id = sample(nrow(cor), nrow(cor)/2)
cor.test= cor[-train_id,]
lm1 <- lm(Price~Age_08_04+KM, data = cor, subset=train_id)

mse <- mean((cor.test$Price-predict(lm1,cor.test))^2)

sm1 <- summary(lm1)


lm.fit2 <- lm(Price~poly(Age_08_04,2)+poly(KM,2), data = cor, subset=train_id)

lm.fit3 = lm(Price~poly(Age_08_04,3)+poly(KM,3), data = cor, subset=train_id)

sm2 <- summary(lm.fit2)

mse2 <- mean((cor.test$Price-predict(lm.fit2,cor.test))^2)

sm3 <- summary(lm.fit3)

mse3 <- mean((cor.test$Price-predict(lm.fit3,cor.test))^2)



# Cross Validation

cv.error = rep(0,5)

for (i in 1:5){
  glm.fit = glm (Price~poly(Age_08_04,i)+poly(KM,i), data = cor)
  cv.error[i] = cv.glm(cor,glm.fit)$delta[1]
}
cv.error
plot(cv.error,type= "b")

summary(lm.fit3)

summary(glm.fit)

# k-fold

cv.error2 = rep(0,5)

for (i in 1:5){
  glm.fit = glm (Price~poly(Age_08_04,i)+poly(KM,i), data = cor)
  cv.error2[i] = cv.glm(cor, glm.fit, K=10)$delta[1]
}
cv.error2
plot(cv.error2,type= "b")

# part 2-1

n = 1000;
x1= runif(n)
x2= runif(n,-2,1)
z = (x1-0.2)*(x1-0.5)*25 -x2*(x2+1.2)*(x2-0.8)+rnorm(n)/3
y = as.integer(z>0)
plot(x1,x2,col=c("red","blue")[y+1])
DF = data.frame(x1,x2,y)

cv.error3 = rep(0,5)
for (i in 1:5){
  model_4 = glm(y ~ poly(x1,i) + poly(x2,i), data = DF, family=binomial)
  #glm.fit4 = glm (Price~poly(Age_08_04,i)+poly(KM,i), data = DF)
  cv.error3[i] = cv.glm(DF, model_4)$delta[1]
}
cv.error3
plot(cv.error3,type= "b")

# part 2-2

cv.error4 = rep(0,5)
for (i in 1:5){
  model_4 = glm(y ~ poly(x1,i) + poly(x2,i), data = DF, family=binomial)
  cv.error4[i] = cv.glm(DF, model_4, K=10)$delta[1]
}
cv.error4
plot(cv.error4,type= "b")
