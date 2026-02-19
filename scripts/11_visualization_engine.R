# ============================================================
# STEP 11: VISUALIZATION ENGINE
# Project: Online Retail Behavioral Analysis
# Description: This script generates all R-based visual outputs derived
#              strictly from processed analytical RDS files.
# Upstream Dependencies:
#   STEP 05 – Product Performance Analysis
#   STEP 06 – Temporal Analysis
#   STEP 07 – Geographic Country Analysis
#   STEP 08 – Cross-Dimensional Intelligence
#   STEP 09 – RFM Segmentation Engine
#   STEP 10 – Segment Intelligence Engine
# Output:
#   PNG files saved under visualizations/ subfolders
# ============================================================

# LOAD REQUIRED LIBRARIES
library(tidyverse)
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)
library(ggrepel)

# ============================================================
# SECTION I: PRODUCT PERFORMANCE VISUALS
# ============================================================

# 11.1 Top 10 Bulk Purchased Products (Total Quantity)
# Identifies highest unit-movement merchandise

top_10_quantity_volume <- readRDS(
  "data/processed/product_top_10_quantity_volume.rds"
)

fig_11_1 <- ggplot(
  top_10_quantity_volume,
  aes(
    x = ShortProductLabel,
    y = total_quantity,
    fill = ShortProductLabel
  )
) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  scale_x_discrete(guide = guide_axis(angle = 45)) +
  labs(
    title = "Top 10 Bulk Purchased Product",
    x = "Short Product Label",
    y = "Total Unit Sold"
  )

ggsave(
  "visualizations/product/fig_11_1_top_bulk_quantity.png",
  fig_11_1,
  width = 10,
  height = 6,
  dpi = 300
)

# 11.2 Top 10 Products by Average Quantity Purchased
# Measures product intensity per transaction occurrence

top_10_quantity_average <- readRDS(
  "data/processed/product_top_10_quantity_average.rds"
)

fig_11_2 <- ggplot(
  top_10_quantity_average,
  aes(
    x = ShortProductLabel,
    y = avg_quantity_per_line,
    fill = ShortProductLabel
  )
) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  scale_x_discrete(guide = guide_axis(angle = 45)) +
  labs(
    title = "Top 10 Products by Average Quantity Purchased",
    x = "Short Product Label",
    y = "Average Unit Sold"
  )

ggsave(
  "visualizations/product/fig_11_2_top_avg_quantity.png",
  fig_11_2,
  width = 10,
  height = 6,
  dpi = 300
)

# 11.3 Top 10 Revenue-Generating Products (Total Revenue)
# Identifies highest monetary contributors

top_10_revenue_volume <- readRDS(
  "data/processed/product_top_10_revenue_volume.rds"
)

fig_11_3 <- ggplot(
  top_10_revenue_volume,
  aes(
    x = ShortProductLabel,
    y = total_revenue,
    fill = ShortProductLabel
  )
) +
  geom_col() +
  theme_minimal() +
  scale_x_discrete(guide = guide_axis(angle = 45)) +
  labs(
    title = "Top 10 Revenue-Generating Products",
    x = "Short Product Label",
    y = "Total Revenue (£)"
  )

ggsave(
  "visualizations/product/fig_11_3_top_total_revenue.png",
  fig_11_3,
  width = 10,
  height = 6,
  dpi = 300
)

# 11.4 Top 10 Products by Average Revenue Generated
# Evaluates per-transaction monetary efficiency

top_10_revenue_average <- readRDS(
  "data/processed/product_top_10_revenue_average.rds"
)

fig_11_4 <- ggplot(
  top_10_revenue_average,
  aes(
    x = ShortProductLabel,
    y = avg_revenue_per_line,
    fill = ShortProductLabel
  )
) +
  geom_col() +
  theme_minimal() +
  scale_x_discrete(guide = guide_axis(angle = 45)) +
  labs(
    title = "Top 10 Products by Average Revenue Generated",
    x = "Short Product Label",
    y = "Average Revenue (£)"
  )

ggsave(
  "visualizations/product/fig_11_4_top_avg_revenue.png",
  fig_11_4,
  width = 10,
  height = 6,
  dpi = 300
)

# 11.5 Top 10 Most Frequently Ordered Products
# Measures product penetration across processed transactions

top_10_order_frequency <- readRDS(
  "data/processed/product_top_10_order_frequency.rds"
)

fig_11_5 <- ggplot(
  top_10_order_frequency,
  aes(
    x = ShortProductLabel,
    y = total_orders,
    fill = ShortProductLabel
  )
) +
  geom_col() +
  theme_minimal() +
  scale_x_discrete(guide = guide_axis(angle = 45)) +
  labs(
    title = "Top 10 Most Frequently Ordered Products",
    x = "Short Product Label",
    y = "Order Frequency"
  )

ggsave(
  "visualizations/product/fig_11_5_top_order_frequency.png",
  fig_11_5,
  width = 10,
  height = 6,
  dpi = 300
)

# ============================================================
# SECTION II: TEMPORAL DYNAMICS VISUALS
# ============================================================


# ============================================================
# SUBSECTION I: HOUR-LEVEL VISUALS
# ============================================================

# 11.6 Total Purchased Quantity by Hour of Day
# Identifies peak unit-movement windows within the 24-hour cycle

hour_total_quantity <- readRDS(
  "data/processed/temporal_hour_total_quantity.rds"
)

fig_11_6 <- ggplot(
  hour_total_quantity %>%
    mutate(HighlightPoints = Hour %in% c(6, 10, 12, 20)),
  aes(x = Hour, y = total_quantity)
) +
  geom_line(color = "purple") +
  geom_label_repel(
    data = ~ dplyr::filter(.x, HighlightPoints),
    aes(label = paste0(scales::comma(total_quantity))),
    nudge_x = c(-0.5, 0.5),
    nudge_y = c(73000, 73000),
    fill = "white",
    color = "black",
    fontface = "bold",
    label.size = 0.5,
    segment.color = "black",
    segment.size = 0.6,
    size = 4,
    direction = "both",
    force = 2,
    box.padding = unit(0.5, "lines"),
    point.padding = unit(0.5, "lines")
  ) +
  scale_y_continuous(labels = scales::comma) +
  scale_x_continuous(breaks = 0:23) +
  labs(
    title = "Total Purchased Quantity by Hour of Day",
    x = "Hour of Day",
    y = "Total Quantity"
  ) +
  theme_minimal()

ggsave(
  "visualizations/temporal/fig_11_6_total_quantity_by_hour.png",
  fig_11_6,
  width = 10,
  height = 6,
  dpi = 300
)

# 11.7 Average Purchased Quantity by Hour of Day
# Measures intensity of item movement per transaction

hour_avg_quantity <- readRDS(
  "data/processed/temporal_hour_avg_quantity.rds"
)

fig_11_7 <- ggplot(
  hour_avg_quantity %>%
    mutate(TextLabel = if_else(Hour %in% c(6, 7, 20),
                               paste0(avg_quantity), NA)),
  aes(x = Hour, y = avg_quantity)
) +
  geom_line(color = "purple") +
  geom_label_repel(
    aes(label = TextLabel),
    na.rm = TRUE,
    nudge_x = c(-0.5, 0.5),
    nudge_y = c(5, 5),
    fill = "white",
    color = "black",
    fontface = "bold",
    label.size = 0.5,
    segment.color = "black",
    segment.size = 0.6,
    size = 4,
    direction = "both",
    force = 2,
    box.padding = unit(0.5, "lines"),
    point.padding = unit(0.5, "lines")
  ) +
  scale_y_continuous(labels = scales::comma) +
  scale_x_continuous(breaks = 0:23) +
  labs(
    title = "Average Purchased Quantity by Hour of Day",
    x = "Hour of Day",
    y = "Average Quantity"
  ) +
  theme_minimal()

ggsave(
  "visualizations/temporal/fig_11_7_avg_quantity_by_hour.png",
  fig_11_7,
  width = 10,
  height = 6,
  dpi = 300
)

# 11.8 Peak Hour for Orders
# Evaluates distinct transaction throughput across the 24-hour cycle

hour_total_orders <- readRDS(
  "data/processed/temporal_hour_total_orders.rds"
)

fig_11_8 <- ggplot(
  hour_total_orders %>%
    mutate(LabelText = if_else(
      Hour %in% c(6, 12, 20),
      paste0(scales::comma(total_orders)),
      NA
    )),
  aes(x = Hour, y = total_orders, group = 1)
) +
  geom_line(color = "royalblue") +
  geom_label_repel(
    aes(label = LabelText),
    na.rm = TRUE,
    nudge_x = c(-0.5, 0.5),
    nudge_y = c(350, 350),
    fill = "white",
    color = "black",
    fontface = "bold",
    label.size = 0.5,
    segment.color = "black",
    segment.size = 0.6,
    size = 4,
    direction = "both",
    force = 2,
    box.padding = unit(0.5, "lines"),
    point.padding = unit(0.5, "lines")
  ) +
  scale_x_continuous(breaks = 0:23) +
  labs(
    title = "Peak Hour for Orders",
    x = "Hour of Day",
    y = "Order Frequency"
  ) +
  theme_minimal()

ggsave(
  "visualizations/temporal/fig_11_8_peak_order_hour.png",
  fig_11_8,
  width = 10,
  height = 6,
  dpi = 300
)

# 11.9 Peak Hour for Order Line Activity
# Measures transactional processing intensity by hour

hour_total_order_lines <- readRDS(
  "data/processed/temporal_hour_total_order_lines.rds"
)

