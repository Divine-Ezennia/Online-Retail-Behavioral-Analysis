# ============================================================
# STEP 8: CROSS-DIMENSIONAL BUSINESS INTELLIGENCE
# Project: Online Retail Behavioral Analysis
# Description: Multi-dimensional interrogation of product
#              performance across Temporal and Country axes.
# Data Dependencies:
#   Input:  data/processed/online_retail_enriched.rds
#   Output: Individual cross-dimensional metric RDS tables
# ============================================================

# LOAD REQUIRED LIBRARIES
library(tidyverse)

# LOAD ENRICHED DATA
enrich_retail_data <- readRDS("data/processed/online_retail_enriched.rds")

# =============================================================================
# 8.1 HOURLY — QUANTITY (TOTAL)
# =============================================================================
# Identifies top 2 hourly products by total unit demand
product_hour_total_quantity <- enrich_retail_data %>%
  group_by(Hour, StockCode, ShortProductLabel) %>%
  summarise(total_quantity = sum(Quantity, na.rm = TRUE),
            .groups = "drop") %>%
  group_by(Hour) %>%
  slice_max(order_by = total_quantity, n = 2, with_ties = FALSE) %>%
  arrange(desc(total_quantity)) %>%
  ungroup()

saveRDS(product_hour_total_quantity,
        "data/processed/cross_product_hour_total_quantity.rds")

# =============================================================================
# 8.2 HOURLY — QUANTITY (AVERAGE)
# =============================================================================
# Measures hourly purchasing intensity leaders
product_hour_avg_quantity <- enrich_retail_data %>%
  group_by(Hour, StockCode, ShortProductLabel) %>%
  summarise(avg_quantity = round(mean(Quantity, na.rm = TRUE), 2),
            .groups = "drop") %>%
  group_by(Hour) %>%
  slice_max(order_by = avg_quantity, n = 2, with_ties = FALSE) %>%
  arrange(desc(avg_quantity)) %>%
  ungroup()

saveRDS(product_hour_avg_quantity,
        "data/processed/cross_product_hour_avg_quantity.rds")

# =============================================================================
# 8.3 WEEKPART — QUANTITY (TOTAL)
# =============================================================================
# Identifies dominant weekday/weekend unit drivers
product_weekpart_total_quantity <- enrich_retail_data %>%
  group_by(WeekPart, StockCode, ShortProductLabel) %>%
  summarise(total_quantity = sum(Quantity, na.rm = TRUE),
            .groups = "drop") %>%
  group_by(WeekPart) %>%
  slice_max(order_by = total_quantity, n = 2, with_ties = FALSE) %>%
  arrange(desc(total_quantity)) %>%
  ungroup()

saveRDS(product_weekpart_total_quantity,
        "data/processed/cross_product_weekpart_total_quantity.rds")

# =============================================================================
# 8.4 WEEKPART — QUANTITY (AVERAGE)
# =============================================================================
# Evaluates weekly purchasing intensity per product
product_weekpart_avg_quantity <- enrich_retail_data %>%
  group_by(WeekPart, StockCode, ShortProductLabel) %>%
  summarise(avg_quantity = round(mean(Quantity, na.rm = TRUE), 2),
            .groups = "drop") %>%
  group_by(WeekPart) %>%
  slice_max(order_by = avg_quantity, n = 2, with_ties = FALSE) %>%
  arrange(desc(avg_quantity)) %>%
  ungroup()

saveRDS(product_weekpart_avg_quantity,
        "data/processed/cross_product_weekpart_avg_quantity.rds")

# =============================================================================
# 8.5 MONTH — QUANTITY (TOTAL)
# =============================================================================
# Identifies seasonal leaders by total quantity sold
product_month_total_quantity <- enrich_retail_data %>% 
  mutate(Month = factor(Month, levels = c('January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'),
                        ordered = TRUE)) %>%
  group_by(Month, StockCode, ShortProductLabel) %>%
  summarise(total_quantity = sum(Quantity, na.rm = TRUE),
            .groups = "drop") %>%
  group_by(Month) %>%
  slice_max(order_by = total_quantity, n = 2, with_ties = FALSE) %>%
  arrange(desc(total_quantity)) %>%
  ungroup()

