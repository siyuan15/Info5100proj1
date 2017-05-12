library(ISLR)
attach(Wage)
library(splines)
library(gam)

# GAM with natural spline and smooth spline
gam1=lm(wage~ns(year,4)+ns(age,5)+education,data=Wage)
gam.m3=gam(wage~s(year,4)+s(age,5)+education,data=Wage)
par(mfrow = c(1, 3))
plot(gam.m3, se=TRUE,col="blue")
plot.gam(gam1, se=TRUE, col="red")

# Model selection using ANOVA 
gam.m1=gam(wage~s(age,5)+education,data=Wage)
gam.m2=gam(wage~year+s(age,5)+education,data=Wage)
anova(gam.m1, gam.m2, gam.m3, test="F")

summary(gam.m3)
summary(gam.m2)
preds=predict(gam.m2, newdata=Wage)

# GAM for Classification Problems 
gam.lr=gam(I(wage>250)~year+s(age,df=5)+education,family=binomial,data=Wage)
par(mfrow=c(1,3))
plot(gam.lr,se=T,col="green")
table(education,I(wage>250))

# GAM excluding category < HS
gam.lr=gam(I(wage>250)~year+s(age,df=5)+education,family=binomial,data=Wage,
             subset=(education!="1. < HS Grad") )
plot(gam.lr, se = T, col = "pink")

# GAM with specific form
gam.m4=gam(wage~poly(year, 6)+bs(age,5)+education,data=Wage)

# Take-home questions
m1 = gam(I(wage>250)~year+education,family=binomial,data=Wage,
         subset=(education!="1. < HS Grad") )

m2 = gam(I(wage>250)~year+age+education,family=binomial,data=Wage,
         subset=(education!="1. < HS Grad") )

m3 = gam(I(wage>250)~year+s(age,2)+education,family=binomial,data=Wage,
         subset=(education!="1. < HS Grad") )

m4 = gam(I(wage>250)~year+s(age,5)+education,family=binomial,data=Wage,
         subset=(education!="1. < HS Grad") )

m5 = gam(I(wage>250)~year+s(age,8)+education,family=binomial,data=Wage,
         subset=(education!="1. < HS Grad") )

anova(m1, m2, m3, m4, m5, test="F")