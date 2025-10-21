# --- Installing required packages ---
renv::install(c("readr","dplyr","stringr","janitor","here", "tidyr"))

-----------------------------------------------------------------------

# --- Loading required packages ---

library(readr)  # for reading csv files
library(dplyr)  # for data manipulation
library(stringr)  # for handling string data
library(janitor)  # for easy data cleaning
library(here)  # for reliable paths across projects
library(tidyr)  # for reshaping data

-----------------------------------------------------------------------

# --- Reading raw data ---
raw_data <- read_csv(here("data-raw", "Internet_Addiction_Malawi_Data.csv"))

-----------------------------------------------------------------------
  
# --- Quick checking ---
glimpse(raw_data)
head(raw_data)

-----------------------------------------------------------------------
  
# --- Checking original column names ---
colnames(raw_data)

-----------------------------------------------------------------------
  
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

-----------------------------------------------------------------------
  
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

-----------------------------------------------------------------------

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

-----------------------------------------------------------------------

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

-----------------------------------------------------------------------

# --- Cleaning year_of_study column ---
# --- Identifying all the unique responses in year_of_study 
unique_year_responses <- new_data %>%
  select(year_of_study) %>%
  unlist() %>%
  unique() %>%
print(unique_year_responses)

# --- Cleaning "7=Missing" responses ---
new_data <- new_data %>%
  mutate(year_of_study = na_if(year_of_study, "7=Missing"))

# --- Converting year_of_study to a factor variable with 5 levels ---
new_data <- new_data %>%
  mutate(year_of_study = as.factor(year_of_study))

# --- Checking year_of_study levels ---
levels(new_data$study_level)
------------------------------------------------------------------------  
    
# --- Identifying all unique response categories from IAT items ---
unique_iat_responses <- new_data %>%
  select(starts_with("iat_")) %>%
  unlist() %>%
  unique()
print(unique_iat_responses)
  
# --- Cleaning IAT responses ---

iat_map <- c ("1=Rarely" = 1,
              "2=Occasionally" = 2,
              "3=Frequently" = 3,
              "4=Often" = 4,
              "5=Always"=5,
              "0=Does not Apply" = NA_real_,
              "99=Missing" = NA_real_,
              "NA" = NA)
new_data <- new_data %>%
  mutate(across(starts_with("iat_"), ~ {x <- str_trim(as.character(.x))
  unname(iat_map[x]) }))

head(select(new_data, starts_with("iat_")))

-----------------------------------------------------------------------
  
# --- Identifying all unique response categories from SRQ items ---
unique_srq_responses <- new_data %>%
  select(starts_with("srq_")) %>%
  unlist() %>%
  unique()
print(unique_srq_responses)

# --- Cleaning SRQ responses ---
# --- Changing NA responses to 0 ---

new_data <- new_data %>%
  mutate(across(starts_with("srq_"), ~ as.integer(!is.na(.))))

head(select(new_data, starts_with("srq_")))
new_data$total_srq

# --- Checking the types ---
sapply(select(new_data, starts_with("iat_")), class)
sapply(select(new_data, starts_with("srq_")), class)

-----------------------------------------------------------------------
  
# --- Saving clean data ---
dir.create(here("data"), showWarnings = FALSE)
write.csv(new_data, here("data", "Internet_Addiction_Malawi_Data_clean.csv"))