saveRDS(product_month_total_quantity,
        "data/processed/cross_product_month_total_quantity.rds")

# =============================================================================
# 8.6 MONTH — QUANTITY (AVERAGE)
# =============================================================================
# Measures seasonal purchasing intensity
product_month_avg_quantity <- enrich_retail_data  %>% 
  mutate(Month = factor(Month, levels = c('January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'),
                        ordered = TRUE)) %>%
  group_by(Month, StockCode, ShortProductLabel) %>%
  summarise(avg_quantity = round(mean(Quantity, na.rm = TRUE), 2),
            .groups = "drop") %>%
  group_by(Month) %>%
  slice_max(order_by = avg_quantity, n = 2, with_ties = FALSE) %>%
  arrange(desc(avg_quantity)) %>%
  ungroup()

saveRDS(product_month_avg_quantity,
        "data/processed/cross_product_month_avg_quantity.rds")

# =============================================================================
# 8.7 DAILY — REVENUE (TOTAL)
# =============================================================================
# Identifies strongest daily monetary contributors
product_day_total_revenue <- enrich_retail_data %>%   
  mutate(Day = factor(Day, levels = c('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'),
                      ordered = TRUE)) %>%
  group_by(Day, StockCode, ShortProductLabel) %>%
  summarise(total_revenue = sum(Revenue, na.rm = TRUE),
            .groups = "drop") %>%
  group_by(Day) %>%
  slice_max(order_by = total_revenue, n = 2, with_ties = FALSE) %>%
  arrange(desc(total_revenue)) %>%
  ungroup()

saveRDS(product_day_total_revenue,
        "data/processed/cross_product_day_total_revenue.rds")

# =============================================================================
# 8.8 DAILY — REVENUE (AVERAGE)
# =============================================================================
# Measures daily revenue efficiency leaders
product_day_avg_revenue <- enrich_retail_data %>%  
  mutate(Day = factor(Day, levels = c('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'),
                      ordered = TRUE)) %>%
  group_by(Day, StockCode, ShortProductLabel) %>%
  summarise(avg_revenue = round(mean(Revenue, na.rm = TRUE), 2),
            .groups = "drop") %>%
  group_by(Day) %>%
  slice_max(order_by = avg_revenue, n = 2, with_ties = FALSE) %>%
  arrange(desc(avg_revenue)) %>%
  ungroup()

saveRDS(product_day_avg_revenue,
        "data/processed/cross_product_day_avg_revenue.rds")

# =============================================================================
# 8.9 WEEKPART — REVENUE (TOTAL)
# =============================================================================
# Identifies top weekly revenue-driving products
product_weekpart_total_revenue <- enrich_retail_data %>%
  group_by(WeekPart, StockCode, ShortProductLabel) %>%
  summarise(total_revenue = sum(Revenue, na.rm = TRUE),
            .groups = "drop") %>%
  group_by(WeekPart) %>%
  slice_max(order_by = total_revenue, n = 2, with_ties = FALSE) %>%
  arrange(desc(TotalRevenue)) %>%
  ungroup()

saveRDS(product_weekpart_total_revenue,
        "data/processed/cross_product_weekpart_total_revenue.rds")

# =============================================================================
# 8.10 WEEKPART — REVENUE (AVERAGE)
# =============================================================================
# Evaluates weekly revenue efficiency per product
product_weekpart_avg_revenue <- enrich_retail_data %>%
  group_by(WeekPart, StockCode, ShortProductLabel) %>%
  summarise(avg_revenue = round(mean(Revenue, na.rm = TRUE), 2),
            .groups = "drop") %>%
  group_by(WeekPart) %>%
  slice_max(order_by = avg_revenue, n = 2, with_ties = FALSE) %>%
  arrange(desc(avg_revenue)) %>%
  ungroup()

