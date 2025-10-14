# R/02_setup_and_load.R

# Purpose: Load project packages and import cleaned analysis dataset

# Inputs:  data/Internet_Addiction_Malawi_Data_clean.csv

# Outputs: An in-memory tibble called `data_internet` for downstream scripts.



# --- Installing Packages ---

renv::install(c("readr", "dplyr", "stringr", "janitor", "here", "tidyr", "psych","ggplot2", "skimr"))

# --- Loading Packages ---
library(readr)   # For reading CSV files 
library(dplyr)   # For data manipulation 
library(stringr) # For text operations
library(janitor) # For cleaning data
library(here)   # For building file paths
library(tidyr) # For tidy dataset
library(psych) # For descriptive statistics
library(ggplot2) # For visualizations
library(skimr) # For quick data summaries

# --- Reading the Cleaned Dataset ---
data_path <- here("data", "Internet_Addiction_Malawi_Data_clean.csv")
data_internet <- read.csv(data_path)

# --- Quick Checks ---
message("Loaded file:", data_path)
rows <- nrow(data_internet)
cols <- ncol(data_internet)
message("Size:", "rows=", rows, ", ", "cols=", cols)