fig_11_9 <- ggplot(
  hour_total_order_lines,
  aes(x = Hour, y = total_order_lines, group = 1)
) +
  geom_line(color = "royalblue") +
  geom_label_repel(
    data = hour_total_order_lines %>%
      filter(Hour %in% c(6, 12, 15, 20)),
    aes(label = paste0(scales::comma(total_order_lines))),
    nudge_x = c(-0.5, 0.5),
    nudge_y = c(8000, 8000),
    fill = "white",
    color = "black",
    fontface = "bold",
    label.size = 0.5,
    segment.color = "black",
    segment.size = 0.6,
    size = 4,
    direction = "both",
    force = 2,
    box.padding = unit(0.5, "lines"),
    point.padding = unit(0.5, "lines")
  ) +
  scale_x_continuous(breaks = 0:23) +
  labs(
    title = "Peak Hour for Order Line Activity",
    x = "Hour of Day",
    y = "Order Line Frequency"
  ) +
  theme_minimal()

ggsave(
  "visualizations/temporal/fig_11_9_peak_orderline_hour.png",
  fig_11_9,
  width = 10,
  height = 6,
  dpi = 300
)

# ============================================================
# SUBSECTION II: DAY-LEVEL VISUALS
# ============================================================

# 11.10 Total Purchased Quantity by Day of Week
# Identifies strongest product movement days

day_total_quantity <- readRDS(
  "data/processed/temporal_day_total_quantity.rds"
)

fig_11_10 <- ggplot(
  day_total_quantity %>%
    mutate(LabelText = if_else(
      Day %in% c("Sunday", "Tuesday", "Thursday"),
      paste0(scales::comma(total_quantity)),
      NA
    )),
  aes(x = Day, y = total_quantity, group = 1)
) +
  geom_line(color = "blue") +
  geom_label_repel(
    aes(label = LabelText),
    na.rm = TRUE,
    nudge_x = c(-0.5, 0.5),
    nudge_y = c(70500, 70500),
    fill = "white",
    color = "black",
    fontface = "bold",
    label.size = 0.5,
    segment.color = "black",
    segment.size = 0.6,
    size = 4,
    direction = "both",
    force = 2,
    box.padding = unit(0.5, "lines"),
    point.padding = unit(0.5, "lines")
  ) +
  scale_y_continuous(labels = scales::comma) +
  labs(
    title = "Total Purchased Quantity by Day of Week",
    x = "Day of Week",
    y = "Total Quantity"
  ) +
  theme_minimal()

ggsave(
  "visualizations/temporal/fig_11_10_total_quantity_by_day.png",
  fig_11_10,
  width = 10,
  height = 6,
  dpi = 300
)

# 11.11 Average Purchased Quantity by Day of Week
# Evaluates purchasing intensity by weekday

day_avg_quantity <- readRDS(
  "data/processed/temporal_day_avg_quantity.rds"
)

fig_11_11 <- ggplot(
  day_avg_quantity %>%
    mutate(LabelText = if_else(
      Day %in% c("Sunday", "Tuesday", "Thursday"),
      paste0(avg_quantity),
      NA
    )),
  aes(x = Day, y = avg_quantity, group = 1)
) +
  geom_line(color = "blue") +
  geom_label_repel(
    aes(label = LabelText),
    na.rm = TRUE,
    nudge_x = c(-0.5, 0.5),
    nudge_y = c(0.5, 0.5),
    fill = "white",
    color = "black",
    fontface = "bold",
    label.size = 0.5,
    segment.color = "black",
    segment.size = 0.6,
    size = 4,
    direction = "both",
    force = 2,
    box.padding = unit(0.5, "lines"),
    point.padding = unit(0.5, "lines")
  ) +
  scale_y_continuous(labels = scales::comma) +
  labs(
    title = "Average Purchased Quantity by Day of Week",
    x = "Day of Week",
    y = "Average Quantity"
  ) +
  theme_minimal()

ggsave(
  "visualizations/temporal/fig_11_11_avg_quantity_by_day.png",
  fig_11_11,
  width = 10,
  height = 6,
  dpi = 300
)

# 11.12 Total Generated-Revenue by Day of Week
# Determines highest revenue-generating days

day_total_revenue <- readRDS(
  "data/processed/temporal_day_total_revenue.rds"
)

fig_11_12 <- ggplot(
  day_total_revenue %>%
    mutate(LabelText = if_else(
      Day %in% c("Sunday", "Tuesday", "Thursday"),
      paste0(scales::comma(total_revenue)),
      NA
    )),
  aes(x = Day, y = total_revenue, group = 1)
) +
  geom_line(color = "seagreen") +
  geom_label_repel(
    aes(label = LabelText),
    na.rm = TRUE,
    nudge_x = c(-0.5, 0.5),
    nudge_y = c(120000, 120000),
    fill = "white",
    color = "black",
    fontface = "bold",
    label.size = 0.5,
    segment.color = "black",
    segment.size = 0.6,
    size = 4,
    direction = "both",
    force = 2,
    box.padding = unit(0.5, "lines"),
    point.padding = unit(0.5, "lines")
  ) +
  scale_y_continuous(labels = scales::comma) +
  labs(
    title = "Total Generated-Revenue by Day of Week",
    x = "Day of Week",
    y = "Total Revenue (£)"
  ) +
  theme_minimal()

ggsave(
  "visualizations/temporal/fig_11_12_total_revenue_by_day.png",
  fig_11_12,
  width = 10,
  height = 6,
  dpi = 300
)

# 11.13 Average Generated-Revenue by Day of Week
# Measures monetary efficiency per transaction by weekday

day_avg_revenue <- readRDS(
  "data/processed/temporal_day_avg_revenue.rds"
)

fig_11_13 <- ggplot(
  day_avg_revenue %>%
    mutate(LabelText = if_else(
      Day %in% c("Sunday", "Tuesday", "Friday"),
      paste0(avg_revenue),
      NA
    )),
  aes(x = Day, y = avg_revenue, group = 1)
) +
  geom_line(color = "seagreen") +
  geom_label_repel(
    aes(label = LabelText),
    na.rm = TRUE,
    nudge_x = c(-0.5, 0.5),
    nudge_y = c(0.8, 0.8),
    fill = "white",
    color = "black",
    fontface = "bold",
    label.size = 0.5,
    segment.color = "black",
    segment.size = 0.6,
    size = 4,
    direction = "both",
    force = 2,
    box.padding = unit(0.5, "lines"),
    point.padding = unit(0.5, "lines")
  ) +
  labs(
    title = "Average Generated-Revenue by Day of Week",
    x = "Day of Week",
    y = "Average Revenue (£)"
  ) +
  theme_minimal()

ggsave(
  "visualizations/temporal/fig_11_13_avg_revenue_by_day.png",
  fig_11_13,
  width = 10,
  height = 6,
  dpi = 300
)

# 11.14 Peak Day for Orders
# Identifies highest distinct transaction throughput by weekday

day_total_orders <- readRDS(
  "data/processed/temporal_day_total_orders.rds"
)

fig_11_14 <- ggplot(
  day_total_orders %>%
    mutate(LabelText = if_else(
      Day %in% c("Sunday", "Thursday"),
      paste0(scales::comma(total_orders)),
      NA
    )),
  aes(x = Day, y = total_orders, group = 1)
) +
  geom_line(color = "green") +
  geom_label_repel(
    aes(label = LabelText),
    na.rm = TRUE,
    nudge_x = c(-0.5, 0.5),
    nudge_y = c(200, 200),
    fill = "white",
    color = "black",
    fontface = "bold",
    label.size = 0.5,
    segment.color = "black",
    segment.size = 0.6,
    size = 4,
    direction = "both",
    force = 2,
    box.padding = unit(0.5, "lines"),
    point.padding = unit(0.5, "lines")
  ) +
  labs(
    title = "Peak Day for Orders",
    x = "Day of Week",
    y = "Order Frequency"
  ) +
  theme_minimal()

ggsave(
  "visualizations/temporal/fig_11_14_total_orders_by_day.png",
  fig_11_14,
  width = 10,
  height = 6,
  dpi = 300
)

# 11.15 Peak Day for Order Line Activity
# Measures transactional processing intensity by weekday

day_total_order_lines <- readRDS(
  "data/processed/temporal_day_total_order_lines.rds"
)

fig_11_15 <- ggplot(
  day_total_order_lines %>%
    mutate(LabelText = if_else(
      Day %in% c("Sunday", "Tuesday", "Thursday"),
      paste0(scales::comma(total_order_lines)),
      NA
    )),
  aes(x = Day, y = total_order_lines, group = 1)
) +
  geom_line(color = "green") +
  geom_label_repel(
    aes(label = LabelText),
    na.rm = TRUE,
    nudge_x = c(-0.5, 0.5),
    nudge_y = c(3500, 3500),
    fill = "white",
    color = "black",
    fontface = "bold",
    label.size = 0.5,
    segment.color = "black",
    segment.size = 0.6,
    size = 4,
    direction = "both",
    force = 2,
    box.padding = unit(0.5, "lines"),
    point.padding = unit(0.5, "lines")
  ) +
  scale_y_continuous(labels = scales::comma) +
  labs(
    title = "Peak Day for Order Line Activity",
    x = "Day of Week",
    y = "Order Line Frequency"
  ) +
  theme_minimal()

ggsave(
  "visualizations/temporal/fig_11_15_total_order_lines_by_day.png",
  fig_11_15,
  width = 10,
  height = 6,
  dpi = 300
)

# ============================================================
# SUBSECTION III: WEEKPART-LEVEL VISUALS
# ============================================================

