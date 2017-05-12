# Clustering with Categorical Data
#install.packages("e1071")
library(e1071)

mushroom = read.csv("/Users/siyuan/Documents/Spring 2017/Orie 4740 - Data Mining/mushroom.csv", header = TRUE)

dat = model.matrix(~., data=mushroom[,2:14])[,-1]
distm = as.dist(hamming.distance(dat))
hc.complete=hclust(distm, method="complete")

plot(hc.complete,main="Complete Linkage", cex=.9)

hc.cut = cutree(hc.complete,8)
table(mushroom[,1], hc.cut)

hc.cut = cutree(hc.complete,2)
table(mushroom[,1], hc.cut)

# Principal Component Analysis
row.names(USArrests)
names(USArrests)

apply(USArrests, 2, mean)
apply(USArrests, 2, var)

pr.out=prcomp(USArrests, scale=TRUE)
names(pr.out)
pr.out$center
pr.out$scale
pr.out$rotation
dim(pr.out$x)
biplot(pr.out, scale=0)
pr.out$sdev
pr.var=pr.out$sdev^2
pr.var
pve=pr.var/sum(pr.var)
pve
plot(pve, xlab="Principal Component", ylab="Proportion of Variance Explained ", ylim=c(0,1) ,type='b')
plot(cumsum(pve), xlab="Principal Component", ylab="Cumulative Proportion of Variance Explained ", ylim=c(0,1) ,type='b')
