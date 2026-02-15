# ============================================================
# STEP 2: DATA CLEANING & STANDARDIZATION
# Description: Transform raw transactional dataset into a 
#              clean, analysis-ready data frame by resolving 
#              missing values, enforcing business rules, and 
#              filtering non-merchandise transactions.
#Data Dependencies:
#   Input:  data/processed/online_retail_loaded.rds
#   Output: data/processed/online_retail_cleaned.rds
# ============================================================

# LOAD REQUIRED LIBRARIES
library(tidyverse)
library(lubridate)
library(stringr)

# LOAD INPUT DATA
raw_retail_data <- readRDS("data/processed/online_retail_loaded.rds")

# DATA CLEANING PIPELINE

clean_retail_data <- raw_retail_data %>%
  
  # Join with 1-to-1 lookup table (unique StockCode → 1 description)
  left_join(
    raw_retail_data %>%
      filter(!is.na(Description)) %>%
      group_by(StockCode) %>%
      summarize(Description_lookup = first(Description)),
    by = "StockCode"
  ) %>%
  
  # Fill missing descriptions using lookup value
  mutate(Description = coalesce(Description, Description_lookup)) %>%
  select(-Description_lookup) %>%
  
  # Handle missing and malformed values
  mutate(
    CustomerID = if_else(is.na(CustomerID), "Guest", as.character(CustomerID)),
    across(where(is.character), ~na_if(., "?")),
    Description = replace_na(Description, "Missing Description"),
    Description = str_trim(Description),
    Country = str_trim(Country),
    
    # Enforce correct data types
    Quantity = as.integer(Quantity),
    InvoiceDate = mdy_hm(InvoiceDate)
  ) %>%
  
  # Remove cancellations & invalid quantities
  filter(nchar(trimws(InvoiceNo)) == 6 & Quantity > 0) %>%
  
  # Remove duplicate rows
  distinct() %>%
  
  # Exclude non-merchandise transactions
  filter(
    !str_detect(
      Description,
      regex(
        "POST|MANUAL|BANK|ADJUST|DISCOUNT|SAMPLE|CARRIAGE|AMAZON|VOUCHER|TEST",
        ignore_case = TRUE
      )
    )
  )

# SAVE CLEANED DATASET
saveRDS(clean_retail_data, "data/processed/online_retail_cleaned.rds")
