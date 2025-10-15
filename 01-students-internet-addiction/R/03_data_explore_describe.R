# R/03_data_explore_and_describe.R

# Purpose: Explore and describe the cleaned dataset


# -----------------------------------------------

# --- Cleaning the environment ---
rm(list = ls())
setwd(here::here())

# --- Looking at data ---
View(data_internet)
head(data_internet)
summary(data_internet)

# --- Checking variable types ---
str(data_internet)

# --- Seting categorical variables as factors ---
data_internet <- data_internet %>%
  mutate(gender = as.factor(gender),
         age = as.factor(age),
         study_level = as.factor(study_level),
         discipline = as.factor(discipline))
str(data_internet)

# --- Descriptive statistics for numberic variables ---

# --- Creating IAT and SRQ total scores ---

data_internet <- data_internet %>%
  mutate(
    total_iat = rowSums(select(., starts_with("iat_")), na.rm = TRUE),
    total_srq = rowSums(select(., starts_with("srq_")), na.rm = TRUE))
         
numeric_summary <- describe(select(data_internet, total_iat, total_srq))
numeric_summary

# --- Frequency tables for categorical variables ---
gender_table <- data_internet %>%
  count(gender)
print(gender_table)

age_table <- data_internet %>%
  count(age)
print(age_table)
