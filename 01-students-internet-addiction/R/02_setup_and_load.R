# R/02_setup_and_load.R

# Purpose: Load project packages and import cleaned analysis dataset

# Inputs:  data/Internet_Addiction_Malawi_Data_clean.csv

# Outputs: An in-memory tibble called `data_internet` for downstream scripts.



# --- Installing Packages ---

renv::install(c("readr", "dplyr", "stringr", "janitor", "here", "tidyr"))

# --- Loading Packages ---
library(readr)    
library(dplyr)    
library(stringr)  
library(janitor)  
library(here)     
library(tidyr)

# --- Reading the Cleaned Dataset ---
data_path <- here("data", "Internet_Addiction_Malawi_Data_clean.csv")
data_internet <- read.csv(data_path)

# --- Quick Checks ---
message("Loaded file:", data_path)
rows <- nrow(data_internet)
cols <- ncol(data_internet)
message("Size:", "rows=", rows, ", ", "cols=", cols)
head(data_internet, n=10)
