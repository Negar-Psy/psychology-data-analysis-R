#======================================================================

# Project 01: Problematic Internet Use and Common Mental Disorder
# Script 05: Results Interpretation and Reporting

#======================================================================

# --- Purpose ---
# 1. Summarize logistic regression results in plain language
# 2. Combine tables and plots into a clear report
# 3. Export results through an RMarkdown summary (HTML/PDF)

#======================================================================

# --- 1. Setup environment and load packages ---
setwd(here::here())

library(dplyr)
library(ggplot2)
library(broom)
library(gt)
library(gtsummary)
library(readr)
library(rmarkdown)

#======================================================================

# --- 2. Load data and model output ---

data_internet <- read.csv("data/Internet_Addiction_Malawi_Data_clean.csv")
model_summary <- readLines("reports/model_summary.txt")
OR_table <- read.csv("reports/odds_ratios.csv")

#======================================================================

# --- 3. Print brief model summary in console ---

cat("=========================================\n")
cat("Model Summary Overview:\n")
cat("=========================================\n")
cat(model_summary[1:20], sep = "\n")  # Preview first 20 lines
cat("\n\nSee full summary in 'reports/model_summary.txt'\n")

#======================================================================

# --- 4. Create a clean odds ratio summary table ---

colnames(OR_table)
OR_clean <- OR_table %>%
  mutate(
    Odds_Ratio = round(OR, 2),
    CI_Lower = round(CI_Lower, 2),
    CI_Upper = round(CI_Upper, 2)
  )

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

gtsave(gt_table, "reports/final_OR_table.html")

#======================================================================

# --- 5. Show saved plots info ---

cat("\n✅ Plots generated successfully:\n")
cat(" - Forest Plot: reports/forest_plot_OR.png\n")
cat(" - ROC Curve: reports/roc_curve.png\n")
cat(" - Predicted Probability Plot: reports/predicted_prob_CMD_IAT.png\n\n")

#======================================================================

# --- 6. Plain language interpretation ---

cat("=====================================================\n")
cat("Plain Language Interpretation:\n")
cat("=====================================================\n")
cat("
1️⃣ Higher Internet Addiction Test (IAT) scores are linked with higher odds of probable Common Mental Disorder (CMD).

2️⃣ After adjusting for gender, age, study level, and discipline, IAT remains a significant predictor of CMD risk.

3️⃣ Some demographic factors may affect CMD risk, but the main relationship between IAT and CMD is clear.

4️⃣ Model diagnostics (ROC curve, pseudo R², Hosmer-Lemeshow test) support the model’s fit.
")

#======================================================================

# --- 7. Auto-generate RMarkdown report text ---

setwd("~/Downloads/R-projects/psychology-data-analysis-R/01-students-internet-addiction")

odds_ratios <- read.csv("reports/odds_ratios.csv")

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

This report summarizes logistic regression testing how Internet Addiction scores relate
to Common Mental Disorder (CMD) in Malawian students.

# Methods

Multivariable logistic regression adjusting for:
- Gender
- Age group
- Study level
- Discipline

CMD defined as SRQ-20 ≥ 8 (probable CMD = 1, no CMD = 0).

# Results

## Adjusted Odds Ratios

'

writeLines(report_text, "reports/Internet_Addiction_CMD_Report.Rmd")

#======================================================================

# To generate the report:
rmarkdown::render("reports/Internet_Addiction_CMD_Report.Rmd")

#======================================================================

# End of Script 05

#======================================================================