saveRDS(product_weekpart_avg_revenue,
        "data/processed/cross_product_weekpart_avg_revenue.rds")

# =============================================================================
# 8.11 MONTH — REVENUE (TOTAL)
# =============================================================================
# Identifies seasonal revenue leaders
product_month_total_revenue <- enrich_retail_data %>%  
  mutate(Month = factor(Month, levels = c('January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'),
                        ordered = TRUE)) %>%
  group_by(Month, StockCode, ShortProductLabel) %>%
  summarise(total_revenue = sum(Revenue, na.rm = TRUE),
            .groups = "drop") %>%
  group_by(Month) %>%
  slice_max(order_by = total_revenue, n = 2, with_ties = FALSE) %>%
  arrange(desc(total_revenue)) %>%
  ungroup()

saveRDS(product_month_total_revenue,
        "data/processed/cross_product_month_total_revenue.rds")

# =============================================================================
# 8.12 MONTH — REVENUE (AVERAGE)
# =============================================================================
# Measures seasonal revenue efficiency
product_month_avg_revenue <- enrich_retail_data %>%   
  mutate(Month = factor(Month, levels = c('January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'),
                        ordered = TRUE)) %>%
  group_by(Month, StockCode, ShortProductLabel) %>%
  summarise(avg_revenue = round(mean(Revenue, na.rm = TRUE), 2),
            .groups = "drop") %>%
  group_by(Month) %>%
  slice_max(order_by = avg_revenue, n = 2, with_ties = FALSE) %>%
  arrange(desc(avg_revenue)) %>%
  ungroup()

saveRDS(product_month_avg_revenue,
        "data/processed/cross_product_month_avg_revenue.rds")

# =============================================================================
# 8.13–8.16 PROCESSED ORDER
# =============================================================================
# Identifies products generating highest transactional processing volume

product_hour_order_line_count <- enrich_retail_data %>%
  group_by(Hour, StockCode, ShortProductLabel) %>%
  summarise(total_order_lines = n(),
            .groups = "drop") %>%
  group_by(Hour) %>%
  slice_max(order_by = total_order_lines, n = 2, with_ties = FALSE) %>%
  arrange(desc(total_order_lines)) %>%
  ungroup()
saveRDS(product_hour_order_line_count, "data/processed/cross_product_hour_order_line_count.rds")

product_day_order_line_count <- enrich_retail_data %>%    
  mutate(Day = factor(Day, levels = c('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'),
                      ordered = TRUE)) %>%
  group_by(Day, StockCode, ShortProductLabel) %>%
  summarise(total_order_lines = n(),
            .groups = "drop") %>%
  group_by(Day) %>%
  slice_max(order_by = total_order_lines, n = 2, with_ties = FALSE) %>%
  arrange(desc(total_order_lines)) %>%
  ungroup()
saveRDS(product_day_order_line_count, "data/processed/cross_product_day_order_line_count.rds")

product_weekpart_order_line_count <- enrich_retail_data %>%
  group_by(WeekPart, StockCode, ShortProductLabel) %>%
  summarise(total_order_lines = n(),
            .groups = "drop") %>%
  group_by(WeekPart) %>%
  slice_max(order_by = total_order_lines, n = 2, with_ties = FALSE) %>%
  arrange(desc(total_order_lines)) %>%
  ungroup()
saveRDS(product_weekpart_order_line_count, "data/processed/cross_product_weekpart_order_line_count.rds")

product_month_order_line_count <- enrich_retail_data %>%
  group_by(Month, StockCode, ShortProductLabel) %>%
  summarise(total_order_lines = n(),
            .groups = "drop") %>%
  group_by(Month) %>%
  slice_max(order_by = total_order_lines, n = 2, with_ties = FALSE) %>%
  arrange(desc(total_order_lines)) %>%
  ungroup()
saveRDS(product_month_order_line_count, "data/processed/cross_product_month_order_line_count.rds")

