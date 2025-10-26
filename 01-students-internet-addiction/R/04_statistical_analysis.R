#======================================================================

# Project 01: Problematic Internet Use and Common Mental Disorder
# Script 04: Statistical Analysis (Multivariable Logistic Regression)

#======================================================================
# --- Purpose ---
#   1. Fit a multivariable logistic regression model
#   2. Evaluate model fit and assumptions
#   3. Compute and interpret odds ratios (ORs)
#   4. Visualize the main findings

#======================================================================

# Data input: data_internet (from 03_data_explore_and_describe.R)
# Outputs: model summaries, odds ratio tables, diagnostic plots

#======================================================================

# --- 1. Setting the environment ---
setwd(here::here())

# --- Installing and loading required packages ---

renv::install(c("dplyr", "ggplot2", "broom", "car", "ResourceSelection", "pscl", "pROC", "gtsummary", "forcats", "logistf"))

library(dplyr)            # for data cleaning, transformation, and manipulation
library(ggplot2)          # for creating plots and visualizations
library(broom)            # for tidying and organizing model outputs
library(car)              # for checking multicollinearity (VIF) and regression diagnostics
library(ResourceSelection) # for Hosmer–Lemeshow goodness-of-fit test
library(pscl)             # for pseudo R² measures (model fit indices)
library(pROC)             # for ROC curve plotting and AUC calculation
library(gtsummary)        # for clean, publication-ready regression tables
library(forcats)          # for handling and simplifying categorical variables (factors)
library(logistf)          # for Firth logistic regression

#======================================================================

# --- 2. Defining the outcome variable (CMD) ---

# Ensure CMD variable exists and coded correctly
# CMD = 1 if SRQ-20 total ≥ 8, otherwise 0
if (!"CMD_bin" %in% names(data_internet)) {
  data_internet <- data_internet %>%
    mutate(CMD_bin = ifelse(total_srq >= 8, 1, 0))
}

table(data_internet$CMD_bin)

#======================================================================

# --- 3. Quick checking ---
hist(data_internet$total_iat,
     main = "Distribution of IAT Total Scores",
     xlab = "IAT Total",
     col = "skyblue", border = "black")

prop.table(table(data_internet$CMD_bin))

#======================================================================

# --- 4. Fitting logistic regression model --------------------------
# Predict CMD (1 = probable CMD) from IAT + demographics

# Standardize IAT
data_internet <- data_internet %>%
  mutate(total_iat_z = scale(total_iat))

# Merge small groups into "Other"
data_internet <- data_internet %>%
  mutate(
    study_level = fct_lump_min(study_level, min = 10),
    discipline  = fct_lump_min(discipline,  min = 10),
    age_group   = fct_lump_min(age_group,   min = 10)
  )

# Fit model
model_logit <- glm(CMD_bin ~ total_iat_z + gender + age_group + study_level + discipline,
                   data = data_internet,
                   family = binomial)

# If not converged, use Firth logistic regression
if(!model_logit$converged){
  message("⚠️ glm did not converge — switching to Firth regression.")
  model_logit <- logistf(CMD_bin ~ total_iat_z + gender + age_group + study_level + discipline,
                         data = data_internet)
}

summary(model_logit)
#======================================================================

# --- 4. View and interpret results ---
summary(model_logit)

# Coefficients are in log-odds (logarithmic scale).
# Positive coefficients → higher odds of CMD.
# Negative coefficients → lower odds of CMD.

#======================================================================

# --- 5. Odds Ratios ---
OR_table <- exp(cbind(OR = coef(model_logit),
                      confint(model_logit)))  # 95% CI
print(OR_table)

write.csv(OR_table, "reports/odds_ratios.csv", row.names = TRUE)

#======================================================================

# --- 6. Regression table ------

if (inherits(model_logit, "logistf")) {
  reg_table <- tbl_regression(model_logit,
                              exponentiate = TRUE,
                              tidy_fun = broom.helpers::tidy_parameters)
} else {
  reg_table <- tbl_regression(model_logit, exponentiate = TRUE)
}

reg_table <- reg_table %>% bold_labels()

as_gt(reg_table) %>%
  gt::gtsave("reports/regression_table.html")

#======================================================================

# --- 7. Diagnostics ---

# 7.1 Multicollinearity (VIF)

if (inherits(model_logit, "glm")) {
  hoslem <- ResourceSelection::hoslem.test(model_logit$y, fitted(model_logit), g = 10)
  print(hoslem)
} else if (inherits(model_logit, "logistf")) {
  message("ℹ Hosmer–Lemeshow test not available for Firth logistic regression.")
}

# --- 7.2Hosmer–Lemeshow goodness-of-fit test ---

if (inherits(model_logit, "glm")) {
  
  hoslem <- ResourceSelection::hoslem.test(
    model_logit$y, 
    fitted(model_logit),
    g = 10
  )
  
  print(hoslem)
  
} else if (inherits(model_logit, "logistf")) {
  message("ℹ Hosmer–Lemeshow test not available for Firth logistic regression (logistf). Skipped.")
}


# 7.3 Pseudo R²

if (inherits(model_logit, "glm")) print(pscl::pR2(model_logit))

# 7.4 ROC curve and AUC

if (inherits(model_logit, "glm")) {
  
  roc_obj <- pROC::roc(model_logit$y, fitted(model_logit))
  plot(roc_obj, col = "blue", main = "ROC Curve for CMD Model")
  print(paste("AUC =", round(pROC::auc(roc_obj), 3)))
  
  ggplot2::ggsave("reports/roc_curve.png")
  
} else if (inherits(model_logit, "logistf")) {
  message("ℹ ROC/AUC not available for Firth logistic regression (logistf). Skipped.")
}

#======================================================================

# --- 8. Forest Plot (Odds Ratios) ---
model_tidy <- broom::tidy(model_logit, exponentiate = TRUE, conf.int = TRUE)

ggplot(model_tidy, aes(x = reorder(term, estimate), y = estimate)) +
  geom_pointrange(aes(ymin = conf.low, ymax = conf.high), color = "darkred") +
  geom_hline(yintercept = 1, linetype = "dashed") +
  coord_flip() +
  labs(title = "Adjusted Odds Ratios for CMD",
       x = "Predictor",
       y = "Odds Ratio (95% CI)") +
  theme_minimal()

ggsave("reports/forest_plot_OR.png", width = 6, height = 4)

#======================================================================

# --- 9. Predicted probabilities ---
new_data <- data.frame(
  total_iat = seq(min(data_internet$total_iat, na.rm = TRUE),
                  max(data_internet$total_iat, na.rm = TRUE),
                  length.out = 100),
  gender = "Female",
  age_group = "18-24",
  study_level = "Undergraduate",
  discipline = "Health Sciences")

new_data$predicted_prob <- predict(model_logit, new_data, type = "response")

ggplot(new_data, aes(x = total_iat, y = predicted_prob)) +
  geom_line(color = "blue", size = 1.2) +
  labs(title = "Predicted Probability of CMD by IAT Score",
       x = "IAT Total Score",
       y = "Predicted Probability of CMD") +
  theme_light()

ggsave("reports/predicted_prob_CMD_IAT.png", width = 6, height = 4)

#======================================================================

# --- 10. Saving outputs for reproducibility ---

capture.output(summary(model_logit),
               file = "reports/model_summary.txt")

capture.output(sessionInfo(),
               file = "reports/session_info.txt")

#======================================================================

# --- 11. Session info ---
sessionInfo()

#======================================================================

# End of Script 04

#======================================================================
