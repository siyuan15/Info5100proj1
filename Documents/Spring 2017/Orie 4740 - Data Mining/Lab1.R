x = seq(from = -10, to = 20, by = 0.01)
y = rep(1, length(x))
for (i in (1: length(x))){
  y[i] = 0.1 * x[i]^3 - 2 * x[i]^2 + 0.1 * x[i]
}
plot(x, y, type = "l",xlab = "x_axis", ylab = "y_axis", main = "x_y")
lines(x, y-100, type = "l")

par(mfrow = c(2, 1))
par("mar")
par(mar = c(1, 1, 1, 1))

corollas = read.table(file = "/Users/siyuan/Downloads/ToyotaCorolla.csv", header = T, sep = ",")
nrow(corollas)
sum(is.na(corollas$Price))
corollas2 <- corollas[, c("Price","Age_08_04", "KM", "Fuel_Type", "HP",
                          "Met_Color", "Doors", "Quarterly_Tax", "Weight") ]
is.factor(corollas2$Fuel_Type)
levels(corollas2$Fuel_Type)
is.factor(corollas2$Met_Color)
corollas2$Met_Color = as.factor(corollas2$Met_Color)
corollasLM = lm( formula = Price ~ ., data = corollas2 )
summary(corollasLM)
