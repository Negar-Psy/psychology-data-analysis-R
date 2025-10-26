#====================================================================

# --- Project 01: Internet Addiction and Common Mental Disorders Among Students ---
# --- Script: 02_setup_and_load_cleaned_data.R ---

#======================================================================

# --- Purpose: ---
#   - Set up the R environment and required packages.
#   - Load the cleaned dataset created in Script 01.
#   - Check variable structure, types, and missing values.
#   - Prepare data for exploration and descriptive analysis.
#
#   This script ensures the workspace is ready and the data
#   is correctly loaded for the next analysis steps.

#======================================================================

# --- Installing and loading packages ---

renv::install(c("readr", "dplyr", "stringr", "janitor", "here", "tidyr", "psych","ggplot2", "skimr"))

library(readr)   # For reading CSV files 
library(dplyr)   # For data manipulation 
library(stringr) # For text operations
library(janitor) # For cleaning data
library(here)   # For building file paths
library(tidyr) # For tidy dataset
library(psych) # For descriptive statistics
library(ggplot2) # For visualizations
library(skimr) # For quick data summaries

#======================================================================
  
# --- Reading the cleaned dataset ---
data_path <- here("data", "Internet_Addiction_Malawi_Data_clean.csv")
data_internet <- read.csv(data_path)

#======================================================================
  
# --- Quick checks ---
message("Loaded file:", data_path)
rows <- nrow(data_internet)
cols <- ncol(data_internet)
message("Size:", "rows=", rows, ", ", "cols=", cols)

#======================================================================

# --- End of Script 02 ---

#======================================================================