# 11.16 Product Quantity Distribution between Week Part
# Reveals whether weekday or weekend drives higher unit movement

weekpart_total_quantity <- readRDS(
  "data/processed/temporal_weekpart_total_quantity.rds"
)

fig_11_16 <- ggplot(
  weekpart_total_quantity %>%
    mutate(
      Fraction = total_quantity / sum(total_quantity),
      Ymax = cumsum(Fraction),
      Ymin = c(0, head(Ymax, -1)),
      LabelPosition = (Ymax - Ymin) / 2
    ),
  aes(x = 1, y = Fraction, fill = WeekPart)
) +
  geom_col(width = 1, color = "white") +
  coord_polar(theta = "y") +
  geom_segment(
    aes(
      x = 1.5,
      y = LabelPosition,
      xend = 1.75,
      yend = LabelPosition
    ),
    color = "black",
    linewidth = 0.6
  ) +
  geom_label_repel(
    aes(
      x = 1.7,
      y = LabelPosition,
      label = paste0(round(Fraction * 100, 1), "%")
    ),
    nudge_x = 0.1,
    segment.size = 0.6,
    segment.color = "black",
    fill = "white",
    label.size = 0.5,
    size = 4
  ) +
  labs(
    title = "Product Quantity Distribution between Week Part",
    fill = "WeekPart"
  ) +
  theme_void()

ggsave(
  "visualizations/temporal/fig_11_16_quantity_distribution_weekpart.png",
  fig_11_16,
  width = 8,
  height = 6,
  dpi = 300
)

# 11.17 Revenue Distribution between Week Part
# Compares monetary contribution of weekday vs weekend

weekpart_total_revenue <- readRDS(
  "data/processed/temporal_weekpart_total_revenue.rds"
)

fig_11_17 <- ggplot(
  weekpart_total_revenue %>%
    mutate(
      Fraction = total_revenue / sum(total_revenue),
      Ymax = cumsum(Fraction),
      Ymin = c(0, head(Ymax, -1)),
      LabelPosition = (Ymax - Ymin) / 2
    ),
  aes(x = 1, y = Fraction, fill = WeekPart)
) +
  geom_col(width = 1, color = "white") +
  coord_polar(theta = "y") +
  geom_segment(
    aes(
      x = 1.5,
      y = LabelPosition,
      xend = 1.75,
      yend = LabelPosition
    ),
    color = "black",
    linewidth = 0.6
  ) +
  geom_label_repel(
    aes(
      x = 1.7,
      y = LabelPosition,
      label = paste0(round(Fraction * 100, 1), "%")
    ),
    nudge_x = 0.1,
    segment.size = 0.6,
    segment.color = "black",
    fill = "white",
    label.size = 0.5,
    size = 4
  ) +
  labs(
    title = "Revenue Distribution between Week Part",
    fill = "WeekPart"
  ) +
  theme_void()

ggsave(
  "visualizations/temporal/fig_11_17_revenue_distribution_weekpart.png",
  fig_11_17,
  width = 8,
  height = 6,
  dpi = 300
)

# 11.18 Average Generated-Revenue by Week Part
# Evaluates per-transaction monetary efficiency across week segments

weekpart_avg_revenue <- readRDS(
  "data/processed/temporal_weekpart_avg_revenue.rds"
)

fig_11_18 <- ggplot(
  weekpart_avg_revenue %>%
    mutate(LabelText = paste0(avg_revenue)),
  aes(x = WeekPart, y = avg_revenue, fill = WeekPart)
) +
  geom_bar(stat = "identity", width = 0.2, show.legend = FALSE) +
  geom_label_repel(
    aes(label = LabelText),
    nudge_x = c(-0.25, 0.25),
    nudge_y = c(1, 1),
    fill = "white",
    color = "black",
    fontface = "bold",
    label.size = 0.5,
    segment.color = "black",
    segment.size = 0.5,
    size = 4,
    direction = "both",
    force = 2
  ) +
  labs(
    title = "Average Generated-Revenue by Week Part",
    x = "Week Part",
    y = "Average Revenue (£)"
  ) +
  theme_minimal()

ggsave(
  "visualizations/temporal/fig_11_18_avg_revenue_weekpart.png",
  fig_11_18,
  width = 8,
  height = 6,
  dpi = 300
)

# 11.19 Order Frequency Distribution between Week Part
# Shows transaction share split between weekday and weekend

weekpart_total_orders <- readRDS(
  "data/processed/temporal_weekpart_total_orders.rds"
)

fig_11_19 <- ggplot(
  weekpart_total_orders %>%
    mutate(
      Fraction = total_orders / sum(total_orders),
      Ymax = cumsum(Fraction),
      Ymin = c(0, head(Ymax, -1)),
      LabelPosition = (Ymax - Ymin) / 2
    ),
  aes(x = 1, y = Fraction, fill = WeekPart)
) +
  geom_col(width = 1, color = "white") +
  coord_polar(theta = "y") +
  geom_segment(
    aes(
      x = 1.5,
      y = LabelPosition,
      xend = 1.75,
      yend = LabelPosition
    ),
    color = "black",
    linewidth = 0.6
  ) +
  geom_label_repel(
    aes(
      x = 1.7,
      y = LabelPosition,
      label = paste0(round(Fraction * 100, 1), "%")
    ),
    nudge_x = 0.1,
    segment.size = 0.5,
    segment.color = "black",
    fill = "white",
    label.size = 0.5,
    size = 4
  ) +
  labs(
    title = "Order Frequency Distribution between Week Part",
    fill = "WeekPart"
  ) +
  theme_void()

ggsave(
  "visualizations/temporal/fig_11_19_orders_distribution_weekpart.png",
  fig_11_19,
  width = 8,
  height = 6,
  dpi = 300
)

# 11.20 Order Line Frequency Distribution between Week Part
# Evaluates operational load split between weekday and weekend

weekpart_total_order_lines <- readRDS(
  "data/processed/temporal_weekpart_total_order_lines.rds"
)

fig_11_20 <- ggplot(
  weekpart_total_order_lines %>%
    mutate(
      Fraction = total_order_lines / sum(total_order_lines),
      Ymax = cumsum(Fraction),
      Ymin = c(0, head(Ymax, -1)),
      LabelPosition = (Ymax - Ymin) / 2
    ),
  aes(x = 1, y = Fraction, fill = WeekPart)
) +
  geom_col(width = 1, color = "white") +
  coord_polar(theta = "y") +
  geom_segment(
    aes(
      x = 1.5,
      y = LabelPosition,
      xend = 1.75,
      yend = LabelPosition
    ),
    color = "black",
    linewidth = 0.6
  ) +
  geom_label_repel(
    aes(
      x = 1.7,
      y = LabelPosition,
      label = paste0(round(Fraction * 100, 1), "%")
    ),
    nudge_x = 0.1,
    segment.size = 0.5,
    segment.color = "black",
    fill = "white",
    label.size = 0.5,
    size = 4
  ) +
  labs(
    title = "Order Line Frequency Distribution between Week Part",
    fill = "WeekPart"
  ) +
  theme_void()

ggsave(
  "visualizations/temporal/fig_11_20_orderlines_distribution_weekpart.png",
  fig_11_20,
  width = 8,
  height = 6,
  dpi = 300
)

# ============================================================
# SUBSECTION IV: MONTH-LEVEL VISUALS
# ============================================================

# 11.21 Total Purchased Quantity by Month
# Identifies seasonal peaks in unit movement

month_total_quantity <- readRDS(
  "data/processed/temporal_month_total_quantity.rds"
)

fig_11_21 <- ggplot(
  month_total_quantity %>%
    mutate(
      LabelText = if_else(
        Month %in% c("January", "September", "November"),
        paste0(scales::comma(total_quantity)),
        NA
      )
    ),
  aes(x = Month, y = total_quantity, group = 1)
) +
  geom_line(color = "steelblue") +
  geom_label_repel(
    aes(label = LabelText),
    na.rm = TRUE,
    nudge_x = c(-0.5, 0.5),
    nudge_y = c(70000, 70000),
    fill = "white",
    color = "black",
    fontface = "bold",
    label.size = 0.5,
    segment.color = "black",
    segment.size = 0.6,
    size = 4,
    direction = "both",
    force = 2,
    box.padding = unit(0.5, "lines"),
    point.padding = unit(0.5, "lines")
  ) +
  scale_y_continuous(labels = scales::comma) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45)) +
  labs(
    title = "Total Purchased Quantity by Month",
    x = "Month",
    y = "Total Quantity"
  )

ggsave(
  "visualizations/temporal/fig_11_21_total_quantity_month.png",
  fig_11_21,
  width = 9,
  height = 6,
  dpi = 300
)

# 11.22 Average Purchased Quantity by Month
# Measures seasonal purchasing intensity per transaction

month_avg_quantity <- readRDS(
  "data/processed/temporal_month_avg_quantity.rds"
)

fig_11_22 <- ggplot(
  month_avg_quantity %>%
    mutate(
      LabelText = if_else(
        Month %in% c("January", "August", "November"),
        paste0(avg_quantity),
        NA
      )
    ),
  aes(x = Month, y = avg_quantity, group = 1)
) +
  geom_line(color = "steelblue") +
  geom_label_repel(
    aes(label = LabelText),
    na.rm = TRUE,
    nudge_x = c(-0.5, 0.5),
    nudge_y = c(0.4, 0.4),
    fill = "white",
    color = "black",
    fontface = "bold",
    label.size = 0.5,
    segment.color = "black",
    segment.size = 0.6,
    size = 4,
    direction = "both",
    force = 2,
    box.padding = unit(0.5, "lines"),
    point.padding = unit(0.5, "lines")
  ) +
  scale_y_continuous(labels = scales::comma) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45)) +
  labs(
    title = "Average Purchased Quantity by Month",
    x = "Month",
    y = "Average Quantity"
  )

