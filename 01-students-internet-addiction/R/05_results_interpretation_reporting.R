#======================================================================

# Project 01: Problematic Internet Use and Common Mental Disorder
# Script 05: Results Interpretation and Reporting

#======================================================================

# --- Purpose ---
#   1. Summarize model results in plain language
#   2. Combine tables and plots into a compact report
#   3. Export results as an RMarkdown summary (HTML/PDF)

#======================================================================

# --- 1. Setting up the environment ---
setwd(here::here())

# --- Loading needed packages ---
library(dplyr)
library(ggplot2)
library(broom)
library(gt)
library(gtsummary)
library(readr)
library(rmarkdown)

#======================================================================

# --- 2. Load model outputs and data ---

# Load the cleaned dataset (used for plotting and context)
data_internet <- read.csv("data/Internet_Addiction_Malawi_Data_clean.csv")

# Load saved model results (generated in Script 04)
model_summary <- readLines("reports/model_summary.txt")

# Load odds ratios table
OR_table <- read.csv("reports/odds_ratios.csv")

#======================================================================

# --- 3. Print a short summary to the console ---

cat("=========================================\n")
cat("Model Summary Overview:\n")
cat("=========================================\n")
cat(model_summary[1:20], sep = "\n")  # only preview first 20 lines
cat("\n\nFor full summary, see 'reports/model_summary.txt'\n")

#======================================================================

# --- 4. Create an easy-to-read summary table ---

# Select and rename useful columns
OR_clean <- OR_table %>%
  rename(
    Predictor = X,
    Odds_Ratio = OR,
    CI_Lower = `X2.5..`,
    CI_Upper = `X97.5..`
  ) %>%
  mutate(
    Odds_Ratio = round(Odds_Ratio, 2),
    CI_Lower = round(CI_Lower, 2),
    CI_Upper = round(CI_Upper, 2)
  )

# Create a nice GT table
gt_table <- gt(OR_clean) %>%
  tab_header(
    title = "Adjusted Odds Ratios for Common Mental Disorder (CMD)",
    subtitle = "Logistic regression controlling for demographics"
  ) %>%
  fmt_number(columns = c(Odds_Ratio, CI_Lower, CI_Upper), decimals = 2) %>%
  cols_label(
    Predictor = "Predictor",
    Odds_Ratio = "OR",
    CI_Lower = "Lower 95% CI",
    CI_Upper = "Upper 95% CI"
  ) %>%
  tab_source_note("Note: OR > 1 means higher odds of CMD; OR < 1 means lower odds.")

# Save table as HTML
gtsave(gt_table, "reports/final_OR_table.html")

#======================================================================

# --- 5. Load and display plots created earlier ---

cat("\n✅ Plots generated successfully:\n")
cat(" - Forest Plot: reports/forest_plot_OR.png\n")
cat(" - ROC Curve: reports/roc_curve.png\n")
cat(" - Predicted Probability Plot: reports/predicted_prob_CMD_IAT.png\n\n")

#======================================================================

# --- 6. Simple Interpretation in Plain English ---

cat("=====================================================\n")
cat("Plain Language Interpretation:\n")
cat("=====================================================\n")
cat("
1️⃣ The analysis examined whether higher Internet Addiction (IAT) scores
   are linked with higher odds of having probable Common Mental Disorder (CMD).

2️⃣ After adjusting for gender, age group, study level, and discipline:
   - A higher IAT score was associated with increased odds of CMD.
   - This means students with more signs of problematic internet use were
     more likely to report mental distress.

3️⃣ Some demographic variables (like gender or study level) may also
   influence CMD risk, but the main relationship between IAT and CMD remains significant.

4️⃣ Model diagnostics (ROC curve, pseudo R², and Hosmer–Lemeshow test)
   suggested the model fits the data reasonably well.
")

#======================================================================

# --- 7. Creating an automatic HTML report (RMarkdown) ---

# 7.1 Load libraries
library(rmarkdown)

# Set the correct working directory so RMarkdown can find the file
setwd("~/Downloads/R-projects/psychology-data-analysis-R/01-students-internet-addiction")  # Adjust to your actual project path

# Read the odds_ratios.csv file explicitly (absolute path, no relative path)
odds_ratios <- read.csv("reports/odds_ratios.csv")  # Relative path works once setwd() is used

# 7.2 Define the RMarkdown text to be created ---
report_text <- '
---
title: "Project 01: Internet Addiction and Common Mental Disorder"
author: "Negar Alizadeh"
date: "`r Sys.Date()`"
output:
  html_document:
    toc: true
    toc_depth: 2
    toc_float: true
    number_sections: true
---

# Introduction
This report summarizes the results from the logistic regression analysis
examining whether higher Internet Addiction Test (IAT) scores are linked with
higher odds of probable Common Mental Disorder (CMD) among Malawian students.

# Methods
A multivariable logistic regression was used, adjusting for:
- Gender  
- Age group  
- Study level  
- Discipline  

CMD was defined as **SRQ-20 ≥ 8**, coded as 1 = probable CMD, 0 = no CMD.

# Results

This section presents the results from the multivariable logistic regression
analysis examining whether higher Internet Addiction Test (IAT) scores are
associated with higher odds of probable CMD, after adjusting for demographic factors.

## Adjusted Odds Ratios
```{r results="asis", echo=FALSE, message=FALSE, warning=FALSE}
library(readr)
library(dplyr)
library(gt)

# Use the odds_ratios data that was read earlier
OR_table <- odds_ratios  # This ensures the odds_ratios.csv file is being used

# Clean and format for readability
OR_clean <- OR_table %>%
  rename(
    Predictor = X,
    Odds_Ratio = OR,
    CI_Lower = `X2.5..`,
    CI_Upper = `X97.5..`
  ) %>%
  mutate(
    Odds_Ratio = round(Odds_Ratio, 2),
    CI_Lower = round(CI_Lower, 2),
    CI_Upper = round(CI_Upper, 2)
  )

# Generate GT table
gt(OR_clean) %>%
  tab_header(
    title = "Adjusted Odds Ratios for Common Mental Disorder (CMD)",
    subtitle = "Results from multivariable logistic regression model"
  ) %>%
  cols_label(
    Predictor = "Predictor",
    Odds_Ratio = "Odds Ratio (OR)",
    CI_Lower = "Lower 95% CI",
    CI_Upper = "Upper 95% CI"
  ) %>%
  fmt_number(columns = c(Odds_Ratio, CI_Lower, CI_Upper), decimals = 2) %>%
  tab_source_note("Note: OR > 1 indicates higher odds of CMD; OR < 1 indicates lower odds.")


#======================================================================

# End of Script 05

#======================================================================

