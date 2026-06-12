# Breast Cancer Gene Expression Analysis Portfolio

This repository presents a reproducible gene expression analysis portfolio using breast cancer microarray data from GEO (GSE45827). The project demonstrates data acquisition, preprocessing, exploratory analysis, statistical testing, and visualization in R.

## Overview
This portfolio is built to showcase research-grade data analysis skills with a complete workflow:
- Public dataset retrieval from NCBI GEO with `GEOquery`
- Expression filtering and normalization with `limma`
- Exploratory data analysis including distributions, sample QC, and heatmaps
- Statistical testing for differential expression and sample clustering
- Publication-ready visualization using `ggplot2`

## Project Structure
```
.
├── README.md
├── LICENSE
├── analysis/
│   ├── 01_download_data.R
│   ├── 02_quality_control.R
│   ├── 03_exploratory_analysis.R
│   └── 04_statistical_testing.R
├── results/
│   ├── figures/
│   └── tables/
└── reports/
    └── analysis_report.html


```
MIT License

Copyright (c) 2026 Lara Pugnaloni

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

## Installation
Install the required R packages before running the analysis:
```r
install.packages(c("GEOquery", "limma", "ggplot2", "dplyr", "reshape2", "viridis"))
```

## Run the Analysis
Run the full pipeline with:
```r
source("run_analysis.R")
```

Or run each step separately:
```r
source("analysis/01_download_data.R")
source("analysis/02_quality_control.R")
source("analysis/03_exploratory_analysis.R")
source("analysis/04_statistical_testing.R")
```

## Key Results
This analysis generated the following outputs:
- **Samples analyzed:** 155
- **Genes analyzed:** 14,936
- **Significant genes identified:** 4,064 (`adj.P.Val < 0.05` and `|logFC| > 1`)
<img width="2400" height="1500" alt="01_expression_distribution" src="https://github.com/user-attachments/assets/94ded363-bffd-4317-a7ae-6c2fe97e83ea" />

<img width="3000" height="2400" alt="03_top_genes_heatmap" src="https://github.com/user-attachments/assets/100a26c7-143e-4798-836b-3332f8459eda" />


### Generated Outputs
- Figures: `results/figures/01_expression_distribution.png`, `results/figures/02_sample_means.png`, `results/figures/03_top_genes_heatmap.png`, `results/figures/04_correlation_matrix.png`, `results/figures/05_sample_dendrogram.png`, `results/figures/06_volcano_plot.png`
- Tables: `results/tables/gene_statistics.csv`, `results/tables/sample_statistics.csv`, `results/tables/statistical_testing_results.csv`, `results/tables/significant_genes.csv`
- Saved objects: `results/eset_raw.RData`, `results/eset_processed.RData


## Notes
- `run_analysis.R` uses your local R library path for package loading.
- If GEO download fails, verify internet access and rerun `analysis/01_download_data.R` in R.

## Technologies
- R 4.0+
- GEOquery
- limma
- ggplot2
- dplyr
- viridis

## Author
Lara Pugnaloni

