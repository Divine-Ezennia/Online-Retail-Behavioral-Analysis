# ============================================================
# STEP 9: RFM SEGMENTATION ENGINE
# Project: Online Retail Behavioral Analysis
# Description: Constructs the Recency–Frequency–Monetary (RFM)
#              customer scoring framework and assigns behavioral
#              segments based strictly on engineered RFM scores.
# Data Dependencies:
#   Input:  data/processed/online_retail_enriched.rds
#   Output: RFM scored customer table (RDS)
# ============================================================

# LOAD REQUIRED LIBRARIES
library(tidyverse)

# LOAD ENRICHED DATA
enrich_retail_data <- readRDS("data/processed/online_retail_enriched.rds")

# =============================================================================
# 9.1 RFM METRIC COMPUTATION
# =============================================================================
# Establishes foundational behavioral metrics
# (Recency, Frequency, Monetary) required for customer segmentation

rfm_base <- enrich_retail_data %>%
  mutate(AnalysisDate = max(InvoiceDate)) %>%     # Set RFM reference date
  filter(CustomerID != "Guest") %>%               # Reserve only identified customers
  group_by(CustomerID) %>%
  summarise(
    Recency = max(enrich_retail_data$InvoiceDate) - max(InvoiceDate),  # Days since last purchase
    Frequency = n_distinct(InvoiceNo),                                  # Distinct purchase count
    Monetary = sum(Revenue),                                             # Total spend
    .groups = "drop"
  )

saveRDS(rfm_base,
        "data/processed/rfm_base_metrics.rds")


# =============================================================================
# 9.2 RFM SCORING & SEGMENT CLASSIFICATION
# =============================================================================
# Converts behavioral metrics into standardized
# quintile scores and assigns actionable customer segments

rfm_scored <- rfm_base %>%
  mutate(
    RScore = ntile(-Recency, 5),     # Higher score for lower recency
    FScore = ntile(Frequency, 5),    # Higher score for higher frequency
    MScore = ntile(Monetary, 5),     # Higher score for higher monetary
    RFMScore = RScore + FScore + MScore
  ) %>%
  mutate(
    Segment = case_when(
      RFMScore >= 13 ~ "Champions",
      RFMScore >= 10 ~ "Loyal Customers",
      RFMScore >= 7  ~ "Potential Loyalists",
      RFMScore >= 4  ~ "At Risk",
      TRUE ~ "Lost"
    )
  )

saveRDS(rfm_scored,
        "data/processed/rfm_scored_customers.rds")
