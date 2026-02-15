# ============================================================
# STEP 3: FEATURE ENGINEERING & DATA ENRICHMENT
# Description: Augment cleaned transactional dataset with 
#              derived temporal, revenue, and product-label 
#              features to support downstream segmentation 
#              and analytical layers.
#Data Dependencies:
#   Input:  data/processed/online_retail_cleaned.rds
#   Output: data/processed/online_retail_enriched.rds
#           data/processed/product_mapping_table.rds
# ============================================================

# LOAD REQUIRED LIBRARIES
library(tidyverse)
library(lubridate)
library(stringr)

# LOAD CLEANED DATA
clean_retail_data <- readRDS("data/processed/online_retail_cleaned.rds")

# FEATURE ENGINEERING PIPELINE
enrich_retail_data <- clean_retail_data %>% 
  mutate(
    
    # Temporal Features
    Hour = hour(InvoiceDate),
    Day = format(InvoiceDate, "%A"),
    WeekPart = if_else(
      format(InvoiceDate, "%A") %in% c("Saturday", "Sunday"),
      "Weekend",
      "Weekday"
    ),
    Month = format(InvoiceDate, "%B"),
    
    # Revenue Calculation
    Revenue = Quantity * UnitPrice,
    
    # Clean & Simplify Description
    CleanedDesc = Description %>% 
      str_to_sentence() %>% 
      str_replace_all("^[[:punct:]]+|[[:punct:]]+$", "") %>% 
      str_replace_all("[[:punct:]]+", " ") %>% 
      str_remove_all(
        regex(
          "\\b(set|pack|size|of|the|premium|fresh|organic|bottle|carton|sachet|packet|brand|assorted|jumbo|large|medium|small|retrospot|design|pantry|bag)\\b",
          ignore_case = TRUE
        )
      ) %>% 
      str_remove_all("\\b(?<![a-zA-Z])[0-9]+\\b") %>% 
      str_squish(),
    
    # Derive Short Product Label
    ShortProductLabel = word(CleanedDesc, 1, 3),
    
    # Handle Null / Empty Labels
    ShortProductLabel = case_when(
      str_trim(ShortProductLabel) != "" ~ ShortProductLabel,
      Description == "Missing Description" ~ paste0("Item", StockCode),
      str_trim(Description) != "" ~ Description,
      TRUE ~ paste0("Item", StockCode)
    )
 ) %>% 
  
  # Column Reordering
  relocate(Hour, Day, WeekPart, Month, .after = InvoiceDate) %>% 
  relocate(Revenue, .after = UnitPrice) %>% 
  relocate(ShortProductLabel, .after = Description)

# CREATE PRODUCT MAPPING TABLE
mapping_table <- enrich_retail_data %>% 
  select(ShortProductLabel, Description) %>% 
  distinct()

# SAVE ENRICHED DATASETS
saveRDS(enrich_retail_data, "data/processed/online_retail_enriched.rds")
saveRDS(mapping_table, "data/processed/product_mapping_table.rds")
