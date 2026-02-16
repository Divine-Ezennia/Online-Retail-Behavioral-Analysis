# ============================================================
# STEP 7: GEOGRAPHIC DEMAND & REVENUE ANALYSIS
# Project: Online Retail Behavioral Analysis
# Description: Evaluate country-level purchasing performance
#              using quantity, revenue, order, and order-line
#              metrics. This step isolates geographic demand
#              concentration and high-value markets.
# Data Dependencies:
#   Input:  data/processed/online_retail_enriched.rds
#   Output: Individual country-level metric RDS tables
# ============================================================

# LOAD REQUIRED LIBRARIES
library(tidyverse)

# LOAD ENRICHED DATA
enrich_retail_data <- readRDS("data/processed/online_retail_enriched.rds")

# =============================================================================
# SECTION I: QUANTITY PERFORMANCE
# =============================================================================

# 7.1 Top 10 Countries by Total Purchased Quantity
# Identifies strongest bulk-demand markets globally
top_10_countries_total_quantity <- enrich_retail_data %>%
  group_by(Country) %>%
  summarise(total_quantity = sum(Quantity, na.rm = TRUE),
            .groups = "drop") %>%
  arrange(desc(total_quantity)) %>%
  slice_head(n = 10)

saveRDS(top_10_countries_total_quantity,
        "data/processed/country_top_10_total_quantity.rds")

# 7.2 Top 10 Countries by Average Purchased Quantity
# Highlights markets with high per-transaction intensity
top_10_countries_avg_quantity <- enrich_retail_data %>%
  group_by(Country) %>%
  summarise(avg_quantity = round(mean(Quantity, na.rm = TRUE), 2),
            .groups = "drop") %>%
  arrange(desc(avg_quantity)) %>%
  slice_head(n = 10)

saveRDS(top_10_countries_avg_quantity,
        "data/processed/country_top_10_avg_quantity.rds")

# =============================================================================
# SECTION II: REVENUE PERFORMANCE
# =============================================================================

# 7.3 Top 10 Countries by Total Generated Revenue
# Identifies highest revenue-contributing markets
top_10_countries_total_revenue <- enrich_retail_data %>%
  group_by(Country) %>%
  summarise(total_revenue = sum(Revenue, na.rm = TRUE),
            .groups = "drop") %>%
  arrange(desc(total_revenue)) %>%
  slice_head(n = 10)

saveRDS(top_10_countries_total_revenue,
        "data/processed/country_top_10_total_revenue.rds")

# 7.4 Top 10 Countries by Average Revenue
# Measures revenue intensity per transaction across countries
top_10_countries_avg_revenue <- enrich_retail_data %>%
  group_by(Country) %>%
  summarise(avg_revenue = round(mean(Revenue, na.rm = TRUE), 2),
            .groups = "drop") %>%
  arrange(desc(avg_revenue)) %>%
  slice_head(n = 10)

saveRDS(top_10_countries_avg_revenue,
        "data/processed/country_top_10_avg_revenue.rds")

# =============================================================================
# SECTION III: ORDER ACTIVITY
# =============================================================================

# 7.5 Top 10 Countries by Processed Order Count
# Evaluates transaction throughput by geographic market
top_10_countries_total_orders <- enrich_retail_data %>%
  group_by(Country) %>%
  summarise(total_orders = n_distinct(InvoiceNo),
            .groups = "drop") %>%
  arrange(desc(total_orders)) %>%
  slice_head(n = 10)

saveRDS(top_10_countries_total_orders,
        "data/processed/country_top_10_total_orders.rds")

# 7.6 Top 10 Countries by Processed Order Line Count
# Measures transaction density and processing intensity
top_10_countries_total_order_lines <- enrich_retail_data %>%
  group_by(Country) %>%
  summarise(total_order_lines = n(),
            .groups = "drop") %>%
  arrange(desc(total_order_lines)) %>%
  slice_head(n = 10)

saveRDS(top_10_countries_total_order_lines,
        "data/processed/country_top_10_total_order_lines.rds")
