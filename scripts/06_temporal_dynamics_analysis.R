# ============================================================
# STEP 6: TEMPORAL PURCHASING & ORDER DYNAMICS ANALYSIS
# Project: Online Retail Behavioral Analysis
# Description: Evaluate transactional behavior across engineered
#              temporal dimensions (Hour, Day, WeekPart, Month).
#              Metrics are isolated by analytical intent.
# Data Dependencies:
#   Input:  data/processed/online_retail_enriched.rds
#   Output: Individual temporal metric RDS tables
# ============================================================

# LOAD REQUIRED LIBRARIES
library(tidyverse)

# LOAD ENRICHED DATA
enrich_retail_data <- readRDS("data/processed/online_retail_enriched.rds")

# =============================================================================
# SECTION I: HOUR-LEVEL ANALYSIS
# =============================================================================

# 6.1 Total Quantity by Hour
# Identifies peak unit-movement windows within the 24-hour cycle
hour_total_quantity <- enrich_retail_data %>%
  group_by(Hour) %>%
  summarise(total_quantity = sum(Quantity, na.rm = TRUE),
            .groups = "drop") %>%
  arrange(desc(total_quantity))

saveRDS(hour_total_quantity,
        "data/processed/temporal_hour_total_quantity.rds")

# 6.2 Average Quantity by Hour
# Measures intensity of item movement per transaction
hour_avg_quantity <- enrich_retail_data %>%
  group_by(Hour) %>%
  summarise(avg_quantity = round(mean(Quantity, na.rm = TRUE), 2),
            .groups = "drop") %>%
  arrange(desc(avg_quantity))
saveRDS(hour_avg_quantity,
        "data/processed/temporal_hour_avg_quantity.rds")

# 6.3 Processed Order Count by Hour
# Evaluates distinct transaction throughput
hour_total_orders <- enrich_retail_data %>%
  group_by(Hour) %>%
  summarise(total_orders = n_distinct(InvoiceNo),
            .groups = "drop") %>%
  arrange(desc(total_orders))

saveRDS(hour_total_orders,
        "data/processed/temporal_hour_total_orders.rds")

# 6.4 Processed Order Line Count by Hour
# Measures transactional processing intensity
hour_total_order_lines <- enrich_retail_data %>%
  group_by(Hour) %>%
  summarise(total_order_lines = n(),
            .groups = "drop") %>%
  arrange(desc(total_order_lines))

saveRDS(hour_total_order_lines,
        "data/processed/temporal_hour_total_order_lines.rds")

# =============================================================================
# SECTION II: DAY-LEVEL ANALYSIS
# =============================================================================

# 6.5 Total Quantity by Day
# Identifies strongest product movement days
day_total_quantity <- enrich_retail_data %>%
  mutate(Day = factor(Day, levels = c('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'),
                      ordered = TRUE)) %>%
  group_by(Day) %>%
  summarise(total_quantity = sum(Quantity, na.rm = TRUE),
            .groups = "drop") %>%
  arrange(desc(total_quantity))

saveRDS(day_total_quantity,
        "data/processed/temporal_day_total_quantity.rds")

# 6.6 Average Quantity by Day
# Evaluates purchasing intensity by weekday
day_avg_quantity <- enrich_retail_data %>% 
  mutate(Day = factor(Day, levels = c('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'),
                      ordered = TRUE)) %>%
  group_by(Day) %>%
  summarise(avg_quantity = round(mean(Quantity, na.rm = TRUE), 2),
            .groups = "drop") %>%
  arrange(desc(avg_quantity))

saveRDS(day_avg_quantity,
        "data/processed/temporal_day_avg_quantity.rds")

# 6.7 Total Revenue by Day
# Determines highest revenue-generating days
day_total_revenue <- enrich_retail_data %>%  
  mutate(Day = factor(Day, levels = c('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'),
                      ordered = TRUE)) %>% 
  group_by(Day) %>%
  summarise(total_revenue = sum(Revenue, na.rm = TRUE),
            .groups = "drop") %>%
  arrange(desc(total_revenue))

saveRDS(day_total_revenue,
        "data/processed/temporal_day_total_revenue.rds")

# 6.8 Average Revenue by Day
# Measures monetary efficiency per transaction
day_avg_revenue <- enrich_retail_data %>%   
  mutate(Day = factor(Day, levels = c('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'),
                      ordered = TRUE)) %>%
  group_by(Day) %>%
  summarise(avg_revenue = round(mean(Revenue, na.rm = TRUE), 2),
            .groups = "drop") %>%
  arrange(desc(avg_revenue))

saveRDS(day_avg_revenue,
        "data/processed/temporal_day_avg_revenue.rds")

# 6.9 Processed Order Count by Day
# Identifies busiest transactional days.
day_total_orders <- enrich_retail_data %>%   
  mutate(Day = factor(Day, levels = c('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'),
                      ordered = TRUE)) %>%
  group_by(Day) %>%
  summarise(total_orders = n_distinct(InvoiceNo),
            .groups = "drop") %>%
  arrange(desc(total_orders))

saveRDS(day_total_orders,
        "data/processed/temporal_day_total_orders.rds")

# 6.10 Processed Order Line Count by Day
# Measures transaction line density by day
day_total_order_lines <- enrich_retail_data %>%   
  mutate(Day = factor(Day, levels = c('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'),
                      ordered = TRUE)) %>%
  group_by(Day) %>%
  summarise(total_order_lines = n(),
            .groups = "drop") %>%
  arrange(desc(total_order_lines))

saveRDS(day_total_order_lines,
        "data/processed/temporal_day_total_order_lines.rds")

# =============================================================================
# SECTION III: WEEKPART ANALYSIS
# =============================================================================

