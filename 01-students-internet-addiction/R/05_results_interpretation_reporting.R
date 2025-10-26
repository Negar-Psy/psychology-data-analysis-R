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

# Load the odds ratio table saved from Script 04
OR_table <- read.csv("reports/odds_ratios.csv")

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
```

## Model Performance and Diagnostics
Model calibration and discrimination were assessed using several metrics:
- **Hosmer–Lemeshow goodness-of-fit test**  
- **McFadden pseudo R²**  
- **ROC curve and AUC**  
- **Variance Inflation Factors (VIF)** for multicollinearity  

### Hosmer-Lemeshow Test
```{r echo=FALSE}
library(ResourceSelection)

# Perform Hosmer-Lemeshow test
hoslem <- hoslem.test(model_logit$y, fitted(model_logit), g = 10)
hoslem
```
*The Hosmer-Lemeshow test evaluates the goodness-of-fit of the model. A p-value > 0.05 indicates a good fit.*

### Pseudo R²
```{r echo=FALSE}
# Print pseudo R² measures
library(pscl)
pseudo_r2 <- pR2(model_logit)
pseudo_r2
```
*McFadden's R² is one of the most commonly used pseudo-R² values for logistic regression models. Values closer to 1 indicate better fit.*
  
  ### ROC Curve
  ```{r echo=FALSE, out.width="70%", fig.align="center"}
knitr::include_graphics("reports/roc_curve.png")
```
*The ROC curve displays the trade-off between sensitivity and specificity. An AUC greater than 0.7 indicates that the model has acceptable discriminative ability.*
  
  ### Forest Plot of Odds Ratios
  ```{r echo=FALSE, out.width="70%", fig.align="center"}
knitr::include_graphics("reports/forest_plot_OR.png")
```
*The forest plot displays adjusted odds ratios and their 95% confidence intervals for each predictor. A value above 1.0 suggests an increase in the odds of CMD, while a value below 1.0 suggests a decrease.*
  
  ### Predicted Probability by IAT Score
  ```{r echo=FALSE, out.width="70%", fig.align="center"}
knitr::include_graphics("reports/predicted_prob_CMD_IAT.png")
```
*The predicted probability plot shows how the probability of CMD changes across the range of IAT scores for a typical student (female, age 18–24, undergraduate, health sciences).*
  
  # Interpretation
  Students with higher Internet Addiction Test scores showed **increased odds**
  of reporting symptoms consistent with a common mental disorder, even after
adjusting for demographics.

The logistic model provided an acceptable fit and reasonable discrimination
(AUC > 0.7).  The findings highlight problematic internet use as a
significant correlate of mental health outcomes among Malawian students.

# Reproducibility
All code and data are available at:
  [GitHub Repository](https://github.com/Negar-Psy/psychology-data-analysis-R)

```{r, echo=FALSE}
sessionInfo()
```
'

# 7.3 Write the RMarkdown text to a file ---
if (!dir.exists("reports")) dir.create("reports", recursive = TRUE)

writeLines(report_text, "reports/Project01_Report.Rmd")

# 7.4 Render the RMarkdown to HTML ---
rmarkdown::render("reports/Project01_Report.Rmd")

cat("
✅ HTML report successfully created at: reports/Project01_Report.html
")

#======================================================================

# End of Script 05

#======================================================================

