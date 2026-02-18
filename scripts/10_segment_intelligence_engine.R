# ============================================================
# STEP 10: SEGMENT INTELLIGENCE LAYER
# Project: Online Retail Behavioral Analysis
# Description: Comprehensive segment-level analytical interrogation
#              derived from RFM segmentation outputs.
# Data Dependencies:
#   Input:  data/processed/rfm_scored_customers.rds
#   Output: Independent RDS tables for each insight
# ============================================================

# LOAD REQUIRED LIBRARIES
library(tidyverse)

# LOAD ENRICHED DATA
rfm_scored <- readRDS("data/processed/rfm_scored_customers.rds")

# =============================================================================
# SECTION I: SEGMENT STRUCTURAL METRICS
# =============================================================================

# -----------------------------------------------------------------------------
# 10.1 CUSTOMER SEGMENT DISTRIBUTION
# -----------------------------------------------------------------------------
# Establishes the population weight of each behavioral segment,
# identifying dominant and underrepresented customer groups
segment_customer_distribution <- rfm_scored %>%
  group_by(Segment) %>%
  summarise(
    CustomerCount = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(CustomerCount))

saveRDS(segment_customer_distribution,
        "data/processed/segment_customer_distribution.rds")

# -----------------------------------------------------------------------------
# 10.2 SEGMENT-LEVEL REVENUE DISTRIBUTION
# -----------------------------------------------------------------------------
# Differentiates total financial contribution from per-customer
# spending intensity across segments
segment_revenue_distribution <- rfm_scored %>%
  group_by(Segment) %>%
  summarise(
    TotalRevenue = sum(Monetary, na.rm = TRUE),
    AverageRevenue = round(mean(Monetary, na.rm = TRUE), 2),
    .groups = "drop"
  ) %>%
  arrange(desc(TotalRevenue))

saveRDS(segment_revenue_distribution,
        "data/processed/segment_revenue_distribution.rds")

