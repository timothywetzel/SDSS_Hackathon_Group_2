
evictions <- read.csv("~/Desktop/sdss2019_data_hack/Datasets/evictions.csv")

ACS <- read.csv("~/Desktop/acs_data_2010-2016_NG_Update.csv")

evictions$year <- as.factor(evictions$year)

model <- lm(eviction.rate ~., data = evictions)

evictions <- na.omit(evictions)

evictions <- evictions[ ,-c(1:3, 4, 22:24) ]

summary(model)

library(glmnet)

grid= 10^seq(10, -2, length=100)

x <- data.matrix(evictions[,-17])

y <- evictions$eviction.filings

#############################################Cross Validation
fit.cv <- cv.glmnet(x, y, alpha=1, nlambda=100, nfolds = 10, standardize = TRUE, family= "poisson")


plot(fit.cv)


# This plot relates predictive error to the value of lambda (bottom axis) and to the number of non-zero parameters (top axis). 

# Get the model coefficients for the value of lambda that minimizes cross-validation error

best <- which(fit.cv$cvm == min(fit.cv$cvm))

beta <- fit.cv$glmnet.fit$beta[,best]

goodbeta <-print(sort(beta[beta != 0]), digits=3)

print(sort(beta[beta != 0]), digits=3)


# value of lambda at minimum predictive error: 

bestlam <- fit.cv$lambda.min

bestlam

##################

set.seed(1)

train= sample(1:nrow(x), nrow(x)*.8)

test= (-train)

y.test=y[test]

lasso.mod=glmnet(x[train,], y[train], alpha=1, lambda = bestlam, family = "poisson")

lasso.predict= predict(lasso.mod, s= bestlam, newx=x[test,], type="response", se.fit = TRUE, dispersion=TRUE, family = "poisson")


coef(lasso.mod)

