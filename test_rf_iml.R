library(randomForest)
library(iml)
set.seed(78546)
X <- subset(iris, select = -Species)[-130L, ]
y <- iris$Species[-130L]
rf <- randomForest(X, y, ntree = 20L)
predictor <- iml::Predictor$new(rf,
                                 data = iris[-130L, ],
                                 y = "Species",
                                 type = "prob")
x_interest <- iris[130L, ]
result <- predictor$predict(x_interest)
print(result)
write.csv(result, file = "prediction_result.csv", row.names = FALSE)
sessionInfo()
