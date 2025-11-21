library(randomForest)
library(iml)
set.seed(78546)
X = subset(iris, select = -Species)[-130L,]
y = iris$Species[-130L]
rf = randomForest(X, y, ntree = 20L)
predictor = iml::Predictor$new(rf, data = iris[-130L, ], y = "Species", type = "prob")
x_interest = iris[130L, ]
predictor$predict(x_interest)
