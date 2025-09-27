# --- Installing equired packages ---
renv::install(c("readr","dplyr","stringr","janitor","here", "tidyr"))

# --- Loading equired packages ---

library(readr)  # for reading csv files
library(dplyr)  # for data manipulation
library(stringr)  # for handling string data
library(janitor)  # for easy data cleaning
library(here)  # for reliable paths across projects
library(tidyr)  # for reshaping data

# --- Reading raw data ---
raw_data <- read_csv(here("data-raw", "Internet_Addiction_Malawi_Data.csv"))

# --- Quick checking ---
glimpse(raw_data)
head(raw_data)

# --- Checking original column names ---
colnames(raw_data)

# --- Renaming columns for readability ---
new_data <- raw_data %>%
  rename(
    id=SN, 
    gender=Gender, 
    age=`Age group`, 
    institution_name = `University/College`, 
    study_level= `Level of Study`, 
    year_of_study = `Indicate your year of study`, 
    discipline=`Indicate your discipline of study`, 
    srq_total=...48)

colnames(new_data) [8:27] <- paste0("iat_", 1:20)
colnames(new_data) [28:47] <- paste0("srq_", 1:20)
colnames(new_data)

# --- Identifying all unique response categories from IAT items ---
unique_iat_responses <- new_data %>%
  select(starts_with("iat_")) %>%
  unlist() %>%
  unique()
print(unique_iat_responses)
  

# --- Cleaning IAT Responses ---

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


# --- Identifying all unique response categories from SRQ items ---
unique_srq_responses <- new_data %>%
  select(starts_with("srq_")) %>%
  unlist() %>%
  unique()
print(unique_srq_responses)


# --- Cleaning SRQ Responses ---
# Changing NA responses to 0

new_data <- new_data %>%
  mutate(across(starts_with("srq_"), ~ as.integer(!is.na(.))))

head(select(new_data, starts_with("srq_")))

# --- Checking the Types ---
sapply(select(new_data, starts_with("iat_")), class)
sapply(select(new_data, starts_with("srq_")), class)

# --- Saving Clean Data ---
dir.create(here("data"), showWarnings = FALSE)
write_csv(new_data, here("data", "Internet_Addiction_Malawi_Data_clean.csv"))




