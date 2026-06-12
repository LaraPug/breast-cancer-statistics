# ============================================================================
# 03_exploratory_analysis.R
# Purpose: Exploratory Data Analysis and visualization
# ============================================================================

library(ggplot2)
library(dplyr)
library(reshape2)
library(viridis)

cat("Loading processed expression data...\n")
load("results/eset_processed.RData")

# ============================================================================
# Distribution Analysis
# ============================================================================

cat("\n--- Distribution Analysis ---\n")

# Create a data frame for visualization
expr_df <- as.data.frame(expr_norm)
expr_long <- melt(as.matrix(expr_norm), varnames = c("Gene", "Sample"), value.name = "Expression")

# Plot overall expression distribution
p1 <- ggplot(expr_long, aes(x = Expression)) +
  geom_histogram(bins = 50, fill = "steelblue", color = "white", alpha = 0.85) +
  labs(title = "Distribution of Gene Expression Values",
    x = "Expression Level (log2)",
    y = "Frequency",
    caption = "Histogram of all gene expression values after preprocessing") +
  theme_minimal(base_size = 13) +
  theme(plot.title = element_text(face = "bold", size = 14),
     plot.caption = element_text(size = 9, color = "#444444"))

ggsave("results/figures/01_expression_distribution.png", p1, width = 8, height = 5, dpi = 300)
cat("Saved: 01_expression_distribution.png\n")

# ============================================================================
# Sample-level Analysis
# ============================================================================

cat("\n--- Sample-Level Analysis ---\n")

# Calculate sample statistics
sample_stats <- data.frame(
  Sample = colnames(expr_norm),
  Mean = colMeans(expr_norm),
  Median = apply(expr_norm, 2, median),
  SD = apply(expr_norm, 2, sd)
)

print(head(sample_stats))

# Plot sample means
p2 <- ggplot(sample_stats, aes(x = reorder(Sample, Mean), y = Mean)) +
  geom_col(fill = "coral", alpha = 0.9, color = "#333333") +
  coord_flip() +
  labs(title = "Mean Expression by Sample",
       x = "Sample",
       y = "Mean Expression Level") +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = "bold", size = 14),
        axis.text.y = element_text(size = 7),
        plot.caption = element_text(size = 9)) +
  labs(caption = "Samples ordered by mean expression; useful to detect outlier samples")

ggsave("results/figures/02_sample_means.png", p2, width = 8, height = 6, dpi = 300)
cat("Saved: 02_sample_means.png\n")

# ============================================================================
# Gene-level Analysis
# ============================================================================

cat("\n--- Gene-Level Analysis ---\n")

# Calculate gene statistics
gene_stats <- data.frame(
  Gene = rownames(expr_norm),
  Mean = rowMeans(expr_norm),
  Variance = apply(expr_norm, 1, var),
  CV = apply(expr_norm, 1, sd) / rowMeans(expr_norm)  # Coefficient of variation
)

# Top 10 most variable genes
top_variable <- gene_stats %>%
  arrange(desc(Variance)) %>%
  head(10)

cat("Top 10 most variable genes:\n")
print(top_variable)

# Save summary statistics
write.csv(gene_stats, "results/tables/gene_statistics.csv", row.names = FALSE)
write.csv(sample_stats, "results/tables/sample_statistics.csv", row.names = FALSE)

# ============================================================================
# Heatmap of most variable genes
# ============================================================================

cat("\n--- Creating heatmap of top variable genes ---\n")

# Select top 30 variable genes
top_genes_idx <- order(gene_stats$Variance, decreasing = TRUE)[1:30]
top_expr <- expr_norm[top_genes_idx, ]

# Create heatmap data
heatmap_data <- melt(as.matrix(top_expr), varnames = c("Gene", "Sample"), value.name = "Expression")

p3 <- ggplot(heatmap_data, aes(x = Sample, y = Gene, fill = Expression)) +
  geom_tile(color = NA) +
  scale_fill_viridis_c(option = "magma", name = "Expression") +
  labs(title = "Top 30 Most Variable Genes",
    x = "Sample",
    y = "Gene",
    caption = "Heatmap of the 30 genes with highest variance across samples") +
  theme_minimal(base_size = 10) +
  theme(plot.title = element_text(face = "bold", size = 14),
     axis.text.x = element_text(angle = 45, hjust = 1, size = 8),
     axis.text.y = element_text(size = 7),
     plot.caption = element_text(size = 9))

ggsave("results/figures/03_top_genes_heatmap.png", p3, width = 10, height = 8, dpi = 300)
cat("Saved: 03_top_genes_heatmap.png\n")

cat("\n--- EDA Complete ---\n")
