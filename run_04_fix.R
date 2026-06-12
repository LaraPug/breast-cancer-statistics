.libPaths('C:/Users/Lara Pugnaloni/R/library')
library(limma)
library(ggplot2)
library(dplyr)
library(viridis)

cat('Loading processed data...\n')
load('results/eset_processed.RData')

# expr_norm and pdata should be available
if (!exists('expr_norm')) stop('expr_norm not found in results/eset_processed.RData')

# Cluster samples into 2 groups based on expression
cat('Clustering samples to define groups...\n')
sample_corr <- cor(expr_norm, method = 'spearman')
dist_mat <- as.dist(1 - sample_corr)
hc <- hclust(dist_mat, method = 'average')
groups <- cutree(hc, k = 2)

# Create design matrix
group_factor <- factor(groups)
design <- model.matrix(~group_factor)
colnames(design) <- c('Intercept','Group')

cat('Fitting linear model with limma...\n')
fit <- lmFit(expr_norm, design)
fit2 <- eBayes(fit)

# Get results for the Group coefficient
res <- topTable(fit2, coef = 'Group', number = Inf, adjust.method = 'BH')
res$Gene <- rownames(res)

# Save results
write.csv(res, 'results/tables/statistical_testing_results.csv', row.names = FALSE)

sig_genes <- res[res$adj.P.Val < 0.05 & abs(res$logFC) > 1, ]
write.csv(sig_genes, 'results/tables/significant_genes.csv', row.names = FALSE)

cat('Number significant genes:', nrow(sig_genes), '\n')

# Volcano plot
res_plot <- res %>% mutate(Significant = ifelse(adj.P.Val < 0.05 & abs(logFC) > 1, 'Yes', 'No'))

p <- ggplot(res_plot, aes(x = logFC, y = -log10(P.Value), color = Significant)) +
  geom_point(alpha = 0.6, size = 1.5) +
  scale_color_manual(values = c('No' = '#B0B0B0', 'Yes' = '#D73027')) +
  labs(title = 'Statistical Significance of Gene Expression (cluster groups)',
       x = 'Log2 Fold Change',
       y = '-log10(p-value)',
       caption = 'Significant genes highlighted in red: adj.P.Val < 0.05 and |logFC| > 1') +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = 'bold', size = 14), plot.caption = element_text(size = 9))

ggsave('results/figures/06_volcano_plot.png', p, width = 8, height = 5, dpi = 300)
cat('Saved: results/figures/06_volcano_plot.png\n')
