library(ISLR)

set.seed(101)
x=matrix(rnorm(100*2),100,2)
xmean=matrix(rnorm(8,sd=4),4,2)
which=sample(1:4,100,replace=TRUE)
x=x+xmean[which,]
plot(x,col=which,pch=19)

set.seed(4)
km.out=kmeans(x,4,nstart=15)
km.out
plot(x, col=km.out$cluster, pch=1, cex=2,lwd=2)
points(x, col=c(3,1,4,2)[which], pch=19)

# run kmeans using nstart = 1 and nstart = 20 and random seed(1)
set.seed(1)
km.out=kmeans(x,4,nstart=1)
km.out
plot(x, col=km.out$cluster, pch=1, cex=2,lwd=2)
points(x, col=c(3,1,4,2)[which], pch=19)

set.seed(1)
km.out=kmeans(x,4,nstart=20)
km.out
plot(x, col=km.out$cluster, pch=1, cex=2,lwd=2)
points(x, col=c(3,1,4,2)[which], pch=19)

# hierarchical clustering
hc.complete=hclust(dist(x), method="complete")
hc.average=hclust(dist(x), method="average")
hc.single=hclust(dist(x), method="single")

plot(hc.complete,main="Complete Linkage", cex=.9)
plot(hc.average, main="Average Linkage", cex=.9)
plot(hc.single, main="Single Linkage", cex=.9)

hc.cut = cutree(hc.complete,4)
table(hc.cut,which)

plot(x, col=hc.cut, pch=1, cex=2,lwd=2)

# generate a 3-dim example data set
x3=matrix(rnorm(30*3), ncol=3)
dd=as.dist(1-cor(t(x3)))
plot(hclust(dd, method="complete"))

# use NC160 data set
nci.labs=NCI60$labs
nci.data=NCI60$data

sd.data=scale(nci.data)

# perform hierarchical clustering and plot them
hc.complete1=hclust(dist(sd.data), method="complete")
hc.average1=hclust(dist(sd.data), method="average")
hc.single1=hclust(dist(sd.data), method="single")

plot(hc.complete1,main="Complete Linkage", cex=.9)
plot(hc.average1, main="Average Linkage", cex=.9)
plot(hc.single1, main="Single Linkage", cex=.9)

# cutting dendrogram to yield 5 clusters 
hc.cut1 = cutree(hc.complete1,5)
table(nci.labs, hc.cut1)

# kmeans VS hierarchical clustering
set.seed(3)
km.out1=kmeans(sd.data,5,nstart=20)
km.out1
table(km.out1$cluster,hc.cut1)

# correlated distance VS euclidean distance
dd1=as.dist(1-cor(t(sd.data)))
hc_cor = hclust(dd1, method="complete")
hc.cut_cor = cutree(hc_cor,5)

# complete with correlated distance VS complete with euclidean distance
table(hc.cut_cor, hc.cut1)

# kmeans VS complete linkage with correlated distance
table(hc.cut_cor, km.out1$cluster)