# 6.11 Total Quantity by WeekPart
# Compares product movement between weekdays and weekends
weekpart_total_quantity <- enrich_retail_data %>%
  group_by(WeekPart) %>%
  summarise(total_quantity = sum(Quantity, na.rm = TRUE),
            .groups = "drop") %>%
  arrange(desc(total_quantity))

saveRDS(weekpart_total_quantity,
        "data/processed/temporal_weekpart_total_quantity.rds")


# 6.12 Average Quantity by WeekPart
# Evaluates purchasing intensity differences across week segments
weekpart_avg_quantity <- enrich_retail_data %>%
  group_by(WeekPart) %>%
  summarise(avg_quantity = round(mean(Quantity, na.rm = TRUE), 2),
            .groups = "drop") %>%
  arrange(desc(avg_quantity))

saveRDS(weekpart_avg_quantity,
        "data/processed/temporal_weekpart_avg_quantity.rds")


# 6.13 Total Revenue by WeekPart
# Determines which week segment drives higher monetary contribution
weekpart_total_revenue <- enrich_retail_data %>%
  group_by(WeekPart) %>%
  summarise(total_revenue = sum(Revenue, na.rm = TRUE),
            .groups = "drop") %>%
  arrange(desc(total_revenue))

saveRDS(weekpart_total_revenue,
        "data/processed/temporal_weekpart_total_revenue.rds")


# 6.14 Average Revenue by WeekPart
# Measures monetary efficiency per transaction across week segments
weekpart_avg_revenue <- enrich_retail_data %>%
  group_by(WeekPart) %>%
  summarise(avg_revenue = round(mean(Revenue, na.rm = TRUE), 2),
            .groups = "drop") %>%
  arrange(desc(avg_revenue))

saveRDS(weekpart_avg_revenue,
        "data/processed/temporal_weekpart_avg_revenue.rds")


# 6.15 Processed Order Count by WeekPart
# Evaluates transaction throughput by week segment
weekpart_total_orders <- enrich_retail_data %>%
  group_by(WeekPart) %>%
  summarise(total_orders = n_distinct(InvoiceNo),
            .groups = "drop") %>%
  arrange(desc(total_orders))

saveRDS(weekpart_total_orders,
        "data/processed/temporal_weekpart_total_orders.rds")


# 6.16 Processed Order Line Count by WeekPart
# Measures transaction density by week segment
weekpart_total_order_lines <- enrich_retail_data %>%
  group_by(WeekPart) %>%
  summarise(total_order_lines = n(),
            .groups = "drop") %>%
  arrange(desc(total_order_lines))

saveRDS(weekpart_total_order_lines,
        "data/processed/temporal_weekpart_total_order_lines.rds")

# =============================================================================
# SECTION IV: MONTH-LEVEL ANALYSIS
# =============================================================================

# 6.17 Total Quantity by Month
# Identifies seasonal product movement trends
month_total_quantity <- enrich_retail_data %>% 
  mutate(Month = factor(Month, levels = c('January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'),
                        ordered = TRUE)) %>%
  group_by(Month) %>%
  summarise(total_quantity = sum(Quantity, na.rm = TRUE),
            .groups = "drop") %>%
  arrange(desc(total_quantity))

saveRDS(month_total_quantity,
        "data/processed/temporal_month_total_quantity.rds")


# 6.18 Average Quantity by Month
# Evaluates seasonal purchasing intensity
month_avg_quantity <- enrich_retail_data %>% 
  mutate(Month = factor(Month, levels = c('January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'),
                        ordered = TRUE)) %>%
  group_by(Month) %>%
  summarise(avg_quantity = round(mean(Quantity, na.rm = TRUE), 2),
            .groups = "drop") %>%
  arrange(desc(avg_quantity))

saveRDS(month_avg_quantity,
        "data/processed/temporal_month_avg_quantity.rds")


# 6.19 Total Revenue by Month
# Determines peak revenue seasons
month_total_revenue <- enrich_retail_data %>% 
  mutate(Month = factor(Month, levels = c('January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'),
                        ordered = TRUE)) %>%
  group_by(Month) %>%
  summarise(total_revenue = sum(Revenue, na.rm = TRUE),
            .groups = "drop") %>%
  arrange(desc(total_revenue))

saveRDS(month_total_revenue,
        "data/processed/temporal_month_total_revenue.rds")


# 6.20 Average Revenue by Month
# Measures seasonal monetary efficiency
month_avg_revenue <- enrich_retail_data %>% 
  mutate(Month = factor(Month, levels = c('January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'),
                        ordered = TRUE)) %>%
  group_by(Month) %>%
  summarise(avg_revenue = round(mean(Revenue, na.rm = TRUE), 2),
            .groups = "drop") %>%
  arrange(desc(avg_revenue))

saveRDS(month_avg_revenue,
        "data/processed/temporal_month_avg_revenue.rds")


# 6.21 Processed Order Count by Month
# Evaluates seasonal transaction throughput
month_total_orders <- enrich_retail_data %>%  
  mutate(Month = factor(Month, levels = c('January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'),
                        ordered = TRUE)) %>%
  group_by(Month) %>%
  summarise(total_orders = n_distinct(InvoiceNo),
            .groups = "drop") %>%
  arrange(desc(total_orders))

saveRDS(month_total_orders,
        "data/processed/temporal_month_total_orders.rds")


# 6.22 Processed Order Line Count by Month
# Measures transaction density across seasonal periods
month_total_order_lines <- enrich_retail_data %>%  
  mutate(Month = factor(Month, levels = c('January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'),
                        ordered = TRUE)) %>%
  group_by(Month) %>%
  summarise(total_order_lines = n(),
            .groups = "drop") %>%
  arrange(desc(total_order_lines))

saveRDS(month_total_order_lines,
        "data/processed/temporal_month_total_order_lines.rds")
