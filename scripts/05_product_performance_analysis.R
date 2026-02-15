# ============================================================
# STEP 5: PRODUCT PERFORMANCE ANALYSIS
# Project: Online Retail Behavioral Analysis
# Description: Evaluate merchandise-level performance using
#              quantity, revenue, and order-frequency metrics.
#              This step identifies high-volume, high-value,
#              and low-performing products.
# Data Dependencies:
#   Input:  data/processed/online_retail_enriched.rds
#   Output: Individual product performance metric RDS tables
# ============================================================

# LOAD REQUIRED LIBRARIES
library(tidyverse)

# LOAD ENRICHED DATA
enrich_retail_data <- readRDS("data/processed/online_retail_enriched.rds")

# =============================================================================
# SECTION I: QUANTITY PERFORMANCE (Volume-Based)
# =============================================================================

# 5.1 Top 10 Products by Total Quantity Sold
# Identifies highest unit-movement merchandise
top_10_quantity_volume <- enrich_retail_data %>%
  group_by(StockCode, ShortProductLabel) %>%
  summarise(total_quantity = sum(Quantity, na.rm = TRUE)) %>%
  arrange(desc(total_quantity)) %>%
  slice_head(n = 10)

saveRDS(top_10_quantity_volume,
        "data/processed/product_top_10_quantity_volume.rds")

# 5.2 Bottom 10 Products by Total Quantity Sold
# Highlights lowest-moving inventory
bottom_10_quantity_volume <- enrich_retail_data %>%
  group_by(StockCode, ShortProductLabel) %>%
  summarise(total_quantity = sum(Quantity, na.rm = TRUE)) %>%
  arrange(total_quantity) %>%
  slice_head(n = 10)

saveRDS(bottom_10_quantity_volume,
        "data/processed/product_bottom_10_quantity_volume.rds")

# =============================================================================
# SECTION II: QUANTITY PERFORMANCE (Average-Based)
# =============================================================================

# 5.3 Top 10 Products by Average Quantity per Order Line
# Measures product intensity per transaction occurrence
top_10_quantity_average <- enrich_retail_data %>%
  group_by(StockCode, ShortProductLabel) %>%
  summarise(avg_quantity_per_line = mean(Quantity, na.rm = TRUE)) %>%
  arrange(desc(avg_quantity_per_line)) %>%
  slice_head(n = 10)

saveRDS(top_10_quantity_average,
        "data/processed/product_top_10_quantity_average.rds")

# =============================================================================
# SECTION III: REVENUE PERFORMANCE (Volume-Based)
# =============================================================================

# 5.4 Top 10 Products by Total Revenue Generated
# Identifies highest monetary contributors
top_10_revenue_volume <- enrich_retail_data %>%
  group_by(StockCode, ShortProductLabel) %>%
  summarise(total_revenue = sum(Revenue, na.rm = TRUE)) %>%
  arrange(desc(total_revenue)) %>%
  slice_head(n = 10)

saveRDS(top_10_revenue_volume,
        "data/processed/product_top_10_revenue_volume.rds")

# =============================================================================
# SECTION IV: REVENUE PERFORMANCE (Average-Based)
# =============================================================================

# 5.5 Top 10 Products by Average Revenue per Order Line
# Evaluates per-transaction monetary efficiency
top_10_revenue_average <- enrich_retail_data %>%
  group_by(StockCode, ShortProductLabel) %>%
  summarise(avg_revenue_per_line = mean(Revenue, na.rm = TRUE)) %>%
  arrange(desc(avg_revenue_per_line)) %>%
  slice_head(n = 10)

saveRDS(top_10_revenue_average,
        "data/processed/product_top_10_revenue_average.rds")

# =============================================================================
# SECTION V: ORDER FREQUENCY PERFORMANCE
# =============================================================================

# 5.6 Top 10 Most Frequently Ordered Products
# Measures product penetration across distinct orders
top_10_order_frequency <- enrich_retail_data %>%
  group_by(StockCode, ShortProductLabel) %>%
  summarise(total_orders = n()) %>%
  arrange(desc(total_orders)) %>%
  slice_head(n = 10)

saveRDS(top_10_order_frequency,
        "data/processed/product_top_10_order_frequency.rds")