# =============================================================================
# 8.17 TOP 2 PRODUCTS IN TOP QUANTITY COUNTRIES (TOTAL QUANTITY)
# =============================================================================
# Identifies dominant products driving volume within strongest demand markets
country_product_total_quantity <- enrich_retail_data %>%
  filter(Country %in% top_10_countries_total_quantity$Country) %>%
  group_by(Country, StockCode, ShortProductLabel) %>%
  summarise(total_quantity = sum(Quantity, na.rm = TRUE),
            .groups = "drop") %>%
  group_by(Country) %>%
  slice_max(order_by = total_quantity, n = 2, with_ties = FALSE) %>%
  arrange(desc(total_quantity)) %>%
  ungroup()

saveRDS(country_product_total_quantity,
        "data/processed/cross_country_product_total_quantity.rds")

# =============================================================================
# 8.18 TOP 2 PRODUCTS IN TOP QUANTITY COUNTRIES (AVERAGE QUANTITY)
# =============================================================================
# Measures product-level purchasing intensity within top demand markets
country_product_avg_quantity <- enrich_retail_data %>%
  filter(Country %in% top_10_countries_avg_quantity$Country) %>%
  group_by(Country, StockCode, ShortProductLabel) %>%
  summarise(avg_quantity = round(mean(Quantity, na.rm = TRUE), 2),
            .groups = "drop") %>%
  group_by(Country) %>%
  slice_max(order_by = avg_quantity, n = 2, with_ties = FALSE) %>%
  arrange(desc(avg_quantity)) %>%
  ungroup()

saveRDS(country_product_avg_quantity,
        "data/processed/cross_country_product_avg_quantity.rds")

# =============================================================================
# 8.19 TOP 2 PRODUCTS IN TOP REVENUE COUNTRIES (TOTAL REVENUE)
# =============================================================================
# Identifies dominant revenue-driving products within strongest monetary markets
country_product_total_revenue <- enrich_retail_data %>%
  filter(Country %in% top_10_countries_total_revenue$Country) %>%
  group_by(Country, StockCode, ShortProductLabel) %>%
  summarise(total_revenue = sum(Revenue, na.rm = TRUE),
            .groups = "drop") %>%
  group_by(Country) %>%
  slice_max(order_by = total_revenue, n = 2, with_ties = FALSE) %>%
  arrange(desc(total_revenue)) %>%
  ungroup()

saveRDS(country_product_total_revenue,
        "data/processed/cross_country_product_total_revenue.rds")


# =============================================================================
# 8.20 TOP 2 PRODUCTS IN TOP REVENUE COUNTRIES (AVERAGE REVENUE)
# =============================================================================
# Measures product-level revenue efficiency within top monetary markets
country_product_avg_revenue <- enrich_retail_data %>%
  filter(Country %in% top_10_countries_avg_revenue$Country) %>%
  group_by(Country, StockCode, ShortProductLabel) %>%
  summarise(avg_revenue = round(mean(Revenue, na.rm = TRUE), 2),
            .groups = "drop") %>%
  group_by(Country) %>%
  slice_max(order_by = avg_revenue, n = 2, with_ties = FALSE) %>%
  arrange(desc(avg_revenue)) %>%
  ungroup()

saveRDS(country_product_avg_revenue,
        "data/processed/cross_country_product_avg_revenue.rds")

# =============================================================================
# 8.21 TOP 2 PRODUCTS IN TOP ORDER COUNTRIES (ORDER LINE COUNT)
# =============================================================================
# Identifies products generating highest transactional processing volume within busiest markets
country_product_order_line_count <- enrich_retail_data %>%
  filter(Country %in% top_10_countries_total_orders$Country) %>%
  group_by(Country, StockCode, ShortProductLabel) %>%
  summarise(total_order_lines = n(),
            .groups = "drop") %>%
  group_by(Country) %>%
  slice_max(order_by = total_order_lines, n = 2, with_ties = FALSE) %>%
  arrange(desc(total_order_lines)) %>%
  ungroup()

saveRDS(country_product_order_line_count,
        "data/processed/cross_country_product_order_line_count.rds")