ggsave(
  "visualizations/temporal/fig_11_22_avg_quantity_month.png",
  fig_11_22,
  width = 9,
  height = 6,
  dpi = 300
)

# 11.23 Total Generated-Revenue by Month
# Reveals peak revenue seasons and monetization strength

month_total_revenue <- readRDS(
  "data/processed/temporal_month_total_revenue.rds"
)

fig_11_23 <- ggplot(
  month_total_revenue %>%
    mutate(
      LabelText = if_else(
        Month %in% c("January", "November"),
        paste0(scales::comma(total_revenue)),
        NA
      )
    ),
  aes(x = Month, y = total_revenue, group = 1)
) +
  geom_line(color = "skyblue") +
  geom_label_repel(
    aes(label = LabelText),
    na.rm = TRUE,
    nudge_x = c(-0.5, 0.5),
    nudge_y = c(120000, 120000),
    fill = "white",
    color = "black",
    fontface = "bold",
    label.size = 0.5,
    segment.color = "black",
    segment.size = 0.6,
    size = 4,
    direction = "both",
    force = 2,
    box.padding = unit(0.5, "lines"),
    point.padding = unit(0.5, "lines")
  ) +
  scale_y_continuous(labels = scales::comma) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45)) +
  labs(
    title = "Total Generated-Revenue by Month",
    x = "Month",
    y = "Total Revenue (£)"
  )

ggsave(
  "visualizations/temporal/fig_11_23_total_revenue_month.png",
  fig_11_23,
  width = 9,
  height = 6,
  dpi = 300
)

# 11.24 Average Generated-Revenue by Month
# Evaluates seasonal revenue efficiency per transaction

month_avg_revenue <- readRDS(
  "data/processed/temporal_month_avg_revenue.rds"
)

fig_11_24 <- ggplot(
  month_avg_revenue %>%
    mutate(
      LabelText = if_else(
        Month %in% c("January", "April", "August", "November"),
        paste0(avg_revenue),
        NA
      )
    ),
  aes(x = Month, y = avg_revenue, group = 1)
) +
  geom_line(color = "skyblue") +
  geom_label_repel(
    aes(label = LabelText),
    na.rm = TRUE,
    nudge_x = c(-0.5, 0.5),
    nudge_y = c(0.5, 0.5),
    fill = "white",
    color = "black",
    fontface = "bold",
    label.size = 0.5,
    segment.color = "black",
    segment.size = 0.6,
    size = 4,
    direction = "both",
    force = 2,
    box.padding = unit(0.5, "lines"),
    point.padding = unit(0.5, "lines")
  ) +
  scale_y_continuous(labels = scales::comma) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45)) +
  labs(
    title = "Average Generated-Revenue by Month",
    x = "Month",
    y = "Average Revenue (£)"
  )

ggsave(
  "visualizations/temporal/fig_11_24_avg_revenue_month.png",
  fig_11_24,
  width = 9,
  height = 6,
  dpi = 300
)

# 11.25 Peak Month for Orders
# Identifies months with highest transaction throughput

month_total_orders <- readRDS(
  "data/processed/temporal_month_total_orders.rds"
)

fig_11_25 <- ggplot(
  month_total_orders %>%
    mutate(
      LabelText = if_else(
        Month %in% c("January", "November"),
        paste0(scales::comma(total_orders)),
        NA
      )
    ),
  aes(x = Month, y = total_orders, group = 1)
) +
  geom_line(color = "orange") +
  geom_label_repel(
    aes(label = LabelText),
    na.rm = TRUE,
    nudge_x = c(-0.5, 0.5),
    nudge_y = c(250, 250),
    fill = "white",
    color = "black",
    fontface = "bold",
    label.size = 0.5,
    segment.color = "black",
    segment.size = 0.6,
    size = 4,
    direction = "both",
    force = 2,
    box.padding = unit(0.5, "lines"),
    point.padding = unit(0.5, "lines")
  ) +
  scale_y_continuous(labels = scales::comma) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45)) +
  labs(
    title = "Peak Month for Orders",
    x = "Month",
    y = "Order Frequency"
  )

ggsave(
  "visualizations/temporal/fig_11_25_orders_month.png",
  fig_11_25,
  width = 9,
  height = 6,
  dpi = 300
)

# 11.26 Peak Month for Order Line Activity
# Measures operational processing intensity across months

month_total_order_lines <- readRDS(
  "data/processed/temporal_month_total_order_lines.rds"
)

fig_11_26 <- ggplot(
  month_total_order_lines %>%
    mutate(
      LabelText = if_else(
        Month %in% c("January", "November"),
        paste0(scales::comma(total_order_lines)),
        NA
      )
    ),
  aes(x = Month, y = total_order_lines, group = 1)
) +
  geom_line(color = "orange") +
  geom_label_repel(
    aes(label = LabelText),
    na.rm = TRUE,
    nudge_x = c(-0.5, 0.5),
    nudge_y = c(7200, 7200),
    fill = "white",
    color = "black",
    fontface = "bold",
    label.size = 0.5,
    segment.color = "black",
    segment.size = 0.6,
    size = 4,
    direction = "both",
    force = 2,
    box.padding = unit(0.5, "lines"),
    point.padding = unit(0.5, "lines")
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45)) +
  labs(
    title = "Peak Month for Order Line Activity",
    x = "Month",
    y = "Order Line Frequency"
  )

ggsave(
  "visualizations/temporal/fig_11_26_orderlines_month.png",
  fig_11_26,
  width = 9,
  height = 6,
  dpi = 300
)

# ============================================================
# SECTION III: GEOGRAPHIC COUNTRY ANALYSIS VISUALS
# ============================================================

# 11.27 Top 10 Countries by Total Purchased Quantity
# Identifies strongest bulk-demand markets globally

top_10_countries_total_quantity <- readRDS(
  "data/processed/country_top_10_total_quantity.rds"
)

fig_11_27 <- ggplot(
  top_10_countries_total_quantity,
  aes(x = reorder(Country, total_quantity),
      y = total_quantity,
      fill = Country)
) +
  geom_col(show.legend = FALSE) +
  scale_y_continuous(labels = scales::comma) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45)) +
  labs(
    title = "Top 10 Countries by Total Purchase Volume",
    y = "Total Purchased Quantity",
    x = "Country"
  )

ggsave(
  "visualizations/geographic/fig_11_27_total_quantity_country.png",
  fig_11_27,
  width = 9,
  height = 6,
  dpi = 300
)

# 11.28 Top 10 Countries by Average Purchased Quantity
# Highlights markets with high per-transaction intensity

top_10_countries_avg_quantity <- readRDS(
  "data/processed/country_top_10_avg_quantity.rds"
)

fig_11_28 <- ggplot(
  top_10_countries_avg_quantity,
  aes(x = reorder(Country, avg_quantity),
      y = avg_quantity,
      fill = Country)
) +
  geom_col(show.legend = FALSE) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45)) +
  labs(
    title = "Top 10 Countries by Average Purchase Value",
    y = "Average Purchased Quantity",
    x = "Country"
  )

ggsave(
  "visualizations/geographic/fig_11_28_avg_quantity_country.png",
  fig_11_28,
  width = 9,
  height = 6,
  dpi = 300
)

# 11.29 Top 10 Countries by Total Revenue Generated
# Identifies highest revenue-contributing markets

top_10_countries_total_revenue <- readRDS(
  "data/processed/country_top_10_total_revenue.rds"
)

fig_11_29 <- ggplot(
  top_10_countries_total_revenue,
  aes(x = reorder(Country, total_revenue),
      y = total_revenue,
      fill = Country)
) +
  geom_col(show.legend = FALSE) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45)) +
  labs(
    title = "Top 10 Countries by Total Revenue-Generated",
    y = "Total Revenue (£)",
    x = "Country"
  )

ggsave(
  "visualizations/geographic/fig_11_29_total_revenue_country.png",
  fig_11_29,
  width = 9,
  height = 6,
  dpi = 300
)

# 11.30 Top 10 Countries by Average Revenue Generated
# Measures revenue intensity per transaction across countries

top_10_countries_avg_revenue <- readRDS(
  "data/processed/country_top_10_avg_revenue.rds"
)

fig_11_30 <- ggplot(
  top_10_countries_avg_revenue,
  aes(x = reorder(Country, avg_revenue),
      y = avg_revenue,
      fill = Country)
) +
  geom_col(show.legend = FALSE) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45)) +
  labs(
    title = "Top 10 Countries by Average Revenue-Generated",
    y = "Average Revenue (£)",
    x = "Country"
  )

ggsave(
  "visualizations/geographic/fig_11_30_avg_revenue_country.png",
  fig_11_30,
  width = 9,
  height = 6,
  dpi = 300
)

# 11.31 Top 10 Countries by Processed Order Count (Bar)
# Evaluates transaction throughput by geographic market

top_10_countries_total_orders <- readRDS(
  "data/processed/country_top_10_total_orders.rds"
)

