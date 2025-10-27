# Students’ Internet Addiction

## Overview
This project analyzes open data on the link between **Internet Addiction** and **mental health** among college students in Malawi.  
We build on the original study by:

- Evaluating the factor structure and measurement invariance of the Internet Addiction Test (IAT).
- Modeling the (potentially non-linear) association between IAT and Common Mental Disorder (CMD; SRQ-20) using modern, reproducible R workflows.

---

## Prior Study Summary (Original Dataset)

**Aim:**  
To examine the link between Internet Addiction (IAT) and Common Mental Disorder (CMD; SRQ-20) among Malawian tertiary students.

**Design:**  
Cross-sectional survey (May–July 2018).

**Setting & Participants:**  
13 higher-education institutions across Malawi; **n = 984** students (undergraduate + postgraduate; science and humanities/social sciences).

**Sampling:**  
Institutions identified from public/private HEIs; simple random sampling (SRS) where all-student mailing lists existed; snowball link distribution and paper surveys used where needed.

**Data Collection:**  
Google Forms (with “limit to 1 response” enabled); paper questionnaires for students with limited internet access; paper entries double-entered to spreadsheet.

**Measures:**
- **Internet Addiction Test (IAT):** 20 items, 0–5 Likert scale, measuring problematic internet use.  
- **Self-Reporting Questionnaire (SRQ-20):** 20 yes/no items; probable CMD defined at cutoff ≥ 8.  
- **Demographics & Use:** gender, age band, level of study (UG/PG), discipline, and internet/social-media use indicators.

**Data Access:**  
Publicly available via Mendeley Data (DOI: [10.17632/xbfbcy5bhv.3](https://doi.org/10.17632/xbfbcy5bhv.3)) and described in the *Journal of Open Psychology Data* ([10.5334/jopd.72](https://doi.org/10.5334/jopd.72)).  
Raw data are **not re-distributed** in this repository; they are downloaded automatically at build time.

---

## Source & Citation

- **Data Paper:** *Data from “Internet Addiction and Mental Health among College Students in Malawi”*, *Journal of Open Psychology Data.*  
  DOI: [10.5334/jopd.72](https://doi.org/10.5334/jopd.72)
- **Dataset:** Mendeley Data, DOI: [10.17632/xbfbcy5bhv.3](https://doi.org/10.17632/xbfbcy5bhv.3)
- **Instruments:** Internet Addiction Test (IAT), Self-Reporting Questionnaire (SRQ-20)
- See [data/README.md](data/README.md) for the full variable dictionary.

**Citation:**  
Mwakilama, E. P., Jamu, E. S., Senganimalunje, L., & Manda, T. D. (2022). *Data on Internet Addiction and Mental Health among University Students in Malawi* (Version 3) [Data set]. Mendeley Data. [https://doi.org/10.17632/xbfbcy5bhv.3](https://doi.org/10.17632/xbfbcy5bhv.3)

---

## Research Objectives

- Validate the psychometric properties of the Internet Addiction Test (IAT).
- Examine the relationship between IAT scores and probable Common Mental Disorder (CMD).
- Explore the effects of demographic variables on mental health outcomes.

---

## Repository Structure

| Folder/File | Description |
|--------------|-------------|
| [R/00_download_data.R](R/00_download_data.R) | Script to download and prepare raw data for analysis. |
| [R/01_clean_score.R](R/01_clean_score.R) | Cleans and preprocesses data, computes IAT and CMD scores. |
| [R/02_setup_and_load.R](R/02_setup_and_load.R) | Loads cleaned data and initializes libraries/environment. |
| [R/03_data_explore_describe.R](R/03_data_explore_describe.R) | Performs exploratory data analysis and descriptive statistics. |
| [R/04_statistical_analysis.R](R/04_statistical_analysis.R) | Fits regression models and performs hypothesis testing. |
| [R/05_results_interpretation_reporting.R](R/05_results_interpretation_reporting.R) | Generates summary tables, plots, and final reports. |
| [data/](data/) | Contains anonymized, cleaned datasets and variable dictionary. |
| [reports/](reports/) | Includes output reports, visualizations, and model summaries. |
| [README.md](README.md) | This documentation file. |

---

## How to Use This Repository

### Prerequisites

- R (version 4.0 or higher)  
- RStudio IDE (recommended)  
- Required R packages (managed via `renv` or installed manually)

### Getting Started

1. Clone the repository:

   ```bash
   git clone https://github.com/Negar-Psy/psychology-data-analysis-R.git
   ```

2. Open the project in **RStudio**.

3. Install required packages if needed:

   ```r
   install.packages(c(
     "dplyr", "ggplot2", "broom", "gt", "gtsummary", 
     "readr", "rmarkdown", "quarto"
   ))
   ```

4. Execute scripts in order to reproduce the analysis:

   ```text
   R/00_download_data.R                # Download raw data
   R/01_clean_score.R                  # Clean & score data
   R/02_setup_and_load.R               # Load prepared data
   R/03_data_explore_describe.R        # Explore & describe data
   R/04_statistical_analysis.R         # Model analysis
   R/05_results_interpretation_reporting.R  # Generate reports
   ```

5. Render the interactive report using **Quarto**:

   ```r
   quarto::quarto_render("report.qmd")
   ```

6. View outputs in the [`reports/`](reports/) folder (tables, plots, summaries).

---

## Contribution

Contributions, issues, and feature requests are welcome!  
Please **fork** the repository and submit a **pull request** for collaborative improvements.

---

## License

This project is licensed under the **MIT License**.  
See the [LICENSE](../LICENSE) file for details.











