# Random Forest Cross-Platform Reproducibility Testing

## Project Overview

This project tests the **cross-platform reproducibility** of Random Forest predictions using the `randomForest` and `iml` packages in R. The goal is to verify that identical Random Forest models and prediction code produce consistent results across different operating systems (Linux, macOS, and Windows).

GitHub Actions automatically runs the same test script (`test_rf_iml.R`) on three platforms:
- `ubuntu-latest` (Linux)
- `macos-latest` (macOS)
- `windows-latest` (Windows)

Each run saves predictions to `prediction_result.csv` and uploads them as artifacts, allowing comparison of outputs across operating systems.

## How to Run Locally

### Prerequisites
1. Install R (version 3.6.0 or higher recommended)
2. Install required R packages:
   ```r
   install.packages("randomForest")
   install.packages("iml")
   ```

### Running the Test
Execute the test script from the repository root:
```bash
Rscript test_rf_iml.R
```

This will:
- Train a Random Forest model on the iris dataset (excluding row 130)
- Create an `iml` Predictor wrapper for probability predictions
- Predict on the held-out observation (iris row 130)
- Print the prediction results to console
- Save results to `prediction_result.csv`
- Print session information (R version, package versions, OS details)

## Interpreting Results

### Output Structure

The `prediction_result.csv` file contains predicted class probabilities with the following structure:
- **Columns**: One column per class (setosa, versicolor, virginica)
- **Values**: Predicted probabilities for each class (should sum to 1.0)
- **Rows**: One row per prediction (in this case, a single test observation)

Example output:
```csv
setosa,versicolor,virginica
0.0,0.05,0.95
```

### Comparing Outputs Across Operating Systems

To compare predictions across platforms:

1. **Download Artifacts**: After a GitHub Actions workflow run completes, download the artifacts for each OS:
   - `prediction_result-ubuntu-latest`
   - `prediction_result-macos-latest`
   - `prediction_result-windows-latest`

2. **Compare Probability Values**: Open each CSV file and compare the predicted probabilities for each class.

3. **Expected Behavior**:
   - **Identical predictions**: Ideally, all three platforms should produce identical probability values due to:
     - Fixed random seed (`set.seed(78546)`)
     - Fixed model specification (`ntree = 20L`)
     - Fixed training data (iris dataset, excluding row 130)
     - Fixed test observation (iris row 130)
   
4. **Understanding Differences**:
   - **Small numeric differences** (e.g., differences at the 10th decimal place or beyond) may occur due to:
     - Platform-specific floating-point arithmetic implementations
     - Different BLAS/LAPACK library versions
     - Compiler optimizations
   - **Large differences** or different predicted classes would indicate a reproducibility issue that warrants investigation.

### Session Information

Each run prints `sessionInfo()` output, which includes:
- R version
- Platform/OS information
- Loaded packages and their versions
- Locale settings

This information is useful for debugging any differences in predictions and understanding the environment in which the model was trained and evaluated.

## Technical Details

- **Random Seed**: Fixed at `78546` to ensure reproducible model training
- **Dataset**: Fisher's iris dataset (built into R)
- **Model**: Random Forest with 20 trees
- **Test Point**: Observation 130 from the iris dataset (held out from training)
- **Prediction Type**: Probabilities (`type = "prob"`)