fig_11_31 <- ggplot(
  top_10_countries_total_orders %>%
    mutate(
      LabelText = if_else(
        total_orders == max(total_orders),
        paste0(scales::comma(total_orders), " orders"),
        NA
      )
    ),
  aes(x = reorder(Country, total_orders),
      y = total_orders,
      fill = Country)
) +
  geom_col(show.legend = FALSE) +
  geom_label_repel(
    aes(label = LabelText),
    na.rm = TRUE,
    nudge_x = c(-0.5, 0.5),
    nudge_y = c(2300, 2300),
    fill = "white",
    color = "black",
    fontface = "bold",
    label.size = 0.5,
    segment.color = "black",
    segment.size = 0.6,
    size = 4,
    direction = "both",
    force = 2
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45)) +
  labs(
    title = "Top 10 Countries by Order Frequency",
    y = "Order Frequency",
    x = "Country"
  )

ggsave(
  "visualizations/geographic/fig_11_31_orders_country_bar.png",
  fig_11_31,
  width = 9,
  height = 6,
  dpi = 300
)

# 11.32 Top 10 Countries by Order Frequency (Map)
# Provides spatial representation of transaction dominance

world_map_orders <- ne_countries(scale = "medium", returnclass = "sf") %>%
  left_join(top_10_countries_total_orders,
            by = c("name" = "Country"))

fig_11_32 <- ggplot(world_map_orders) +
  geom_sf(aes(fill = total_orders)) +
  geom_label_repel(
    data = world_map_orders %>%
      filter(name == "United Kingdom") %>%
      mutate(
        centroid = st_centroid(geometry),
        coords = st_coordinates(centroid),
        lon = coords[1, "X"],
        lat = coords[1, "Y"]
      ),
    aes(
      x = lon,
      y = lat,
      label = paste0("United Kingdom\n",
                     scales::comma(total_orders),
                     " orders")
    ),
    seed = 123,
    min.segment.length = 0,
    size = 3,
    segment.color = "black",
    segment.size = 0.6,
    label.size = 0.2,
    box.padding = 0.5,
    point.padding = 0.3
  ) +
  scale_fill_viridis_c(option = "plasma", na.value = "grey") +
  theme_minimal() +
  labs(
    title = "Top 10 Countries by Order Frequency (Map Visualization)",
    fill = "OrderFrequency"
  )

ggsave(
  "visualizations/geographic/fig_11_32_orders_country_map.png",
  fig_11_32,
  width = 10,
  height = 6,
  dpi = 300
)

# 11.33 Top 10 Countries by Order Line Frequency (Bar)
# Measures transaction density and operational intensity

top_10_countries_total_order_lines <- readRDS(
  "data/processed/country_top_10_total_order_lines.rds"
)

fig_11_33 <- ggplot(
  top_10_countries_total_order_lines %>%
    mutate(
      LabelText = if_else(
        total_order_lines == max(total_order_lines),
        paste0(scales::comma(total_order_lines), " orders"),
        NA
      )
    ),
  aes(x = reorder(Country, total_order_lines),
      y = total_order_lines,
      fill = Country)
) +
  geom_col(show.legend = FALSE) +
  geom_label_repel(
    aes(label = LabelText),
    na.rm = TRUE,
    nudge_x = c(-0.5, 0.5),
    nudge_y = c(70000, 70000),
    fill = "white",
    color = "black",
    fontface = "bold",
    label.size = 0.5,
    segment.color = "black",
    segment.size = 0.6,
    size = 4,
    direction = "both",
    force = 2
  ) +
  scale_y_continuous(labels = scales::comma) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45)) +
  labs(
    title = "Top 10 Countries by Order Line Frequency",
    y = "Order Line Frequency",
    x = "Country"
  )

ggsave(
  "visualizations/geographic/fig_11_33_orderlines_country_bar.png",
  fig_11_33,
  width = 9,
  height = 6,
  dpi = 300
)

# 11.34 Top 10 Countries by Order Line Frequency (Map)
# Provides geographic representation of order line density

world_map_orderlines <- ne_countries(scale = "medium", returnclass = "sf") %>%
  left_join(top_10_countries_ord_line_freq,
            by = c("name" = "Country"))

fig_11_34 <- ggplot(world_map_orderlines) +
  geom_sf(aes(fill = total_order_lines)) +
  geom_label_repel(
    data = world_map_orderlines %>%
      filter(name == "United Kingdom") %>%
      mutate(
        centroid = st_centroid(geometry),
        coords = st_coordinates(centroid),
        lon = coords[1, "X"],
        lat = coords[1, "Y"]
      ),
    aes(
      x = lon,
      y = lat,
      label = paste0("United Kingdom\n",
                     scales::comma(total_order_lines),
                     " orders")
    ),
    seed = 123,
    min.segment.length = 0,
    size = 3,
    segment.color = "black",
    segment.size = 0.6,
    label.size = 0.2,
    box.padding = 0.5,
    point.padding = 0.3
  ) +
  scale_fill_continuous(labels = scales::label_comma()) +
  theme_minimal() +
  labs(
    title = "Top 10 Countries by OrderLine Frequency (Map Visualization)",
    fill = "OrderLineFrequency"
  )

ggsave(
  "visualizations/geographic/fig_11_34_orderlines_country_map.png",
  fig_11_34,
  width = 10,
  height = 6,
  dpi = 300
)

# ============================================================
# SECTION IV: CROSS-DIMENSIONAL PRODUCT INTELLIGENCE VISUALS
# ============================================================

# 11.35 HOURLY — QUANTITY (TOTAL)
# Identifies peak hour product volume concentration, 
# revealing operational demand pressure and time-based merchandising dominance

product_hour_total_quantity <- readRDS(
  "data/processed/cross_product_hour_total_quantity.rds"
)

fig_11_35 <- ggplot(product_hour_total_quantity,
       aes(x = Hour,
           y = total_quantity,
           fill = ShortProductLabel)) +
  geom_col() +
  coord_flip() +
  scale_x_continuous(breaks = 0:23) +
  labs(title = "Top 2 Bulk-Purchased Products by Hour of Day",
       y = "Total Quantity",
       x = "Hour of Day") +
  theme_minimal()

ggsave("visualizations/cross/fig_11_35_hour_total_quantity.png",
       fig_11_35, width = 9, height = 6, dpi = 300)

# 11.36 HOURLY — QUANTITY (AVERAGE)
# Distinguishes purchasing intensity per transaction by hour, 
# separating bulk behavior from simple transaction frequency

product_hour_avg_quantity <- readRDS(
  "data/processed/cross_product_hour_avg_quantity.rds"
)

fig_11_36 <- ggplot(product_hour_avg_quantity,
       aes(x = Hour,
           y = avg_quantity,
           fill = ShortProductLabel)) +
  geom_col() +
  coord_flip() +
  scale_x_continuous(breaks = 0:23) +
  labs(title = "Top 2 Average Bulk-Purchases by Hour of Day",
       y = "Average Quantity",
       x = "Hour of Day") +
  theme_minimal()

ggsave("visualizations/cross/fig_11_36_hour_avg_quantity.png",
       fig_11_36, width = 9, height = 6, dpi = 300)

# 11.37 WEEKPART — QUANTITY (TOTAL)
# Highlights weekday versus weekend unit-demand dominance, 
# informing staffing and fulfillment strategy

product_weekpart_total_quantity <- readRDS(
  "data/processed/cross_product_weekpart_total_quantity.rds"
)

fig_11_37 <- ggplot(product_weekpart_total_quantity,
       aes(x = ShortProductLabel,
           y = total_quantity,
           fill = ShortProductLabel)) +
  geom_col(width = 0.5) +
  coord_flip() +
  facet_wrap(~WeekPart) +
  labs(title = "Top 2 Bulk-Purchased Products by Week Part",
       y = "Total Quantity",
       x = "Short Product Label") +
  theme_minimal()

ggsave("visualizations/cross/fig_11_37_weekpart_total_quantity.png",
       fig_11_37, width = 9, height = 6, dpi = 300)

# 11.38 WEEKPART — QUANTITY (AVERAGE)
# Evaluates per-transaction purchasing strength across week structure, 
# clarifying behavioral intensity differences

product_weekpart_avg_quantity <- readRDS(
  "data/processed/cross_product_weekpart_avg_quantity.rds"
)

fig_11_38 <- ggplot(product_weekpart_avg_quantity,
       aes(x = ShortProductLabel,
           y = avg_quantity,
           fill = ShortProductLabel)) +
  geom_col(width = 0.5) +
  coord_flip() +
  facet_wrap(~WeekPart) +
  labs(title = "Top 2 Average Bulk-Purchases by Week Part",
       y = "Average Quantity",
       x = "Short Product Label") +
  theme_minimal()

ggsave("visualizations/cross/fig_11_38_weekpart_avg_quantity.png",
       fig_11_38, width = 9, height = 6, dpi = 300)

# 11.39 MONTH — QUANTITY (TOTAL)
# Detects seasonal unit-movement leaders, 
# supporting inventory forecasting and demand planning

product_month_total_quantity <- readRDS(
  "data/processed/cross_product_month_total_quantity.rds"
)

fig_11_39 <- ggplot(product_month_total_quantity,
       aes(x = Month,
           y = total_quantity,
           fill = ShortProductLabel)) +
  geom_col() +
  coord_flip() +
  labs(title = "Top 2 Bulk-Purchased Products by Month",
       y = "Total Quantity",
       x = "Month") +
  theme_minimal()

ggsave("visualizations/cross/fig_11_39_month_total_quantity.png",
       fig_11_39, width = 9, height = 6, dpi = 300)

# 11.40 MONTH — QUANTITY (AVERAGE)
# Measures seasonal transaction-level purchasing intensity 
# to identify true bulk behavior patterns

product_month_avg_quantity <- readRDS(
  "data/processed/cross_product_month_avg_quantity.rds"
)