# -----------------------------------------------------------------------------
# 10.3 SEGMENT-LEVEL ORDER DISTRIBUTION
# -----------------------------------------------------------------------------
# Quantifies transaction engagement concentration by segment,
# revealing behavioral frequency strength
segment_order_distribution <- rfm_scored %>%
  group_by(Segment) %>%
  summarise(
    TotalOrderFrequency = sum(Frequency, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(desc(TotalOrderFrequency))

saveRDS(segment_order_distribution,
        "data/processed/segment_order_distribution.rds")

# =============================================================================
# SECTION II: SEGMENT × PRODUCT INTELLIGENCE
# =============================================================================

# LOAD ENRICHED DATA (Required for Product & Quantity Metrics)
enrich_retail_data <- readRDS("data/processed/online_retail_enriched.rds")

# JOIN SEGMENT LABELS BACK TO TRANSACTIONAL DATA
segment_product_data <- rfm_scored %>%
  select(CustomerID, Segment) %>%
  left_join(enrich_retail_data, by = "CustomerID")

# -----------------------------------------------------------------------------
# 10.4 SEGMENT-WISE TOP BULK PURCHASE PRODUCTS (TOTAL QUANTITY)
# -----------------------------------------------------------------------------
# Identifies dominant high-volume merchandise within each
# behavioral segment, revealing unit-demand concentration
segment_product_total_quantity <- segment_product_data %>%
  group_by(Segment, StockCode, ShortProductLabel) %>%
  summarise(
    TotalQuantity = sum(Quantity, na.rm = TRUE),
    .groups = "drop_last"
  ) %>%
  group_by(Segment) %>%
  slice_max(order_by = TotalQuantity, n = 2, with_ties = FALSE) %>%
  arrange(desc(TotalQuantity)) %>% 
  ungroup()

saveRDS(segment_product_total_quantity,
        "data/processed/segment_product_total_quantity.rds")

# -----------------------------------------------------------------------------
# 10.5 SEGMENT-WISE TOP BULK PURCHASE PRODUCTS (AVERAGE QUANTITY)
# -----------------------------------------------------------------------------
# Measures product-level purchasing intensity within each segment,
# distinguishing bulk behavior from transaction frequency
segment_product_avg_quantity <- segment_product_data %>%
  group_by(Segment, StockCode, ShortProductLabel) %>%
  summarise(
    AverageQuantity = round(mean(Quantity, na.rm = TRUE), 2),
    .groups = "drop_last"
  ) %>%
  group_by(Segment) %>%
  slice_max(order_by = AverageQuantity, n = 2, with_ties = FALSE) %>%
  arrange(desc(AverageQuantity)) %>%
  ungroup()

saveRDS(segment_product_avg_quantity,
        "data/processed/segment_product_avg_quantity.rds")

# -----------------------------------------------------------------------------
# 10.6 SEGMENT-WISE TOP REVENUE GENERATING PRODUCTS (TOTAL REVENUE)
# -----------------------------------------------------------------------------
# Identifies merchandise driving highest monetary contribution
# within each customer segment
segment_product_total_revenue <- segment_product_data %>%
  group_by(Segment, StockCode, ShortProductLabel) %>%
  summarise(
    TotalRevenue = sum(Revenue, na.rm = TRUE),
    .groups = "drop_last"
  ) %>%
  group_by(Segment) %>%
  slice_max(order_by = TotalRevenue, n = 2, with_ties = FALSE) %>%
  arrange(desc(TotalRevenue)) %>%
  ungroup()

saveRDS(segment_product_total_revenue,
        "data/processed/segment_product_total_revenue.rds")

# -----------------------------------------------------------------------------
# 10.7 SEGMENT-WISE TOP REVENUE GENERATING PRODUCTS (AVERAGE REVENUE)
# -----------------------------------------------------------------------------
# Evaluates revenue efficiency per transaction occurrence
# within each behavioral segment
segment_product_avg_revenue <- segment_product_data %>%
  group_by(Segment, StockCode, ShortProductLabel) %>%
  summarise(
    AverageRevenue = round(mean(Revenue, na.rm = TRUE), 2),
    .groups = "drop_last"
  ) %>%
  group_by(Segment) %>%
  slice_max(order_by = AverageRevenue, n = 2, with_ties = FALSE) %>%
  arrange(desc(AverageRevenue)) %>%
  ungroup()

saveRDS(segment_product_avg_revenue,
        "data/processed/segment_product_avg_revenue.rds")

# -----------------------------------------------------------------------------
# 10.8 SEGMENT-WISE TOP FREQUENTLY ORDERED PRODUCTS (DISTINCT ORDER COUNT)
# -----------------------------------------------------------------------------
# Measures product penetration across distinct transactions
# within each segment
segment_product_order_count <- segment_product_data %>%
  group_by(Segment, StockCode, ShortProductLabel) %>%
  summarise(
    TotalOrders = n_distinct(InvoiceNo),
    .groups = "drop_last"
  ) %>%
  group_by(Segment) %>%
  slice_max(order_by = TotalOrders, n = 2, with_ties = FALSE) %>%
  arrange(desc(TotalOrders)) %>%
  ungroup()

saveRDS(segment_product_order_count,
        "data/processed/segment_product_order_count.rds")

# =============================================================================
# SECTION III: SEGMENT × GEOGRAPHIC INTELLIGENCE
# =============================================================================

# -----------------------------------------------------------------------------
# 10.9 SEGMENT-WISE TOP DOMINANT CUSTOMER COUNTRIES
# -----------------------------------------------------------------------------
# Identifies geographic concentration of customer population
# within each behavioral segment, revealing dominant markets
# based strictly on customer density
segment_country_population_dominance <- segment_product_data %>%
  group_by(Segment, Country) %>%
  summarise(
    TotalCustomer = n_distinct(CustomerID),
    .groups = "drop_last"
  ) %>%
  group_by(Segment) %>%
  slice_max(order_by = TotalCustomer, n = 2, with_ties = FALSE) %>%
  arrange(desc(TotalCustomer)) %>%
  ungroup()

saveRDS(segment_country_population_dominance,
        "data/processed/segment_country_population_dominance.rds")

# -----------------------------------------------------------------------------
# 10.10 SEGMENT-WISE TOP HIGH-FREQUENCY CUSTOMER COUNTRIES
# -----------------------------------------------------------------------------
# Identifies countries contributing the highest transaction
# frequency within each segment, highlighting repeat-purchase
# geographic concentration
segment_country_high_frequency <- segment_product_data %>%
  group_by(Segment, Country) %>%
  summarise(
    TotalOrderFrequency = n_distinct(InvoiceNo),
    .groups = "drop_last"
  ) %>%
  group_by(Segment) %>%
  slice_max(order_by = TotalOrderFrequency, n = 2, with_ties = FALSE) %>%
  arrange(desc(TotalOrderFrequency)) %>%
  ungroup()

saveRDS(segment_country_high_frequency,
        "data/processed/segment_country_high_frequency.rds")

# -----------------------------------------------------------------------------
# 10.11 SEGMENT-WISE TOP REVENUE-GENERATING CUSTOMER COUNTRIES (TOTAL REVENUE)
# -----------------------------------------------------------------------------
# Identifies geographic markets contributing the highest
# total monetary value within each segment
segment_country_total_revenue <- segment_product_data %>%
  group_by(Segment, Country) %>%
  summarise(
    TotalRevenue = sum(Revenue, na.rm = TRUE),
    .groups = "drop_last"
  ) %>%
  group_by(Segment) %>%
  slice_max(order_by = TotalRevenue, n = 2, with_ties = FALSE) %>%
  arrange(desc(TotalRevenue)) %>%
  ungroup()

saveRDS(segment_country_total_revenue,
        "data/processed/segment_country_total_revenue.rds")

# -----------------------------------------------------------------------------
# 10.12 SEGMENT-WISE TOP REVENUE-GENERATING CUSTOMER COUNTRIES (AVERAGE REVENUE)
# -----------------------------------------------------------------------------
# Measures revenue efficiency per transaction within each
# geographic market by segment
segment_country_avg_revenue <- segment_product_data %>%
  group_by(Segment, Country) %>%
  summarise(
    AverageRevenue = round(mean(Revenue, na.rm = TRUE), 2),
    .groups = "drop_last"
  ) %>%
  group_by(Segment) %>%
  slice_max(order_by = AverageRevenue, n = 2, with_ties = FALSE) %>%
  arrange(desc(AverageRevenue)) %>%
  ungroup()

saveRDS(segment_country_avg_revenue,
        "data/processed/segment_country_avg_revenue.rds")

# -----------------------------------------------------------------------------
# 10.13 SEGMENT-WISE TOP BULK PURCHASE CUSTOMER COUNTRIES (TOTAL QUANTITY)
# -----------------------------------------------------------------------------
# Identifies countries driving the largest unit movement
# within each behavioral segment
segment_country_total_quantity <- segment_product_data %>%
  group_by(Segment, Country) %>%
  summarise(
    TotalQuantity = sum(Quantity, na.rm = TRUE),
    .groups = "drop_last"
  ) %>%
  group_by(Segment) %>%
  slice_max(order_by = TotalQuantity, n = 2, with_ties = FALSE) %>%
  arrange(desc(TotalQuantity)) %>%
  ungroup()

saveRDS(segment_country_total_quantity,
        "data/processed/segment_country_total_quantity.rds")

# -----------------------------------------------------------------------------
# 10.14 SEGMENT-WISE TOP BULK PURCHASE CUSTOMER COUNTRIES (AVERAGE QUANTITY)
# -----------------------------------------------------------------------------
# Evaluates per-transaction unit intensity within dominant
# geographic markets per segment
segment_country_avg_quantity <- segment_product_data %>%
  group_by(Segment, Country) %>%
  summarise(
    AverageQuantity = round(mean(Quantity, na.rm = TRUE), 2),
    .groups = "drop_last"
  ) %>%
  group_by(Segment) %>%
  slice_max(order_by = AverageQuantity, n = 2, with_ties = FALSE) %>%
  arrange(desc(AverageQuantity)) %>%
  ungroup()

saveRDS(segment_country_avg_quantity,
        "data/processed/segment_country_avg_quantity.rds")

# =============================================================================
# SECTION IV: SEGMENT-LEVEL EVALUATION METRICS
# =============================================================================

# -----------------------------------------------------------------------------
# 10.15 SEGMENT-LEVEL LIFETIME VALUE EVALUATION
# -----------------------------------------------------------------------------
# Estimates long-term monetary value of customers within each
# segment by incorporating revenue, purchase frequency, and
# engagement lifespan into a unified CLV metric.
rfm_clv <- enrich_retail_data %>%
  filter(CustomerID != "Guest") %>%
  group_by(CustomerID) %>%
  summarise(
    TotalRevenue = sum(Revenue),
    Orders = n_distinct(InvoiceNo),
    AvgOrderValue = TotalRevenue / Orders,
    FirstPurchase = min(InvoiceDate),
    LastPurchase = max(InvoiceDate),
    ActiveDays = as.numeric(LastPurchase - FirstPurchase),
    .groups = "drop"
  ) %>%
  mutate(
    PurchaseFrequency = Orders / ActiveDays,
    AvgCustomerLifespan = mean(ActiveDays, na.rm = TRUE),
    CLV = na_if(AvgOrderValue * PurchaseFrequency * AvgCustomerLifespan, Inf)
  ) %>%
  inner_join(rfm_scored, by = "CustomerID") %>%
  group_by(Segment) %>%
  summarise(
    AverageCLV = round(mean(CLV, na.rm = TRUE), 2),
    .groups = "drop"
  ) %>%
  mutate(AverageCLV = if_else(is.nan(AverageCLV), NA, AverageCLV)) %>%
  drop_na(AverageCLV) %>%
  arrange(desc(AverageCLV))

saveRDS(rfm_clv,
        "data/processed/segment_lifetime_value_evaluation.rds")

# -----------------------------------------------------------------------------
# 10.16 SEGMENT-LEVEL CHURN RATE ASSESSMENT
# -----------------------------------------------------------------------------
# Quantifies attrition risk within each behavioral segment by
# identifying customers inactive beyond a 180-day threshold
rfm_churn_rate <- enrich_retail_data %>%
  mutate(CutOffDate = max(InvoiceDate) - lubridate::days(180)) %>%
  filter(CustomerID != "Guest") %>%
  group_by(CustomerID) %>%
  summarise(
    LastPurchase = max(InvoiceDate),
    .groups = "drop"
  ) %>%
  mutate(
    Status = if_else(
      LastPurchase <= max(enrich_retail_data$InvoiceDate) - lubridate::days(180),
      "Churned",
      "Active"
    )
  ) %>%
  inner_join(rfm_scored, by = "CustomerID") %>%
  count(Segment, Status) %>%
  group_by(Segment) %>%
  mutate(
    Percentage = round(100 * n / sum(n), 2)
  ) %>%
  ungroup() %>%
  arrange(desc(Percentage))

saveRDS(rfm_churn_rate,
        "data/processed/segment_churn_rate_assessment.rds")

# -----------------------------------------------------------------------------
# 10.17 SEGMENT-LEVEL ORDER VALUE EVALUATION
# -----------------------------------------------------------------------------
# Measures purchasing efficiency across segments by calculating
# average revenue per completed order
segment_aov <- enrich_retail_data %>%
  inner_join(rfm_scored, by = "CustomerID") %>%
  group_by(Segment, InvoiceNo) %>%
  summarise(
    OrderTotal = sum(Revenue),
    .groups = "drop"
  ) %>%
  group_by(Segment) %>%
  summarise(
    TotalRevenue = sum(OrderTotal),
    TotalOrders = n(),
    .groups = "drop"
  ) %>%
  mutate(
    AverageOrderValue = round(TotalRevenue / TotalOrders, 2)
  ) %>%
  arrange(desc(AverageOrderValue))

saveRDS(segment_aov,
        "data/processed/segment_order_value_evaluation.rds")
