# ============================================================================
# run_analysis.R
# Purpose: Master script - runs the entire analysis pipeline
# Usage: source("run_analysis.R")
# ============================================================================

cat("==========================================\n")
cat("GENE EXPRESSION STATISTICAL ANALYSIS\n")
cat("Portfolio Project\n")
cat("==========================================\n\n")

# Check if required packages are installed
packages <- c("GEOquery", "limma", "ggplot2", "dplyr", "reshape2")
missing_packages <- packages[!sapply(packages, require, character.only = TRUE)]

if (length(missing_packages) > 0) {
  cat("Installing missing packages:", paste(missing_packages, collapse = ", "), "\n")
  install.packages(missing_packages)
}

# Load packages
for (pkg in packages) {
  library(pkg, character.only = TRUE)
}

cat("All packages loaded successfully.\n\n")

# Run analysis pipeline
cat("Starting analysis pipeline...\n\n")

cat("Step 1/4: Downloading data from GEO\n")
source("analysis/01_download_data.R")
cat("\n")

cat("Step 2/4: Quality control and preprocessing\n")
source("analysis/02_quality_control.R")
cat("\n")

cat("Step 3/4: Exploratory data analysis\n")
source("analysis/03_exploratory_analysis.R")
cat("\n")

cat("Step 4/4: Statistical testing and analysis\n")
source("analysis/04_statistical_testing.R")
cat("\n")

cat("==========================================\n")
cat("ANALYSIS COMPLETE!\n")
cat("==========================================\n")
cat("Results saved to:\n")
cat("  - Figures: results/figures/\n")
cat("  - Tables:  results/tables/\n")
cat("  - Data:    results/\n")