fig_11_40 <- ggplot(product_month_avg_quantity,
       aes(x = Month,
           y = avg_quantity,
           fill = ShortProductLabel)) +
  geom_col() +
  coord_flip() +
  labs(title = "Top 2 Average Bulk-Purchases by Month",
       y = "Average Quantity",
       x = "Month") +
  theme_minimal()

ggsave("visualizations/cross/fig_11_40_month_avg_quantity.png",
       fig_11_40, width = 9, height = 6, dpi = 300)

# 11.41 DAILY — REVENUE (TOTAL)
# Identifies highest daily monetary contributors, 
# revealing revenue concentration across the weekly cycle

product_day_total_revenue <- readRDS(
  "data/processed/cross_product_day_total_revenue.rds"
)

fig_11_41 <- ggplot(product_day_total_revenue,
       aes(x = reorder(ShortProductLabel, total_revenue),
           y = total_revenue,
           fill = ShortProductLabel)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  facet_wrap(~Day) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45)) +
  labs(title = "Top 2 Revenue-Generating Products by Day of Week",
       x = "Short Product Label",
       y = "Total Revenue (£)")

ggsave("visualizations/cross/fig_11_41_day_total_revenue.png",
       fig_11_41, width = 9, height = 6, dpi = 300)

# 11.42 DAILY — REVENUE (AVERAGE)
# Differentiates revenue efficiency per transaction by day, 
# isolating profitability strength from volume

product_day_avg_revenue <- readRDS(
  "data/processed/cross_product_day_avg_revenue.rds"
)

fig_11_42 <- ggplot(product_day_avg_revenue,
       aes(x = Day,
           y = avg_revenue,
           fill = ShortProductLabel)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45)) +
  labs(title = "Top 2 Average Revenue Products by Day of Week",
       x = "Day of Week",
       y = "Average Revenue (£)")

ggsave("visualizations/cross/fig_11_42_day_avg_revenue.png",
       fig_11_42, width = 9, height = 6, dpi = 300)

# 11.43 WEEKPART — REVENUE (TOTAL)
# Reveals revenue dominance between weekday and weekend periods, 
# guiding promotional allocation

product_weekpart_total_revenue <- readRDS(
  "data/processed/cross_product_weekpart_total_revenue.rds"
)

fig_11_43 <- ggplot(product_weekpart_total_revenue,
       aes(x = reorder(ShortProductLabel, total_revenue),
           y = total_revenue,
           fill = ShortProductLabel)) +
  geom_bar(stat = "identity", width = 0.5) +
  coord_flip() +
  facet_wrap(~WeekPart) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45)) +
  labs(title = "Top 2 Revenue-Generating Products by Week Part",
       x = "Short Product Label",
       y = "Total Revenue (£)")

ggsave("visualizations/cross/fig_11_43_weekpart_total_revenue.png",
       fig_11_43, width = 9, height = 6, dpi = 300)

# 11.44 WEEKPART — REVENUE (AVERAGE)
# Evaluates revenue intensity per transaction across 
# week structure to identify margin-efficient timing

product_weekpart_avg_revenue <- readRDS(
  "data/processed/cross_product_weekpart_avg_revenue.rds"
)

fig_11_44 <- ggplot(product_weekpart_avg_revenue,
       aes(x = reorder(ShortProductLabel, avg_revenue),
           y = avg_revenue,
           fill = ShortProductLabel)) +
  geom_bar(stat = "identity", width = 0.5) +
  coord_flip() +
  facet_wrap(~WeekPart) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45)) +
  labs(title = "Top 2 Average Revenue Products by Week Part",
       x = "Short Product Label",
       y = "Average Revenue (£)")

ggsave("visualizations/cross/fig_11_44_weekpart_avg_revenue.png",
       fig_11_44, width = 9, height = 6, dpi = 300)

# 11.45 MONTH — REVENUE (TOTAL)
# Identifies seasonal monetary peaks, 
# supporting strategic revenue planning and campaign timing

product_month_total_revenue <- readRDS(
  "data/processed/cross_product_month_total_revenue.rds"
)

fig_11_45 <- ggplot(product_month_total_revenue,
       aes(x = Month,
           y = total_revenue,
           fill = ShortProductLabel)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45)) +
  labs(title = "Top 2 Revenue-Generating Products by Month",
       y = "Total Revenue (£)",
       x = "Month")

ggsave("visualizations/cross/fig_11_45_month_total_revenue.png",
       fig_11_45, width = 9, height = 6, dpi = 300)

# 11.46 MONTH — REVENUE (AVERAGE)
# Measures seasonal revenue efficiency per transaction 
# to distinguish margin strength from sales volume 

product_month_avg_revenue <- readRDS(
  "data/processed/cross_product_month_avg_revenue.rds"
)

fig_11_46 <- ggplot(product_month_avg_revenue,
       aes(x = Month,
           y = avg_revenue,
           fill = ShortProductLabel)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45)) +
  labs(title = "Top 2 Average Revenue Products by Month",
       y = "Average Revenue (£)",
       x = "Month")

ggsave("visualizations/cross/fig_11_46_month_avg_revenue.png",
       fig_11_46, width = 9, height = 6, dpi = 300)

# 11.47 PROCESSED ORDER — HOURLY
# Highlights hourly transaction processing concentration, 
# informing operational workload and system capacity planning

product_hour_order_line_count <- readRDS(
  "data/processed/cross_product_hour_order_line_count.rds"
)

fig_11_47 <- ggplot(product_hour_order_line_count,
       aes(x = Hour,
           y = total_order_lines,
           fill = ShortProductLabel)) +
  geom_col() +
  coord_flip() +
  scale_x_continuous(breaks = 0:23) +
  labs(title = "Top 2 Products by Hourly Demand",
       y = "Order Frequency",
       x = "Hour of Day") +
  theme_minimal()

ggsave("visualizations/cross/fig_11_47_hour_orders.png",
       fig_11_47, width = 9, height = 6, dpi = 300)

# 11.48 PROCESSED ORDER — DAY
# Reveals daily transaction density, clarifying 
# behavioral demand distribution across the week

product_day_order_line_count <- readRDS(
  "data/processed/cross_product_day_order_line_count.rds"
)

fig_11_48 <- ggplot(product_day_order_line_count,
       aes(x = reorder(ShortProductLabel, total_order_lines),
           y = total_order_lines,
           fill = ShortProductLabel)) +
  geom_col(width = 0.5) +
  coord_flip() +
  facet_wrap(~Day) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45)) +
  labs(title = "Top 2 Products by Daily Demand",
       y = "Order Frequency",
       x = "Short Product Label")

ggsave("visualizations/cross/fig_11_48_day_orders.png",
       fig_11_48, width = 9, height = 6, dpi = 300)

# 11.49 PROCESSED ORDER — WEEKPART
# Differentiates weekly structural demand patterns, 
# supporting workforce and logistics optimization

product_weekpart_order_line_count <- readRDS(
  "data/processed/cross_product_weekpart_order_line_count.rds"
)

fig_11_49 <- ggplot(product_weekpart_order_line_count,
       aes(x = reorder(ShortProductLabel, total_order_lines),
           y = total_order_lines,
           fill = ShortProductLabel)) +
  geom_col(width = 0.3) +
  coord_flip() +
  facet_wrap(~WeekPart) +
  labs(title = "Top 2 Products by Weekly Demand",
       y = "Order Frequency",
       x = "Short Product Label") +
  theme_minimal()

ggsave("visualizations/cross/fig_11_49_weekpart_orders.png",
       fig_11_49, width = 9, height = 6, dpi = 300)

# 11.50 PROCESSED ORDER — MONTH
# Identifies seasonal transaction throughput peaks, 
# guiding fulfillment scalability planning

product_month_order_line_count <- readRDS(
  "data/processed/cross_product_month_order_line_count.rds"
)

fig_11_50 <- ggplot(product_month_order_line_count,
       aes(x = Month,
           y = total_order_lines,
           fill = ShortProductLabel)) +
  geom_col() +
  coord_flip() +
  labs(title = "Top 2 Products by Monthly Demand",
       y = "Order Frequency",
       x = "Month") +
  theme_minimal()

ggsave("visualizations/cross/fig_11_50_month_orders.png",
       fig_11_50, width = 9, height = 6, dpi = 300)

# 11.51 COUNTRY — TOP VOLUME PRODUCTS
# Reveals which products drive unit dominance within top demand markets, 
# informing localized inventory strategy

country_product_total_quantity <- readRDS(
  "data/processed/cross_country_product_total_quantity.rds"
)

fig_11_51 <- ggplot(country_product_total_quantity,
       aes(x = Country,
           y = total_quantity,
           fill = ShortProductLabel)) +
  geom_col() +
  coord_flip() +
  labs(title = "Top 2 Bulk-Purchased Products in Top Volume Country",
       y = "Total Product Quantity",
       x = "Country") +
  theme_minimal()

ggsave("visualizations/cross/fig_11_51_country_total_quantity.png",
       fig_11_51, width = 9, height = 6, dpi = 300)

# 11.52 COUNTRY — TOP AVERAGE VOLUME PRODUCTS
# Identifies per-transaction purchasing intensity within 
# strongest bulk-demand countries

country_product_avg_quantity <- readRDS(
  "data/processed/cross_country_product_avg_quantity.rds"
)

fig_11_52 <- ggplot(country_product_avg_quantity,
       aes(x = Country,
           y = avg_quantity,
           fill = ShortProductLabel)) +
  geom_col() +
  coord_flip() +
  labs(title = "Top 2 Bulk-Purchased Products in Top Average Purchasing Country",
       y = "Average Product Quantity",
       x = "Country") +
  theme_minimal()

