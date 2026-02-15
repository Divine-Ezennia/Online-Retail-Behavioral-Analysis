# ============================================================
# STEP 4: FOUNDATIONAL METRICS & DATA VALIDATION
# Project: Online Retail Behavioral Analysis
# Description: Establish baseline structural metrics from the
#              enriched transactional dataset to validate
#              analytical scope and inventory scale.
# Data Dependencies:
#   Input:  data/processed/online_retail_enriched.rds
#   Output: Individual foundational metric RDS tables
# ============================================================

# LOAD REQUIRED LIBRARIES
library(tidyverse)

# LOAD ENRICHED DATA
enrich_retail_data <- readRDS("data/processed/online_retail_enriched.rds")

# =============================================================================
# SECTION I: STRUCTURAL VALIDATION METRICS
# =============================================================================

# 4.1 Total Orders
# Validating number of unique transaction invoices in dataset
total_orders <- enrich_retail_data %>%
  summarise(total_orders = n_distinct(InvoiceNo))

# 4.2 Total Order Lines
# Validating number of individual transaction rows (line-level records)
total_order_lines <- enrich_retail_data %>%
  summarise(total_order_lines = n())

# 4.3 Total Unique Products
# Identifying breadth of merchandise diversity post-cleaning
total_unique_products <- enrich_retail_data %>%
  summarise(total_unique_products = n_distinct(StockCode))

# PERSIST FOUNDATIONAL METRICS
saveRDS(total_orders,
        "data/processed/metrics_total_orders.rds")

saveRDS(total_order_lines,
        "data/processed/metrics_total_order_lines.rds")

saveRDS(total_unique_products,
        "data/processed/metrics_total_unique_products.rds")
