#====================================================================

# --- Project 01: Internet Addiction and Common Mental Disorders Among Students ---
# --- Script: 01_download_clean_prepare_data.R ---

#======================================================================

# --- Purpose: ---
#   - Download and load the dataset from Mendeley Data.
#   - Clean and recode IAT and SRQ questionnaire items.
#   - Calculate total IAT and SRQ-20 scores for each participant.
#   - Create the CMD variable (1 = probable CMD, 0 = no CMD).
#   - Save the cleaned dataset for further analysis.
#
#   This script prepares all main variables needed for exploration
#   and statistical analysis in the next steps.

#======================================================================

# --- Installing required packages ---
renv::install(c("readr","dplyr","stringr","janitor","here", "tidyr"))

#======================================================================

# --- Loading required packages ---

library(readr)  # for reading csv files
library(dplyr)  # for data manipulation
library(stringr)  # for handling string data
library(janitor)  # for easy data cleaning
library(here)  # for reliable paths across projects
library(tidyr)  # for reshaping data

#======================================================================

# --- Reading raw data ---
raw_data <- read_csv(here("data-raw", "Internet_Addiction_Malawi_Data.csv"))

#======================================================================
  
# --- Quick checking ---
glimpse(raw_data)
head(raw_data)

#======================================================================
  
# --- Checking original column names ---
colnames(raw_data)

#======================================================================
  
# --- Renaming columns for readability ---
new_data <- raw_data %>%
  rename(
    id=SN, 
    gender=Gender, 
    age_group=`Age group`, 
    institution_name = `University/College`, 
    study_level= `Level of Study`, 
    year_of_study = `Indicate your year of study`, 
    discipline=`Indicate your discipline of study`, 
    unknown=...48)

colnames(new_data) [8:27] <- paste0("iat_", 1:20)
colnames(new_data) [28:47] <- paste0("srq_", 1:20)
colnames(new_data)

#======================================================================
  
# --- Cleaning Columns ---
# --- Cleaning gender column ---
# --- Identifying all unique responses in gender ---
unique_gender_responses <- new_data %>%
  select(gender) %>%
  unlist () %>%
  unique() 
print(unique_gender_responses)

# --- Cleaning "prefer not to say" responses in gender ---
new_data <- new_data %>%
  mutate(gender= na_if(gender, "Prefer Not to Say"))

# --- Converting gender to factor with 2 levels ---
new_data <- new_data %>%
  mutate(gender = as.factor(gender))

# --- Checking gender factor levels ---
levels(new_data$gender)

#======================================================================

# --- Cleaning age_group column ---
# --- Identifying all the unique responses in age_group ---

unique_age_responses <- new_data %>%
  select(age_group) %>%
  unlist() %>%
  unique()
print(unique_age_responses)
  
# --- Cleaning "9=Missing" responses ---
new_data <- new_data %>%
mutate(age_group= na_if(age_group, "9=Missing"))

# --- Converting age_group to a factor variable with 6 levels ---
new_data <- new_data %>%
  mutate(age_group = as.factor(age_group))

# --- Checking age_group levels ---
levels(new_data$age_group)

#======================================================================

# --- Cleaning study_level column ---
# --- Identifying all the unique responses in study_level ---
unique_study_responses <- new_data %>%
  select(study_level) %>%
  unlist() %>%
  unique() 
print(unique_study_responses)

# --- Cleaning "7=Missing" responses ---
new_data <- new_data %>%
  mutate(study_level = na_if(study_level, "7=Missing"))

# --- Converting study_level to a factor variable with 2 levels ---
new_data <- new_data %>%
  mutate(study_level = as.factor(study_level))

# --- Checking age_group levels ---
levels(new_data$study_level)

#======================================================================

# --- Cleaning year_of_study column ---
# --- Identifying all the unique responses in year_of_study 
unique_year_responses <- new_data %>%
  select(year_of_study) %>%
  unlist() %>%
  unique()
print(unique_year_responses)

# --- Cleaning "7=Missing" responses ---
new_data <- new_data %>%
  mutate(year_of_study = na_if(year_of_study, "7=Missing"))

# --- Converting year_of_study to a factor variable with 5 levels ---
new_data <- new_data %>%
  mutate(year_of_study = as.factor(year_of_study))

# --- Checking year_of_study levels ---
levels(new_data$study_level)

#======================================================================  

# --- Cleaning IAT items ---    
# --- Identifying all unique response categories from IAT items ---
unique_iat_responses <- new_data %>%
  select(starts_with("iat_")) %>%
  unlist() %>%
  unique()
print(unique_iat_responses)

# --- Extracting numeric codes from strings ---
new_data <- new_data %>%
  mutate(across(starts_with("iat_"),
                ~ as.numeric(str_extract(as.character(.), "[0-9]+"))))

# --- Replacing invalid codes (0 and 99) with NA ---
new_data <- new_data %>%
  mutate(across(starts_with("iat_"),
                ~ ifelse(. %in% c(0, 99), NA, .)))

# --- Checking IAT responses ---
summary(select(new_data, starts_with("iat_")))
unique(unlist(select(new_data, starts_with("iat_"))))
head(select(new_data, starts_with("iat_")))

#======================================================================
  
# --- Identifying all unique response categories from SRQ items ---
unique_srq_responses <- new_data %>%
  select(starts_with("srq_")) %>%
  unlist() %>%
  unique()
print(unique_srq_responses)

new_data <- new_data %>%
  mutate(across(starts_with("srq_"),
                ~ as.numeric(case_when(
                  . %in% c("1", 1, "Yes", "TRUE") ~ 1,      # Mark "Yes"/1 as 1
                  . %in% c("0", 0, "No", "FALSE") ~ 0,      # Mark "No"/0 as 0
                  str_detect(as.character(.), "7") ~ NA_real_, # Treat "7=Missing" as NA
                  TRUE ~ as.numeric(str_extract(as.character(.), "[0-9]+")) # Extract digits if any remain
                ))))

# --- Checking SRQ responses ---
unique(unlist(select(new_data, starts_with("srq_"))))

#======================================================================

# --- Checking the types of all the variables ---
sapply(select(new_data, starts_with("iat_")), class)
sapply(select(new_data, starts_with("srq_")), class)

#======================================================================

# --- Computing total SRQ number and CMD variable (Common Mental Disorder) --- 
new_data <- new_data %>%
  mutate(
    total_srq = rowSums(select(., starts_with("srq_")), na.rm = TRUE),
    CMD_bin   = ifelse(total_srq >= 8, 1, 0))

# --- Checking CMD variation --- 
summary(data_internet$total_srq)
table(data_internet$CMD_bin)

#======================================================================

# --- Saving clean data ---
dir.create(here("data"), showWarnings = FALSE)
write.csv(new_data, here("data", "Internet_Addiction_Malawi_Data_clean.csv"))

#======================================================================

# --- End of Script 01 ---

#======================================================================
