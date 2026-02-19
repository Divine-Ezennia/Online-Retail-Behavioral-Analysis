# 🧠 Retail Behavioral Intelligence Engine (R Pipeline)

This directory contains the modular R scripts that transform raw Online Retail transactional data into a fully structured Behavioral Intelligence system.

The architecture follows a **Layered Analytical Engine**, ensuring:

- Deterministic execution
- Object persistence via `.rds` handoffs
- Reproducibility
- Clear analytical responsibility separation
- Click-through traceability via relative path references

## 🏗️ PIPELINE ARCHITECTURE

All scripts must be executed sequentially from 01 → 11.

### LAYER I — DATA FOUNDATION

#### 1. [01_data_loading.R](./01_data_loading.R)
**Purpose:** Loads raw Online Retail dataset and establishes base structure.

---

#### 2. [02_data_cleaning.R](./02_data_cleaning.R)
**Purpose:** Enforces data integrity.
- Removes invalid transactions
- Resolves missing values
- Standardizes structure

---

#### 3. [03_data_enrichment.R](./03_data_enrichment.R)
**Purpose:** Feature engineering & metric construction.
- Hour, Day, WeekPart, Month extraction
- Revenue computation
- Product label standardization

**Primary Output:**
`data/processed/online_retail_enriched.rds`

### LAYER II — CORE METRICS FOUNDATION

#### 4. [04_foundational_metrics.R](./04_foundational_metrics.R)
Establishes base KPIs:
- Total Unique Products
- Total Orders
- Total Order Lines

### LAYER III — PRODUCT INTELLIGENCE

#### 5. [05_product_performance_analysis.R](./05_product_performance_analysis.R)

Evaluates:
- Top/Bottom Products (Quantity)
- Revenue Leaders
- Purchasing Intensity
- Order Frequency

### LAYER IV — TEMPORAL INTELLIGENCE

#### 6. [06_temporal_dynamics_analysis.R](./06_temporal_dynamics_analysis.R)

Breakdown across:
- Hour
- Day
- WeekPart
- Month

Metrics:
- Quantity (Total / Average)
- Revenue (Total / Average)
- Order / Order Line Frequency

### LAYER V — GEOGRAPHIC INTELLIGENCE

#### 7. [07_geographic_country_analysis.R](./07_geographic_country_analysis.R)

Country-level evaluation across:
- Total Quantity
- Average Quantity
- Total Revenue
- Average Revenue
- Order Volume
- Order Line Density

### LAYER VI — CROSS-DIMENSIONAL PRODUCT INTELLIGENCE

#### 8. [08_cross_dimensional_product_analysis.R](./08_cross_dimensional_product_analysis.R)

Identifies Top 2 products across:

- Hour
- Day
- WeekPart
- Month
- Country

Evaluates:
- Quantity
- Revenue
- Order Frequency

### LAYER VII — SEGMENT INTELLIGENCE ENGINE

#### 9. [09_rfm_segmentation_engine.R](./09_rfm_segmentation_engine.R)

Builds RFM model and assigns behavioral segments.

**Output:**
`data/processed/rfm_scored_customers.rds`

---

#### 10. [10_segment_intelligence_engine.R](./10_segment_intelligence_engine.R)

Advanced behavioral analytics:
- Segment Structural Metrics
- Segment Revenue & Order Distribution
- Segment × Product Intelligence
- Segment × Geographic Intelligence
- CLV Evaluation
- Churn Assessment
- Average Order Value (AOV)

### LAYER VIII — VISUALIZATION ENGINE

#### 11. [11_visualization_engine.R](./11_visualization_engine.R)

Deterministically reconstructs visuals from processed objects.

- Reads `.rds` outputs
- Generates `.png` assets
- Maintains figure numbering consistency
- Stores under `visualizations/`

## 🔄 EXECUTION STANDARD

To reproduce the complete analytical engine:

1. Execute scripts sequentially from 01 → 11.
2. Do not skip layers.
3. Each script writes to `data/processed/`.
4. Visualization engine depends strictly on persisted `.rds` objects.

## 📁 OBJECT FLOW ARCHITECTURE

Raw Data  
→ Cleaning  
→ Enrichment  
→ Processed `.rds` Objects  
→ Visualization Engine  
→ `.png` Intelligence Assets  

No script relies on workspace inheritance.

## 🧩 ENGINEERING PRINCIPLES

- Modular Intelligence Layers
- Object-Based Handoff
- Deterministic Rebuild
- Clickable Traceability
- Production-Grade Documentation
- Behavioral Intelligence Architecture

## 🚀 ENVIRONMENT

Language: R  
Core Libraries: tidyverse, ggplot2, dplyr, lubridate, ggrepel, sf, rnaturalearthdata, rnaturalearth  
Output Formats:
- `.rds` → Data Persistence
- `.png` → Visual Artifacts

This system transforms raw transactional data into a reproducible Behavioral Intelligence Engine suitable for executive reporting and portfolio-grade technical review.
