#======================================================================

# --- Project 01: Internet Addiction and Common Mental Disorders Among Students ---
# --- Script: 03_data_explore_and_describe.R ---

#======================================================================

# --- Purpose: ---
#   - Explore and describe the cleaned dataset.
#   - Generate descriptive statistics for IAT, SRQ, and CMD variables.
#   - Summarize demographic variables (gender, age group, study level, discipline).
#   - Visualize distributions and relationships using plots and tables.
#   - Save summary tables and figures for reporting.
#
#   This script provides an overview of the data before modeling.

#======================================================================

# --- Setting the environment ---
setwd(here::here())

#======================================================================

# --- Looking at data ---
View(data_internet)
head(data_internet)
summary(data_internet)

#======================================================================

# --- Checking variable types ---
str(data_internet)

#======================================================================

# --- Descriptive statistics for numeric variables ---

#======================================================================

# --- Creating IAT and SRQ total scores ---

data_internet <- data_internet %>%
  mutate(
    total_iat = rowSums(select(., starts_with("iat_")), na.rm = TRUE),
    total_srq = rowSums(select(., starts_with("srq_")), na.rm = TRUE))
         
numeric_summary <- describe(select(data_internet, total_iat, total_srq))
numeric_summary

#======================================================================

# --- Frequency tables for categorical variables ---
# --- gender ---
gender_table <- data_internet %>%
  count(gender)
print(gender_table)

# --- age_group ---
age_table <- data_internet %>%
  count(age_group)
print(age_table)

# --- study_level ---
study_table <- data_internet %>%
  count(study_level)
print(study_table)

# --- year_of_study ---
year_table <- data_internet %>%
  count(year_of_study)
print(year_table)

# --- Saving them separately ---
write.csv(gender_table,"reports/freq_gender.csv", row.names = FALSE)
write.csv(age_table, "reports/freq_age.csv", row.names = FALSE)
write.csv(study_table, "reports/freq_study.csv", row.names = FALSE)
write.csv(year_table, "reports/freq_year.csv", row.names = FALSE)

#======================================================================

# --- Histogram of total_iat (Internet Addiction) ---
ggplot(data_internet, aes(x= total_iat)) +
  geom_histogram(binwidth = 5, fill="blue", color = "black") +
  labs (title = " Distribution of Internet Addiction Scores (IAT)", x= "IAT Total Score", y="Number of Students")
ggsave("reports/hist_IAT.png")

#======================================================================

# --- Histogram of total_srq (Common Mental Disorder score) ---
ggplot(data_internet, aes(x = total_srq)) +
  geom_histogram(binwidth = 2, fill = "red", color = "black") +
  labs(title = "Distribution of SRQ-20 Scores", x = "SRQ-20 Total Score", y = "Number of Students")
ggsave("reports/hist_srq.png")

# Boxplot of IAT by CMD status
# --- CMD is defined as SRQ20_total >= 8 ---
# --- Identifying students with probable mental disorder ---
data_internet <- data_internet %>%
  mutate(CMD = ifelse(total_srq >= 8, "Yes", "No"))


ggplot(data_internet, aes(x = CMD, y = total_iat, fill = CMD)) +
  geom_boxplot() +
  labs(title = "Internet Addiction Scores by CMD Status", x = "Probable CMD (SRQ-20 ≥ 8)", y = "IAT Total Score")
ggsave("reports/box-IAT-by-CMD.png")

#======================================================================

# --- Relationship between categorical variables ---

# --- 1. CMD Prevalence by Gender ---
cmd_gender <- data_internet %>%
  group_by(gender, CMD) %>%
  summarise(n = n()) %>%
  mutate(percent = round(100 * n / sum(n), 1))

print(cmd_gender)

# --- Visualize CMD * gender as stacked bar chart ---
ggplot(cmd_gender, aes(x = gender, y = percent, fill = CMD)) +
  geom_bar(stat = "identity", position = "stack") +
  labs(title = "Prevalence of CMD by Gender", x = "Gender", y = "Percentage of Students")
ggsave("reports/bar_CMD_by_gender.png")

#----------------------------------------------------------------------

# --- 2. CMD Prevalence by Age_group ---
cmd_age <- data_internet %>%
  group_by(age_group, CMD) %>%
  summarise(n = n()) %>%
  mutate(percent = round(100 * n / sum(n), 1))

print(cmd_age)

ggplot(cmd_age, aes(x = age_group, y = percent, fill = CMD)) +
  geom_bar(stat = "identity", position = "stack") +
  labs(title = "Prevalence of CMD by Age Band", x = "Age Group", y = "Percentage of Students")

ggsave("reports/bar_CMD_by_age.png")

#----------------------------------------------------------------------

# --- 3. CMD Prevalence by Study Level ---
cmd_degree <- data_internet %>%
  group_by(study_level, CMD) %>%
  summarise(n = n()) %>%
  mutate(percent = round(100 * n / sum(n), 1))

print(cmd_degree)

ggplot(cmd_degree, aes(x = study_level, y = percent, fill = CMD)) +
  geom_bar(stat = "identity", position = "stack") +
  labs(title = "Prevalence of CMD by Degree Level", x = "Degree Level", y = "Percentage of Students")

ggsave("reports/bar_CMD_by_study_level.png")

#----------------------------------------------------------------------

# --- 4. CMD Prevalence by Discipline ---
cmd_discipline <- data_internet %>%
  group_by(discipline, CMD) %>%
  summarise(n = n()) %>%
  mutate(percent = round(100 * n / sum(n), 1))

print(cmd_discipline)

ggplot(cmd_discipline, aes(x = discipline, y = percent, fill = CMD)) +
  geom_bar(stat = "identity", position = "stack") +
  labs(title = "Prevalence of CMD by Discipline", x = "Discipline", y = "Percentage of Students") 
  
ggsave("reports/bar_CMD_bar_discipline.png")

#----------------------------------------------------------------------

# --- 5. CMD prevalence by Year of Study ---
cmd_year <- data_internet %>%
  group_by(year_of_study, CMD) %>%
  summarise(n = n()) %>%
  mutate(percent = round(100 * n / sum(n), 1))

print(cmd_year)

ggplot(cmd_year, aes(x = year_of_study, y = percent, fill = CMD)) +
  geom_bar(stat = "identity", position = "stack") +
  labs(title = "Prevalence of CMD by Year of Study", x = "Year of Study", y = "Percentage of Students")

ggsave("reports/bar_CMD_by_year.png")

#======================================================================

# --- Correlation between continuous variables ---

# --- total_iat vs total_srq ---
correlation <- cor(data_internet$total_iat, data_internet$total_srq, use = "complete.obs")
print(paste("Correlation between IAT and SRQ-20:", round(correlation, 3)))

# --- Visualize with scatter plot ---
ggplot(data_internet, aes(x = total_iat, y =total_srq)) +
  geom_point(color = "darkblue", alpha = 0.6) +
  geom_smooth(method = "lm", color = "red", se = TRUE) +
  labs(title = "Relationship between Internet Addiction and Mental Disorder Scores", x = "Internet Addiction Test (IAT) Score", y = "SRQ-20 Score")

ggsave("reports/scatter_IAT_vs_SRQ20.png")

#======================================================================

# --- End of Script 03 ---

#======================================================================

