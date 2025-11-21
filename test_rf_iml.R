# ============================================================================
# Random Forest Cross-Platform Reproducibility Test
# ============================================================================
# 
# Purpose:
#   Test cross-platform reproducibility of Random Forest predictions across
#   Linux, macOS, and Windows operating systems using the randomForest and
#   iml packages.
#
# Approach:
#   - Use a fixed random seed (78546) to ensure deterministic model training
#   - Train on iris dataset with a fixed model specification (ntree = 20)
#   - Hold out observation 130 as the test point
#   - Predict class probabilities for the held-out observation
#   - Save predictions to prediction_result.csv for comparison across OSes
#
# Expected Outcome:
#   Identical (or nearly identical) predictions across all platforms, 
#   demonstrating that the Random Forest implementation is reproducible.
#
# Output:
#   - prediction_result.csv: CSV file with predicted probabilities per class
#   - Console output: Prediction results and session information
#
# Note:
#   sessionInfo() is printed to log R version, package versions, and OS details
#   for debugging any differences in predictions.
# ============================================================================

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
