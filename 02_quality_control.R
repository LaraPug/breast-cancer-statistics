# ============================================================================
# 02_quality_control.R
# Purpose: QC, normalization, and preprocessing of gene expression data
# ============================================================================

library(GEOquery)
library(limma)
library(dplyr)

cat("Loading raw expression data...\n")
load("results/eset_raw.RData")

# Get expression matrix and metadata
expr_matrix <- exprs(eset)
pdata <- pData(eset)

cat("Expression matrix dimensions:", dim(expr_matrix), "\n")
cat("Samples:\n")
print(head(pdata[, 1:5]))  # Show first few columns

# ============================================================================
# Quality Control
# ============================================================================

cat("\n--- Quality Control ---\n")

# Remove genes with very low expression (filtering out noise)
# Keep genes with mean expression > median of mean expression
mean_expr <- rowMeans(expr_matrix)
median_mean <- median(mean_expr)
keep_genes <- mean_expr > median_mean

expr_filtered <- expr_matrix[keep_genes, ]
cat("Genes retained after filtering:", nrow(expr_filtered), "/", nrow(expr_matrix), "\n")

# Check for missing values
cat("Missing values in expression matrix:", sum(is.na(expr_filtered)), "\n")

# ============================================================================
# Normalization (if not already normalized)
# ============================================================================

cat("\n--- Normalization ---\n")

# Apply quantile normalization and log2 transformation if needed
# Check if data appears to be log-transformed
if (max(expr_filtered, na.rm = TRUE) > 100) {
  cat("Log-transforming expression data...\n")
  expr_norm <- log2(expr_filtered + 1)
} else {
  cat("Data appears already log-transformed, applying quantile normalization...\n")
  expr_norm <- normalizeBetweenArrays(expr_filtered, method = "quantile")
}

# ============================================================================
# Summary Statistics
# ============================================================================

cat("\n--- Summary Statistics ---\n")
cat("Expression value ranges (normalized):\n")
print(summary(as.numeric(expr_norm)))

# ============================================================================
# Save processed data
# ============================================================================

save(expr_norm, pdata, file = "results/eset_processed.RData")
cat("\nProcessed expression data saved to results/eset_processed.RData\n")