ggsave("visualizations/cross/fig_11_52_country_avg_quantity.png",
       fig_11_52, width = 9, height = 6, dpi = 300)

# 11.53 COUNTRY — TOP REVENUE PRODUCTS
# Pinpoints merchandise driving monetary dominance 
# within top revenue-generating markets

country_product_total_revenue <- readRDS(
  "data/processed/cross_country_product_total_revenue.rds"
)

fig_11_53 <- ggplot(country_product_total_revenue,
       aes(x = Country,
           y = total_revenue,
           fill = ShortProductLabel)) +
  geom_col() +
  scale_y_continuous(labels = scales::comma) +
  coord_flip() +
  labs(title = "Top 2 Revenue-Generating Products in Top Revenue Country",
       y = "Total Revenue (£)",
       x = "Country") +
  theme_minimal()

ggsave("visualizations/cross/fig_11_53_country_total_revenue.png",
       fig_11_53, width = 9, height = 6, dpi = 300)

# 11.54 COUNTRY — TOP AVERAGE REVENUE PRODUCTS
# Measures revenue efficiency per transaction within 
# high-value geographic markets

country_product_avg_revenue <- readRDS(
  "data/processed/cross_country_product_avg_revenue.rds"
)

fig_11_54 <- ggplot(country_product_avg_revenue,
       aes(x = Country,
           y = avg_revenue,
           fill = ShortProductLabel)) +
  geom_col() +
  coord_flip() +
  labs(title = "Top 2 Revenue-Generating Products in Top Average Revenue Country",
       y = "Average Revenue (£)",
       x = "Country") +
  theme_minimal()

ggsave("visualizations/cross/fig_11_54_country_avg_revenue.png",
       fig_11_54, width = 9, height = 6, dpi = 300)

# 11.55 COUNTRY — TOP ORDER PRODUCTS
# Identifies products generating highest transactional processing 
# volume within the busiest countries

country_product_order_line_count <- readRDS(
  "data/processed/cross_country_product_order_line_count.rds"
)

fig_11_55 <- ggplot(country_product_order_line_count,
       aes(x = Country,
           y = total_order_lines,
           fill = ShortProductLabel)) +
  geom_col() +
  coord_flip() +
  labs(title = "Top 2 Most Frequently Purchased Products in High Order Frequency Countries",
       y = "Order Frequency",
       x = "Country") +
  theme_minimal()

ggsave("visualizations/cross/fig_11_55_country_order_frequency.png",
       fig_11_55, width = 9, height = 6, dpi = 300)

# ============================================================
# SECTION V: SEGMENT INTELLIGENCE VISUALS
# ============================================================

# 11.56 CUSTOMER SEGMENT DISTRIBUTION
# Reveals population dominance and structural weight of each
# behavioral cluster within the customer ecosystem

segment_customer_distribution <- readRDS(
  "data/processed/segment_customer_distribution.rds"
)

fig_11_56 <- ggplot(segment_customer_distribution %>% 
         mutate(Fraction = CustomerCount/sum(CustomerCount),
                Ymax = cumsum(Fraction),
                Ymin = c(0, head(Ymax, -1)),
                MidY = (Ymax + Ymin)/2,
                TextLabel = paste0(round(Fraction*100,1),"%")))+
  geom_rect(aes(xmin=0.5,xmax=1.5,ymin=Ymin,ymax=Ymax,fill=Segment),
            color="white")+
  geom_segment(aes(x=1.5,y=MidY,xend=1.70,yend=MidY),
               color="black",linewidth=0.6)+
  geom_label_repel(aes(x=1.75,y=MidY,label=TextLabel),
                   size=4,nudge_x = 0.3,direction = 'both',segment.color=NA,fill="white",min.segment.length = Inf)+
  coord_polar(theta="y")+
  xlim(0.5,2.2)+
  theme_void()+
  labs(title="Customer Distribution between Customer Segment",
       fill="Segment")

ggsave("visualizations/segment/fig_11_56_segment_customer_distribution.png",
       fig_11_56,width=9,height=6,dpi=300)

# 11.57 SEGMENT REVENUE DISTRIBUTION (TOTAL)
# Identifies financial dominance across segments

segment_revenue_distribution <- readRDS(
  "data/processed/segment_revenue_distribution.rds"
)

fig_11_57 <- ggplot(segment_revenue_distribution %>% 
         mutate(Fraction = TotalRevenue/sum(TotalRevenue),
                Ymax = cumsum(Fraction),
                Ymin = c(0, head(Ymax, -1)),
                MidY = (Ymax + Ymin)/2,
                TextLabel = paste0(round(Fraction*100,1),"%")))+
  geom_rect(aes(xmin=0.5,xmax=1.5,ymin=Ymin,ymax=Ymax,fill=Segment),
            color="white")+
  geom_segment(aes(x=1.5,y=MidY,xend=1.70,yend=MidY),
               color="black",linewidth=0.6)+
  geom_label_repel(aes(x=1.75,y=MidY,label=TextLabel),
                   size=4,nudge_x = 0.3,direction = 'both',segment.color=NA,fill="white",min.segment.length = Inf)+
  coord_polar(theta="y")+
  xlim(0.5,2.2)+
  theme_void()+
  labs(title="Revenue Distribution between Customer Segment",
       fill="Segment")

ggsave("visualizations/segment/fig_11_57_segment_total_revenue.png",
       fig_11_57,width=9,height=6,dpi=300)

# 11.58 SEGMENT REVENUE DISTRIBUTION (AVERAGE)
# Measures per-customer spending intensity across segments

fig_11_58 <- ggplot(
  segment_revenue_distribution %>%
    mutate(
      HighlightPoints = AverageRevenue == max(AverageRevenue)|
      AverageRevenue == min(AverageRevenue)
    ),
  aes(x = reorder(Segment, AverageRevenue),
      y = AverageRevenue,
      fill = Segment)
) +
  geom_col(width = 0.7) +
  geom_label_repel(
    data = ~ dplyr::filter(.x, HighlightPoints),
    aes(label = paste0(AverageRevenue)),
    nudge_x = c(-0.5, 0.5),
    nudge_y = c(1000, 1000),
    fill = "white",
    color = "black",
    fontface = "bold",
    label.size = 0.5,
    segment.color = "black",
    segment.size = 0.6,
    size = 4,
    direction = "both",
    force = 2
  ) +
  theme_minimal() +
  scale_x_discrete(guide = guide_axis(angle = 45)) +
  labs(
    title = "Average Generated-Revenue by Customer Segment",
    y = "Average Revenue (£)",
    x = "Customer Segment"
  )

ggsave("visualizations/segment/fig_11_58_segment_avg_revenue.png",
       fig_11_58,width=9,height=6,dpi=300)

# 11.59 SEGMENT ORDER DISTRIBUTION
# Shows transaction engagement concentration

segment_order_distribution <- readRDS(
  "data/processed/segment_order_distribution.rds"
)

fig_11_59 <- ggplot(segment_order_distribution %>% 
         mutate(Fraction = TotalOrderFrequency/sum(TotalOrderFrequency),
                Ymax = cumsum(Fraction),
                Ymin = c(0, head(Ymax, -1)),
                MidY = (Ymax + Ymin)/2,
                TextLabel = paste0(round(Fraction*100,1),"%")))+
  geom_rect(aes(xmin=0.5,xmax=1.5,ymin=Ymin,ymax=Ymax,fill=Segment),
            color="white")+
  geom_segment(aes(x=1.5,y=MidY,xend=1.70,yend=MidY),
               color="black",linewidth=0.6)+
  geom_label_repel(aes(x=1.75,y=MidY,label=TextLabel),
                   size=4,nudge_x = 0.3,direction = 'both',segment.color=NA,fill="white",min.segment.length = Inf)+
  coord_polar(theta="y")+
  xlim(0.5,2.2)+
  theme_void()+
  labs(title="Order Distribution between Customer Segment",
       fill="Segment")

ggsave("visualizations/segment/fig_11_59_segment_order_distribution.png",
       fig_11_59,width=9,height=6,dpi=300)

# 11.60–11.64 SEGMENT × PRODUCT VISUALS
# Reveals merchandise preference heterogeneity across segments

segment_product_total_quantity <- readRDS(
  "data/processed/segment_product_total_quantity.rds"
)

fig_11_60 <- ggplot(segment_product_total_quantity,
       aes(x=Segment,y=TotalQuantity,fill=ShortProductLabel))+
  geom_col(width=0.7)+
  coord_flip()+
  theme_minimal()+
  labs(title="Top 2 Volume Bulk-Purchased Products by Customer Segment",
       y="Total Quantity",x="Customer Segment")

ggsave("visualizations/segment/fig_11_60_segment_product_total_quantity.png",
       fig_11_60,width=9,height=6,dpi=300)

segment_product_avg_quantity <- readRDS(
  "data/processed/segment_product_avg_quantity.rds"
)

fig_11_61 <- ggplot(segment_product_avg_quantity,
       aes(x=Segment,y=AverageQuantity,fill=ShortProductLabel))+
  geom_col(width=0.7)+
  coord_flip()+
  theme_minimal()+
  labs(title="Top 2 Average Bulk-Purchased Products by Customer Segment",
       y="Average Quantity",x="Customer Segment")

ggsave("visualizations/segment/fig_11_61_segment_product_avg_quantity.png",
       fig_11_61,width=9,height=6,dpi=300)

