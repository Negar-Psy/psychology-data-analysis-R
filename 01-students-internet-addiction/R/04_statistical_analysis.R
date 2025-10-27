#======================================================================

# Project 01: Internet Addiction and Common Mental Disorders in Students
# Script 04: Model Fitting and Results Generation

#======================================================================

# --- Purpose ---
# 1. Load the cleaned data.
# 2. Fit a logistic regression model to test whether internet addiction 
#    predicts common mental disorder (CMD).
# 3. Summarize model results in simple tables and plots.
# 4. Save results for reporting (Script 05).

#======================================================================

# --- 1. Load libraries ---

library(dplyr)         # For data manipulation
library(ggplot2)       # For visual plots
library(broom)         # For tidy model summaries
library(gt)            # For clean summary tables
library(gtsummary)     # For neat regression output
library(readr)         # For reading CSV files
library(here)          # For safe, consistent paths

#======================================================================

# --- 2. Load cleaned dataset ---

data_path <- here("data", "Internet_Addiction_Malawi_Data_clean.csv")
data_internet <- read_csv(data_path)

message("✅ Data successfully loaded from: ", data_path)
message("Rows: ", nrow(data_internet), " | Columns: ", ncol(data_internet))

#======================================================================

# --- 3. Quick check of important variables ---

names(data_internet)
summary(select(data_internet, total_srq, CMD_bin))
summary(select(data_internet, starts_with("iat_")))
table(data_internet$gender)
table(data_internet$age_group)

#======================================================================

# --- 4. Build logistic regression model ---

# The outcome variable: CMD_bin (1 = probable CMD, 0 = no CMD)
# The main predictor: total IAT score
# Covariates: gender, age group, study level, discipline

model_CMD <- glm(
  CMD_bin ~ total_iat + gender + age_group + study_level + discipline,
  data = data_internet,
  family = binomial(link = "logit")
)

# --- View and interpret results ---

summary(model_CMD)

#======================================================================

# --- 5. Summarize model results ---

# --- Print a clear summary in the console ----
cat("\n=================== Logistic Regression Summary ===================\n")
print(summary(model_CMD))
cat("\n===================================================================\n")

# Save a plain text version of the model summary
summary_text <- capture.output(summary(model_CMD))
writeLines(summary_text, here("reports", "model_summary.txt"))
message("📄 Model summary saved: reports/model_summary.txt")

#======================================================================
# --- 6. Calculate Odds Ratios and Confidence Intervals ---

odds_ratios <- broom::tidy(model_CMD, exponentiate = TRUE, conf.int = TRUE) %>%
  rename(
    Predictor = term,
    OR = estimate,
    CI_Lower = conf.low,
    CI_Upper = conf.high
  ) %>%
  mutate(
    OR = round(OR, 2),
    CI_Lower = round(CI_Lower, 2),
    CI_Upper = round(CI_Upper, 2)
  )

# Preview in console
cat("\nSummary of Odds Ratios:\n")
print(odds_ratios)

# Save results for Script 05
write_csv(odds_ratios, here("reports", "odds_ratios.csv"))
message("✅ Odds ratios saved: reports/odds_ratios.csv")

#======================================================================
# --- 7. Create simple plots for visualization ---

# Forest plot of Odds Ratios
forest_plot <- ggplot(odds_ratios, aes(x = reorder(Predictor, OR), y = OR)) +
  geom_point(color = "blue", size = 3) +
  geom_errorbar(aes(ymin = CI_Lower, ymax = CI_Upper), width = 0.2) +
  coord_flip() +
  labs(
    title = "Adjusted Odds Ratios for CMD",
    x = "Predictor",
    y = "Odds Ratio (95% CI)"
  ) +
  theme_minimal()

ggsave(
  here("reports", "forest_plot_OR.png"),
  forest_plot,
  width = 7,
  height = 5
)
message("📊 Forest plot saved: reports/forest_plot_OR.png")

#======================================================================
# --- 8. Model performance (goodness of fit) ---

# Calculate pseudo R-squared and ROC-like diagnostics
library(pscl)
fit_quality <- pscl::pR2(model_CMD)

cat("\nPseudo R-squared values:\n")
print(fit_quality)

#======================================================================
# --- 9. Save predictions for visualization ---

data_clean <- data_internet %>%
  filter(
    !is.na(total_iat) &
      !is.na(gender) &
      !is.na(age_group) &
      !is.na(study_level) &
      !is.na(discipline) &
      !is.na(CMD_bin)
  )
model_CMD <- glm(
  CMD_bin ~ total_iat + gender + age_group + study_level + discipline,
  data = data_clean,
  family = binomial(link = "logit")
)

data_clean <- data_clean %>%
  mutate(
    predicted_prob = predict(model_CMD, type = "response")
  )



# Plot predicted probabilities vs IAT score
prob_plot <- ggplot(data_clean, aes(x = total_iat, y = predicted_prob)) +
  geom_point(color = "steelblue", alpha = 0.6) +
  geom_smooth(method = "loess", se = TRUE, color = "red") +
  theme_minimal() +
  labs(
    title = "Predicted Probability of CMD by Internet Addiction Score",
    x = "Internet Addiction (IAT Total)",
    y = "Predicted Probability of CMD"
  )


ggsave(
  here("reports", "predicted_prob_CMD_IAT.png"),
  prob_plot,
  width = 7,
  height = 5
)
message("✅ Predicted probability plot saved: reports/predicted_prob_CMD_IAT.png")

#======================================================================
# --- 10. Save everything cleanly for Script 05 ---

save(model_CMD, file = here("reports", "logistic_model_CMD.RData"))
message("💾 Model object saved: reports/logistic_model_CMD.RData")

#======================================================================
# --- End of Script 04 ---
#======================================================================
