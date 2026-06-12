# ============================================================================
# 01_download_data.R
# Purpose: Download gene expression data from NCBI GEO database
# Dataset: GSE45827
# ============================================================================

# Load required libraries
library(GEOquery)

cat("Downloading gene expression data from GEO...\n")

# Download the dataset
# GSE45827 is a microarray dataset with gene expression measurements
gset <- getGEO("GSE45827", GSEMatrix = TRUE, AnnotGPL = TRUE)

# Extract the first expression set (there may be multiple platforms)
# getGEO() returns a list even for a single platform; always extract first element
if (is.list(gset)) {
  eset <- gset[[1]]
} else {
  eset <- gset
}

cat("Dataset downloaded successfully!\n")
cat("Dimensions:", dim(eset), "\n")
cat("Number of samples:", ncol(eset), "\n")
cat("Number of genes:", nrow(eset), "\n")

# Save the expression set for downstream analysis
save(eset, file = "results/eset_raw.RData")
cat("Expression set saved to results/eset_raw.RData\n")
