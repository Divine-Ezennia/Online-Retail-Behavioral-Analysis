# ============================================================
# STEP 1: DATA LOADING & INITIALIZATION
# Project: Online Retail Behavioral Analysis
# Description: Importing the raw UK-based online retail dataset 
#              for downstream modular processing.
# Data Scope: Transaction-level retail data (Dec 2010 – Dec 2011)
# Source: UCI Machine Learning Repository (local CSV copy)
# Data Dependencies:
#   Input:  data/raw/online_retail.csv
#   Output: data/processed/online_retail_loaded.rds
# ============================================================

# LOAD REQUIRED LIBRARIES
library(tidyverse)
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)
library(ggrepel)

# IMPORT RAW DATASET
retail_data <- read.csv("data/raw/online_retail.csv")

# PERSIST LOADED DATA OBJECT
# The loaded dataset is saved in RDS format to:
# 1. Preserve original structure
# 2. Prevent repeated CSV parsing
# 3. Serve as stable input for cleaning layer

saveRDS(retail_data, "data/processed/online_retail_loaded.rds")
