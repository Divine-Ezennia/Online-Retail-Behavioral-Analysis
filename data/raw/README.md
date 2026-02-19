# 📂 Raw Data — UCI Online Retail Dataset

## 1. Data Source & Provenance

The dataset used in this analysis is the **Online Retail Dataset** from the UCI Machine Learning Repository.
 
- **Direct Access Link:** [Online Retail](https://archive.ics.uci.edu/ml/datasets/Online+Retail)  
- **License:** Public academic dataset (UCI ML Repository usage terms apply)  

This dataset contains transactional records for a UK-based online retail store between December 2010 and December 2011.

---

## 2. Expected File Placement

After downloading the dataset from UCI:

Place the file inside: `data/raw/`  
Expected file name: `online_retail.csv`  

⚠️ Do not rename the file unless you also update the file path inside [scripts/01_data_loading.R](./scripts/01_data_loading.R).

---

## 3. Dataset Scope

- ~541,000+ transaction rows
- 8 original columns
- Time range: 01-Dec-2010 to 09-Dec-2011
- Geographic coverage: Primarily United Kingdom with international transactions

---

## 4. Schema (Original Columns)

| Column Name | Description |
|-------------|-------------|
| InvoiceNo   | Unique transaction identifier |
| StockCode   | Product code |
| Description | Product description |
| Quantity    | Number of units purchased |
| InvoiceDate | Timestamp of transaction |
| UnitPrice   | Price per unit |
| CustomerID  | Unique customer identifier |
| Country     | Customer country |

---

## 5. Important Notes

- Negative `Quantity` values represent product returns.
- Missing `CustomerID` values exist and are handled during preprocessing.
- Currency is GBP (£).

All cleaning, enrichment, and feature engineering steps are executed within the `scripts/` pipeline beginning at [scripts/01_data_loading.R](./scripts/01_data_loading.R)  

---

## 6. Reproducibility

To fully reproduce this project:

1. Download the dataset from the UCI link above.
2. Place it in `data/raw/`.
3. Execute scripts sequentially from [scripts/01_data_loading.R](./scripts/01_data_loading.R) through [11_visualization_engine.R](./11_visualization_engine.R).