segment_product_total_revenue <- readRDS(
  "data/processed/segment_product_total_revenue.rds"
)

fig_11_62 <- ggplot(segment_product_total_revenue,
       aes(x=Segment,y=TotalRevenue,fill=ShortProductLabel))+
  geom_col(width=0.7)+
  coord_flip()+
  scale_y_continuous(labels=scales::comma)+
  theme_minimal()+
  labs(title="Top 2 Volume Revenue-Generating Products by Customer Segment",
       y="Total Revenue (£)",x="Customer Segment")

ggsave("visualizations/segment/fig_11_62_segment_product_total_revenue.png",
       fig_11_62,width=9,height=6,dpi=300)

segment_product_avg_revenue <- readRDS(
  "data/processed/segment_product_avg_revenue.rds"
)

fig_11_63 <- ggplot(segment_product_avg_revenue,
       aes(x=Segment,y=AverageRevenue,fill=ShortProductLabel))+
  geom_col(width=0.7)+
  coord_flip()+
  theme_minimal()+
  labs(title="Top 2 Average Revenue-Generating Products by Customer Segment",
       y="Average Revenue (£)",x="Customer Segment")

ggsave("visualizations/segment/fig_11_63_segment_product_avg_revenue.png",
       fig_11_63,width=9,height=6,dpi=300)

segment_product_order_count <- readRDS(
  "data/processed/segment_product_order_count.rds"
)

fig_11_64 <- ggplot(segment_product_order_count,
       aes(x=reorder(ShortProductLabel,TotalOrders),
           y=TotalOrders,
           fill=ShortProductLabel))+
  geom_col(width=0.7)+
  coord_flip()+
  facet_wrap(~Segment)+
  theme_minimal()+
  theme(axis.text.x = element_text(angle = 45))+
  labs(title="Top 2 High-Demand Products by Customer Segment",
       y="Order Frequency",x="Short Product Label")

ggsave("visualizations/segment/fig_11_64_segment_product_order_frequency.png",
       fig_11_64,width=9,height=6,dpi=300)

# 11.65–11.70 SEGMENT × COUNTRY VISUALS
# Reveals geographic dominance and behavioral clustering
# across segments

segment_country_population_dominance <- readRDS(
  "data/processed/segment_country_population_dominance.rds"
)

fig_11_65 <- ggplot(segment_country_population_dominance,
       aes(x=Segment,y=TotalCustomer,fill=Country))+
  geom_col(width=0.7)+
  theme_minimal()+
  scale_x_discrete(guide=guide_axis(angle=45))+
  labs(title="Top 2 Dominant Countries by Customer Segment",
       y="Total Customer",x="Customer Segment")

ggsave("visualizations/segment/fig_11_65_segment_country_population.png",
       fig_11_65,width=9,height=6,dpi=300)

segment_country_high_frequency <- readRDS(
  "data/processed/segment_country_high_frequency.rds"
)

fig_11_66 <- ggplot(segment_country_high_frequency,
       aes(x=Segment,y=TotalOrderFrequency,fill=Country))+
  geom_col(width=0.7)+
  theme_minimal()+
  scale_x_discrete(guide=guide_axis(angle=45))+
  labs(title="Top 2 High-Demand Countries by Customer Segment",
       y="Order Frequency",x="Customer Segment")

ggsave("visualizations/segment/fig_11_66_segment_country_order_frequency.png",
       fig_11_66,width=9,height=6,dpi=300)

segment_country_total_revenue <- readRDS(
  "data/processed/segment_country_total_revenue.rds"
)

fig_11_67 <- ggplot(segment_country_total_revenue,
       aes(x=Segment,y=TotalRevenue,fill=Country))+
  geom_col(width=0.7)+
  scale_y_continuous(labels=scales::comma)+
  theme_minimal()+
  scale_x_discrete(guide=guide_axis(angle=45))+
  labs(title="Top 2 Volume Revenue-Generating Countries by Customer Segment",
       y="Total Revenue (£)",x="Customer Segment")

ggsave("visualizations/segment/fig_11_67_segment_country_total_revenue.png",
       fig_11_67,width=9,height=6,dpi=300)

segment_country_avg_revenue <- readRDS(
  "data/processed/segment_country_avg_revenue.rds"
)

fig_11_68 <- ggplot(segment_country_avg_revenue,
       aes(x=Segment,y=AverageRevenue,fill=Country))+
  geom_col(width=0.7)+
  theme_minimal()+
  scale_x_discrete(guide=guide_axis(angle=45))+
  labs(title="Top 2 Average Revenue-Generating Countries by Customer Segment",
       y="Average Revenue (£)",x="Customer Segment")

ggsave("visualizations/segment/fig_11_68_segment_country_avg_revenue.png",
       fig_11_68,width=9,height=6,dpi=300)

segment_country_total_quantity <- readRDS(
  "data/processed/segment_country_total_quantity.rds"
)

fig_11_69 <- ggplot(segment_country_total_quantity,
       aes(x=Segment,y=TotalQuantity,fill=Country))+
  geom_col(width=0.7)+
  scale_y_continuous(labels=scales::comma)+
  theme_minimal()+
  scale_x_discrete(guide=guide_axis(angle=45))+
  labs(title="Top 2 Volume Bulk-Purchasing Countries by Customer Segment",
       y="Total Quantity",x="Customer Segment")

ggsave("visualizations/segment/fig_11_69_segment_country_total_quantity.png",
       fig_11_69,width=9,height=6,dpi=300)

segment_country_avg_quantity <- readRDS(
  "data/processed/segment_country_avg_quantity.rds"
)

fig_11_70 <- ggplot(segment_country_avg_quantity,
       aes(x=Segment,y=AverageQuantity,fill=Country))+
  geom_col(width=0.7)+
  theme_minimal()+
  scale_x_discrete(guide=guide_axis(angle=45))+
  labs(title="Top 2 Average Bulk-Purchasing Countries by Customer Segment",
       y="Average Quantity",x="Customer Segment")

ggsave("visualizations/segment/fig_11_70_segment_country_avg_quantity.png",
       fig_11_70,width=9,height=6,dpi=300)

# 11.71 SEGMENT CLV
# Identifies long-term economic value concentration

rfm_clv <- readRDS(
  "data/processed/segment_lifetime_value_evaluation.rds"
)

fig_11_71 <- ggplot(
  rfm_clv %>%
    mutate(
      TextLabel = if_else(AverageCLV == max(AverageCLV)|
      AverageCLV == min(AverageCLV),
                          paste0(scales::comma(AverageCLV)), NA)
    ),
  aes(x = reorder(Segment, -AverageCLV),
      y = AverageCLV,
      fill = Segment)
) +
  geom_boxplot()+
  geom_label_repel(
    aes(label = TextLabel),
    na.rm = TRUE,
    nudge_x = c(-0.5, 0.5),
    nudge_y = c(170, 170),
    fill = "white",
    color = "black",
    fontface = "bold",
    label.size = 0.5,
    segment.color = "black",
    segment.size = 0.6,
    size = 4,
    direction = "both",
    force = 2
  ) +
  theme_minimal() +
  scale_x_discrete(guide = guide_axis(angle = 45)) +
  labs(
    title = "Top Segment by Average Customer Lifetime Value (CLV)",
    y = "Average CLV (£)",
    x = "Customer Segment"
  )

ggsave("visualizations/segment/fig_11_71_segment_clv.png",
       fig_11_71,width=9,height=6,dpi=300)

# 11.72 SEGMENT CHURN RATE
# Highlights attrition risk concentration

rfm_churn_rate <- readRDS(
  "data/processed/segment_churn_rate_assessment.rds"
)

fig_11_72 <- ggplot(rfm_churn_rate,
       aes(x=reorder(Segment,Percentage),
           y=Percentage,
           fill=Status))+
  geom_col(width=0.8)+
  theme_minimal()+
  theme(axis.text.x=element_text(angle=45))+
  labs(title="Proportion of Customer Status by Segment",
       y="Status Percentage (%)",
       x="Customer Segment")

ggsave("visualizations/segment/fig_11_72_segment_churn.png",
       fig_11_72,width=9,height=6,dpi=300)

# 11.73 SEGMENT AOV
# Measures purchasing efficiency and transaction value strength

segment_aov <- readRDS(
  "data/processed/segment_order_value_evaluation.rds"
)

fig_11_73 <- ggplot(
  segment_aov %>%
    mutate(
      HighlightPoints = AverageOrderValue == max(AverageOrderValue)|
      AverageOrderValue == min(AverageOrderValue),
      paste0(AverageOrderValue)
    ),
  aes(x = reorder(Segment, -AverageOrderValue),
      y = AverageOrderValue,
      fill = Segment)
) +
  geom_col(show.legend = FALSE, width = 0.8) +
  geom_label_repel(
    data = ~ dplyr::filter(.x, HighlightPoints),
    aes(label = paste0(AverageOrderValue)),
    nudge_x = c(-0.5, 0.5),
    nudge_y = c(100, 100),
    fill = "white",
    color = "black",
    fontface = "bold",
    label.size = 0.5,
    segment.color = "black",
    segment.size = 0.6,
    size = 4,
    direction = "both",
    force = 2
  ) +
  theme_minimal() +
  scale_x_discrete(guide = guide_axis(angle = 45)) +
  labs(
    title = "Top Segment by Average Order Value (AOV)",
    y = "Average Order Value (£)",
    x = "Customer Segment"
  )

ggsave("visualizations/segment/fig_11_73_segment_aov.png",
       fig_11_73,width=9,height=6,dpi=300)
