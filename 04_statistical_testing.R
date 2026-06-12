# ============================================================================
# 04_statistical_testing.R
# Purpose: Statistical analysis - correlation, clustering, differential testing
# ============================================================================

library(limma)
library(dplyr)
library(ggplot2)
library(stats)
library(viridis)

cat("Loading processed expression data...\n")
load("results/eset_processed.RData")

# ============================================================================
# Correlation Analysis
# ============================================================================

cat("\n--- Correlation Analysis ---\n")

# Calculate pairwise Spearman correlation between samples
sample_corr <- cor(expr_norm, method = "spearman")

# Summary of correlations
cat("Sample correlation summary:\n")
cat("Median correlation:", median(sample_corr[lower.tri(sample_corr)]), "\n")
cat("Range:", range(sample_corr[lower.tri(sample_corr)]), "\n")

# Create correlation matrix visualization
library(reshape2)
corr_melt <- melt(sample_corr)
colnames(corr_melt) <- c("Sample1", "Sample2", "Correlation")

p1 <- ggplot(corr_melt, aes(x = Sample1, y = Sample2, fill = Correlation)) +
  geom_tile() +
  scale_fill_viridis_c(option = "plasma", name = "Spearman rho", limits = c(0, 1)) +
  labs(title = "Sample-to-Sample Correlation Matrix",
       x = "Sample", y = "Sample",
       caption = "Pairwise Spearman correlations between samples") +
  theme_minimal(base_size = 11) +
  theme(plot.title = element_text(face = "bold", size = 14),
        axis.text.x = element_text(angle = 45, hjust = 1, size = 8),
        axis.text.y = element_text(size = 8),
        plot.caption = element_text(size = 9))

ggsave("results/figures/04_correlation_matrix.png", p1, width = 8, height = 7, dpi = 300)
cat("Saved: 04_correlation_matrix.png\n")

# ============================================================================
# Hierarchical Clustering
# ============================================================================

cat("\n--- Hierarchical Clustering ---\n")

# Calculate distances and perform clustering
dist_matrix <- as.dist(1 - sample_corr)
hclust_result <- hclust(dist_matrix, method = "average")

# Create dendrogram
png("results/figures/05_sample_dendrogram.png", width = 800, height = 600, res = 100)
plot(hclust_result, 
     main = "Hierarchical Clustering of Samples",
     xlab = "Sample",
     ylab = "Distance")
dev.off()
cat("Saved: 05_sample_dendrogram.png\n")

# ============================================================================
# Statistical Testing: Gene Variance Analysis
# ============================================================================

cat("\n--- Statistical Testing ---\n")

# Perform ANOVA-like test to identify genes with significant variation across samples
# This uses the limma framework suitable for microarray data

# Create a design matrix (treating each sample as a group for demonstration)
design <- model.matrix(~factor(1:ncol(expr_norm)))

# Fit linear model
fit <- lmFit(expr_norm, design)
fit2 <- eBayes(fit)

# Extract results
results <- topTable(fit2, number = Inf, adjust.method = "BH")
results$Gene <- rownames(results)

# Filter significant genes (adjusted p-value < 0.05)
sig_genes <- results[results$adj.P.Val < 0.05, ]

cat("Number of genes with p.adj < 0.05:", nrow(sig_genes), "\n")

# Save results
write.csv(results, "results/tables/statistical_testing_results.csv", row.names = FALSE)
write.csv(sig_genes, "results/tables/significant_genes.csv", row.names = FALSE)

# ============================================================================
# Volcano-like plot (logFC vs p-value)
# ============================================================================

cat("\n--- Creating results visualization ---\n")

results_plot <- results %>%
  mutate(Significant = ifelse(adj.P.Val < 0.05 & abs(logFC) > 1, "Yes", "No"))

p2 <- ggplot(results_plot, aes(x = logFC, y = -log10(P.Value), color = Significant)) +
     geom_point(alpha = 0.6, size = 1.5) +
     scale_color_manual(values = c("No" = "#B0B0B0", "Yes" = "#D73027")) +
     labs(title = "Statistical Significance of Gene Expression",
                x = "Log2 Fold Change",
                y = "-log10(p-value)",
                caption = "Points colored red are significant (adj.P.Val < 0.05 and |logFC| > 1)") +
     theme_minimal(base_size = 12) +
     theme(plot.title = element_text(face = "bold", size = 14),
                    plot.caption = element_text(size = 9))

ggsave("results/figures/06_volcano_plot.png", p2, width = 8, height = 5, dpi = 300)
cat("Saved: 06_volcano_plot.png\n")

# ============================================================================
# Summary Statistics Report
# ============================================================================

cat("\n--- Analysis Summary ---\n")
cat("Total genes analyzed:", nrow(results), "\n")
cat("Genes with adj.P.Val < 0.05:", nrow(sig_genes), "\n")
cat("Percentage of significant genes:", 
    round(100 * nrow(sig_genes) / nrow(results), 2), "%\n")
cat("Top 5 significant genes:\n")
print(head(sig_genes[order(sig_genes$adj.P.Val), c("Gene", "logFC", "P.Value", "adj.P.Val")], 5))

cat("\n--- Statistical Testing Complete ---\n")
